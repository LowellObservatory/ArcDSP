; This file is used to generate DSP code for the Gen III ARC-22/32/47 
;    board set.    
;
; This file contains two subroutines and X and Y data areas.  The two
; subroutines are RDCCD (with secondary entry point RCCD1) and CLOCK.
; These need to be in fast P memory.  The boot code and tim.s are there.
; tim.s includes timmisc.s, timCCDmisc.s and the waveforms file at the
; end.

	PAGE    132     ; Printronix page width - 132 columns

; Include a header file that defines global parameters
   
	INCLUDE "timboot.s"
	INCLUDE "timhdr.s"
	INCLUDE "infospec.s"
	INCLUDE "timinfospec.s"
	INCLUDE "timinfo.s"
; this need to be defined externally due to a problem in timboot.s
; as per Confluence, July 6, #1
EXPOSING                EQU     TST_RCV         ; Address if exposing
CONTINUE_READING        EQU     TST_RCV         ; Address if reading out

; tim capability definitions
FINDCAPABLE	EQU	1	; Find exposure mode
SNGLCAPABLE	EQU	2	; Single exposure mode
SERICAPABLE	EQU	4	; Series exposure mode
BASCCAPABLE	EQU	8	; Basic occ exposure mode
FASTCAPABLE	EQU	16	; Fast occ exposure mode
PIPECAPABLE	EQU	32	; Pipeline occ exposure mode
FDOTCAPABLE	EQU	64	; Fast dots exposure mode
SDOTCAPABLE	EQU	128	; Slow dots exposure mode
STRPCAPABLE	EQU	256	; Slow dots exposure mode
TIMCAPABLE	EQU	FINDCAPABLE+SNGLCAPABLE+STRPCAPABLE+BASCCAPABLE+FASTCAPABLE+PIPECAPABLE+FDOTCAPABLE+SDOTCAPABLE

	ORG	P:,P:

; Remove SHUTTER_CC advertisement as per Confluence July 4 #3
;CC	EQU	ARC22+ARC47+SHUTTER_CC+SPLIT_SERIAL+SUBARRAY+BINNING
CC	EQU	ARC22+ARC47+SPLIT_SERIAL+SUBARRAY+BINNING

; Put number of words of application in P: for loading application from EEPROM
	DC	TIMBOOT_X_MEMORY-@LCV(L)-1

;**************************************************************************
;                   	                                                  *
;    Permanent address register assignments                               *
;	 R1 - Address of SSI receiver contents				  *
;	 R2 - Address of SCI receiver contents				  *
;        R3 - Pointer to current top of command buffer                    *
;        R4 - Pointer to processed contents of command buffer		  *
;        R5 - Temporary register for processing SSI and SCI contents      *
;        R6 - CCD clock driver address for CCD #0 = $FF80                 *
;                It is also the A/D address of analog board #0            *
;        R6 CURRENTLY UNUSED (geniii)
;                                                                         *
;    Other registers                                                      *
;        R0, R7 - Temporary registers used all over the place.            *
;        R5 - Can be used as a temporary register but is circular,        *
;               modulo 32.       					  *
;**************************************************************************

;  ***********************   CCD  READOUT   ***********************
; RDCCD is now a subroutine
; Adding several CLOCK_WAITs as per Jun 29 #8.

RDCCD	
	JSET	#STORAGE,X:ISTATUS,RCCD1
; Do the frame transfer if STORAGE==0, else skip it.
	MOVE	Y:<S_SIZE,X1
	JSR	<CLOCK_WAIT
	JSR	ISHIFT		; Do the frame transfer

; Calculate some readout parameters.  
; This is also an alternative entry point for skipping the frame transfer
; STORAGE also selects ganged or storage only parallels during readout
; NO_SKIP skips over the section that parallel skips to the subframe start

RCCD1	MOVE	Y:<NBOXES,A		; NBOXES = 0 => full image readout
	TST	A
	JNE	<SUB_IMG
	MOVE	A1,Y:<NP_SKIP		; Zero these all out.  Full frame
	MOVE	A1,Y:<NS_SKP1
	MOVE	A1,Y:<NS_SKP2
	MOVE	Y:<NSR,A		; NSERIALS_READ = NSR
	JCLR	#SPLIT_S,X:STATUS,*+3
	ASR		A			; Split serials require / 2
	NOP
	MOVE	A,Y:<NSERIALS_READ	; Number of columns in each subimage
	JMP		<SETUP

; Loop over the required number of subimage boxes if NBOXES > 0
SUB_IMG	MOVE	#READ_TABLE,R7		; Parameter table for subimage readout
	DO	Y:<NBOXES,L_NBOXES	; Loop over number of boxes
	MOVE	Y:(R7)+,X0
	MOVE	X0,Y:<NP_SKIP
	MOVE	Y:(R7)+,X0
	MOVE	X0,Y:<NS_SKP1
	MOVE	Y:(R7)+,X0
	MOVE	X0,Y:<NS_SKP2
	MOVE	Y:<NS_READ,A
	JCLR	#SPLIT_S,X:STATUS,*+3	; Split serials require / 2
	ASR		A
	NOP
	MOVE	A,Y:<NSERIALS_READ	; Number of columns in each subimage

; Calculate the fast readout parameters
SETUP	JSR	<SETUP_SUBROUTINE
	JSR	<CLOCK_WAIT

; Skip over the required number of rows for subimage readout
; If #NO_SKIP == 0 skip rows up to first subframe, storage clocks only
	JSET	#NO_SKIP,X:ISTATUS,CLR_SR	
	MOVE	Y:<NP_SKIP,A		; Number of rows NP_SKIP to skip
	TST	A
	JEQ	<CLR_SR			; If zero, skip this shift
	DO      Y:<NP_SKIP,L_SKIP1	; Clock number of rows to skip
	MOVE    #<S_CLEAR,R0		; SR kept clear with DG
	JSR     <CLOCK
	NOP
L_SKIP1

; Clear out the accumulated charge from the serial shift register 
; Leave this commented-out code in until we can test it with a subframe
; CLR_SR MOVE	#(END_SERIAL_SKIP_LEFT-SERIAL_SKIP_LEFT-1),M1 ; Modularity
;	MOVE	Y:<SERIAL_SKIP,R1	; Waveform table starting address
;	NOP
;	MOVE    Y:(R1)+,A       	; Start the pipeline
;	DO	Y:<NSCLR,*+3		; Number of waveform entries total
;	MOVE    A,X:(R6) Y:(R1)+,A      ; Send out the waveform
;	MOVE    A,X:(R6)        	; Flush out the pipeline

CLR_SR	MOVE	#DUMP_SERIAL,R0		; clear the SR after parallel skip
	JSR	<CLOCK

; Parallel shift the image into the serial shift register
	MOVE	Y:<NPR,X0		; Number of rows set by host computer
	MOVE	Y:<NBOXES,A		; NBOXES = 0 => full image readout
	TST	A
	JEQ	*+2
	MOVE	Y:<NP_READ,X0		; If NBOXES .NE. 0 use subimage table

; Main loop over each line to be read out
; If split parallels have to divide NPR by two to be loop counter
; Subimages implicitly assumes that parallels are not split
	JCLR	#SPLIT_P,X:STATUS,PLOOP	; skip this if not split parallels
	MOVE	Y:NPR,A			; Get NPR
	ASR	A			; Divide by 2
	NOP				; 56300 pipeline as per July 5 #4
	MOVE	A,X0			; Overwrite loop counter in X0

; Finally start the row loop
PLOOP	DO      X0,LPR			; Number of rows to read out

; Check for a command once per line. Only the ABORT command is allowed
;	JSR	<GET_RCV		; Was a command received?
;	JCC	<CONTINUE_RD		; If no, continue reading out
; as per Confluence July 5 #7
;	JMP	<PRC_RCV		; If yes, go process it
	JMP	<CONTINUE_RD

; Abort the readout currently underway
ABR_RDC
	CLR	A
	MOVE	Y:<TESTLOC1,A
	ADD	#1,A
        BSET    #ST_ABRT,X:<STATUS
	MOVE	A1,Y:<TESTLOC1
	
	JCLR	#ST_RDC,X:<STATUS,ABORT_EXPOSURE
; already in readout- so just fall thru and continue,
; having set the ST_ABRT flag.
; currently we just let this readout segment run to the end and
; handle the abort in the outer xxx_PROC code- this has
; the advantage of ending the overall exposure on a frame boundary
; in the case of 3-d images.
; A more abrupt ending of the RDCCD code could be arranged if needed.

;	ENDDO				; Properly terminate row loop
;	MOVE	Y:<NBOXES,A		; NBOXES = 0 => full image readout
;	TST	A
;	JEQ	*+2
;	ENDDO				; Properly terminate box loop
;	NOP
;	CLR	A
;	INC	A
;	NOP
;	MOVE	A0,Y:<IFLPCNT
;	RTS				; Return early from subroutine

; Move the row into the serial register.
CONTINUE_RD	DO      Y:<NPBIN,LPR_I  ; Transfer # of rows, with binning
	MOVE    #<IS_PARALLEL,R0
	JSET	#STORAGE,X:ISTATUS,GANGED  ; if STORAGE == 1 ganged parallels
	MOVE    #<S_PARALLEL,R0		; if STORAGE == 0 store clocks only
GANGED	JSR     <CLOCK			; Parallel clocking
	NOP
LPR_I

; Skip over NS_SKP1 columns for subimage readout
;	MOVE	Y:<NS_SKP1,A		; Number of columns to skip
	MOVE	Y:<NSKIP1,A		; Number of waveforms for skip
	TST	A
	JEQ	<L_READ
	MOVE	#<(END_SERIAL_SKIP_LEFT-SERIAL_SKIP_LEFT-1),M1 ; Modularity

;	Fix for new interface CLOCKCT 
; 	June 30 bottom "questions and comments" #2,3
	MOVE	Y:<SERIAL_SKIP,R1	; Waveform table starting address
	MOVE	A1,X0			; how many
	JSR	<CLOCKCT
;	MOVE	Y:<SERIAL_SKIP,R1	; Waveform table starting address
;	NOP
;	MOVE    Y:(R1)+,A       	; Start the pipeline
;	DO	Y:<NSKIP1,LS_SKIP1	; Number of waveform entries total
;	MOVE    A,X:(R6) Y:(R1)+,A      ; Send out the waveform
;LS_SKIP1
;	MOVE    A,X:(R6)        	; Flush out the pipeline

; Finally read some real pixels - this is the serial binning routine
L_READ  CLR	A
	CLR	B
	MOVE    Y:<NSBIN,B0             ; Serial binning parameter
	MOVE	#>6,A0			; If binning > 5, do general binning
	CMP	B,A			; else do special waveforms via NO_BIN
        JGT     <NO_BIN                 ; Skip over general serial binning software
	DEC	B			; serial binning factor minus 1
	NOP				; 56300 pipeline as per July 5 #4
	MOVE	B0,Y1
        DO      Y:<NSERIALS_READ,LSR_BIN ; Number of pixels to read out
        MOVE    Y:<INITIAL_CLOCK,R0	; (already /2 if split serials)
        JSR     <CLOCK
;       DO      Y:<NSBIN,LSR_I          ; Bin serially NSBIN times
        DO      Y1,LSR_I          	; Bin serially NSBIN times
        MOVE    Y:<SERIAL_CLOCK,R0      ; Clock the charge in the serial
        JSR     <CLOCK                  ;   shift register
        NOP
LSR_I
        MOVE    #VIDEO_PROCESS,R0       ; Video process the binned pixel
        JSR     <CLOCK
;	MOVE	Y1,Y:<INTERVAL		; HACK.  Use for debugging
        NOP
LSR_BIN
        JMP     <OVER_RD                ; All done binning

; This is the routine for serial binning from 1 to 5 using hardwired waveforms
NO_BIN  MOVE    Y:<SERWAVLEN,A0         ; Put length of serial read
        DEC     A                       ; waveform - 1 into M1
	MOVE	#<SERIAL_READ,R1	; Waveform table starting address
        MOVE    A0,M1                   ; Modularity
;	Fix for new interface CLOCKCT 
; 	June 30 bottom "questions and comments" #2,3
	MOVE	Y:<NREAD,X0			; how many
	JSR	<CLOCKCT
;	NOP
;	MOVE    Y:(R1)+,A       	; Start the pipeline
;	DO	Y:<NREAD,LSR		; Number of waveform entries total
;	MOVE    A,X:(R6) Y:(R1)+,A      ; Send out the waveform
;LSR
;	MOVE    A,X:(R6)        	; Flush out the pipeline

; If NR_BIAS=0 clobber SR with DG and skip to end of row loop
OVER_RD	MOVE	Y:<NR_BIAS,A		; Is NR_BIAS zero?
	TST	A
	JNE	<OVR_RD1		; no, go to the NS_SKP2 section
	MOVE	#DUMP_SERIAL,R0		; yes, clobber SR with DG
	JSR	<CLOCK
	JMP	END_ROW			; and go to the end of the row loop
; Skip over NS_SKP2 columns for subimage readout to get to overscan region
OVR_RD1	MOVE	Y:<NS_SKP2,A		; Number of columns to skip
	TST	A
	JEQ	<L_BIAS
	MOVE	#<(END_SERIAL_SKIP_LEFT-SERIAL_SKIP_LEFT-1),M1 ; Modularity
	MOVE	Y:<SERIAL_SKIP,R1	; Waveform table starting address
;	Fix for new interface CLOCKCT 
; 	June 30 bottom "questions and comments" #2,3
	MOVE	Y:<NSKIP2,X0			; how many
	JSR	<CLOCKCT
;	NOP
;	MOVE    Y:(R1)+,A       	; Start the pipeline
;	DO	Y:<NSKIP2,LS_SKIP2	; Number of waveform entries total
;	MOVE    A,X:(R6) Y:(R1)+,A      ; Send out the waveform
;LS_SKIP2
;	MOVE    A,X:(R6)        	; Flush out the pipeline

; And read the bias pixels if in subimage readout mode
; I think this means that if NBOXES==0 you have to have NSR include bias px.
L_BIAS	MOVE	Y:<NBOXES,A		; NBOXES = 0 => full image readout
	TST	A
	JEQ	<END_ROW

; Finally read some real bias pixels
	CLR	A
	CLR	B
	MOVE    Y:<NSBIN,B0             ; Serial binning parameter
	MOVE	#>6,A0			; If binning > 5, do general binning
	CMP	B,A			; else do special waveforms via NO_BIN_BIAS
        JGT     <NO_BIN_BIAS            ; Skip over general serial binning software
	DEC	B			; serial binning factor minus 1
        MOVE    Y:<NR_BIAS,A
        ASR     A                       ; Split serials require / 2
	MOVE	B0,Y1
        JCLR    #SPLIT_S,X:STATUS,*+3
        DO      A,LBIAS_BIN             ; Number of pixels to read out
        MOVE    Y:<INITIAL_CLOCK,R0
        JSR     <CLOCK
        DO      Y1,LBIAS_I        ; Bin serially NSBIN times
;       DO      Y:<NSBIN,LBIAS_I        ; Bin serially NSBIN times
        MOVE    Y:<SERIAL_CLOCK,R0      ; Clock the charge in the serial
        JSR     <CLOCK                  ;   shift register
        NOP
LBIAS_I
        MOVE    #VIDEO_PROCESS,R0       ; Video process the binned pixel
        JSR     <CLOCK
        NOP
LBIAS_BIN
        JMP     <END_ROW                ; All done binning

; This is the routine for serial binning from 1 to 5 using hardwired waveforms
; NBIAS is already divided by 2 in SETUP_SUBROUTINE if split serials.
NO_BIN_BIAS
        MOVE    Y:<SERWAVLEN,A0         ; Put length of serial read
        DEC     A                       ; waveform - 1 into M1
	MOVE	#<SERIAL_READ,R1	; Waveform table starting address
        MOVE    A0,M1                   ; Modularity
;	Fix for new interface CLOCKCT 
; 	June 30 bottom "questions and comments" #2,3
	MOVE	Y:<NBIAS,X0			; how many
	JSR	<CLOCKCT
;	NOP
;	MOVE    Y:(R1)+,A       	; Start the pipeline
;	DO	Y:<NBIAS,*+3		; Number of waveform entries total
;	MOVE    A,X:(R6) Y:(R1)+,A      ; Send out the waveform
;	MOVE    A,X:(R6)        	; Flush out the pipeline
END_ROW	NOP
LPR	NOP				; End of parallel loop
L_NBOXES NOP				; End of subimage boxes loop
	NOP
	MOVE	#<DCRST_LAST,R0		; get DC Restore going
	JSR	<CLOCK
	JSR	<CLOCK_WAIT
	MOVE	#<IMO_LAST_CLOCK,R0		; set clocks to 0
	JSR	<CLOCK
	JSR	<CLOCK_WAIT
	RTS

; ***************** END OF CCD READOUT SUBROUTINE  ************

; Core subroutine for clocking out CCD charge
; Must keep in tim.s to insure that it is in fast P memory
; Modified for FIFO magement and new processor as per
; June 30 bottom "questions and comments" #2,3

; CLOCK assumes waveform in R0, which begins with a count field
; NOTE: in geniii, this count is 1 larger than genii because it
; is a straight count of the # of points in the wave- gen-ii
; needed a count 1 smaller since there was a pipeline that was
; primed with a starter pixel.
CLOCK
        JCLR    #SSFHF,X:HDR,*          ; Don't overfill the WRSS FIFO
	REP	Y:(R0)+
	MOVEP	Y:(R0)+,Y:WRSS		; next piece of the waveform
	NOP				; just in case
	RTS

; CLOCKCT assumes waveform in R1, without a count field, and the
; count in X0, and modulus counter in M1.
; In order to manage the FIFO (SSFHF) we copy the wave out in a block of 16 pts
; at a time. The SSFHF check happens at the start of each block.
; Note that count in X0 is again a straight count requiring a fix to FASTSKP
; CLOCKCT trashes A
CLOCKCT
	CLR	A
	MOVE	X0,A
CLKBLKFULL
	; see if we can do a full block in the waveform.
	CMP	#16,A
	JLT	<CLKBLKREM
	; 16 or more points remain
        JCLR    #SSFHF,X:HDR,*          ; Don't overfill the WRSS FIFO
	REP	#16
	MOVEP	Y:(R1)+,Y:WRSS		; next modulo piece of the waveform
	SUB	#16,A
	JMP	<CLKBLKFULL
CLKBLKREM
	; last little bit..
	TST	A
	JLE	<CLOCK1			; no it divided evenly so all done--
	; do the remainder of 1 to 15 pts.
        JCLR    #SSFHF,X:HDR,*          ; Don't overfill the WRSS FIFO
	DO	A,CLOCK1
	MOVEP	Y:(R1)+,Y:WRSS		; next modulo piece of the waveform
CLOCK1
	NOP				; just in case
	RTS

;CLOCK   MOVE    Y:(R0)+,X0      	; # of waveform entries 
;        MOVE    Y:(R0)+,A       	; Start the pipeline
;        DO      X0,CLK1                 ; Repeat X0 times
;        MOVE    A,X:(R6) Y:(R0)+,A      ; Send out the waveform
;CLK1
;        MOVE    A,X:(R6)        	; Flush out the pipeline
;        RTS                     	; Return from subroutine

; Include miscellaneous timing commands
        INCLUDE "timmisc.s"				; Custom
        INCLUDE "timCCDmisc.s"			; Generic

TIMBOOT_X_MEMORY	EQU	@LCV(L)

;  ****************  Setup memory tables in X: space ********************

; Define the address in P: space where the table of constants begins

	IF	@SCP("DOWNLOAD","HOST")
	ORG     X:END_COMMAND_TABLE,X:END_COMMAND_TABLE
	ENDIF

	IF	@SCP("DOWNLOAD","ROM")
	ORG     X:END_COMMAND_TABLE,P:
	ENDIF

	DC	'IDL',IDL  		; Put CCD in IDLE mode    
; Remove for gen-iii since it is in timboot as per June 30 #9
;	DC	'STP',STP  		; Exit IDLE mode
	DC	'SVR',SETVRDS		; set VRD2,3
	DC	'SBV',SETBIAS 		; Set DC bias supply voltages  
	DC	'RDC',RDCCD 		; Begin CCD readout    
	DC	'CLR',CLEAR  		; Fast clear the CCD   
	DC	'SGN',ST_GAIN  		; Set video processor gain     
	DC  'SMX',SET_MUX       ; Set clock driver MUX output

	DC	'ABR',ABR_RDC		; Abort readout
	DC	'CRD',CONT_RD		; Continue reading out
	DC	'CSW',CLR_SWS		; Clear analog switches to lower power
	DC	'SOS',SEL_OS		; Select output source
	DC	'RCC',READ_CONTROLLER_CONFIGURATION 
	DC	'SSS',SET_SUBARRAY_SIZES
	DC	'SSP',SET_SUBARRAY_POSITIONS
	DC	'DON',START		; Nothing special
	DC	'OSH',OPEN_SHUTTER
	DC	'CSH',CLOSE_SHUTTER
	DC	'PON',PWR_ON		; Turn on all camera biases and clocks
	DC	'POF',PWR_OFF		; Turn +/- 15V power supplies off
	DC	'SET',SET_EXP_TIME 	; Set exposure time
	DC	'SEX',START_FT_EXPOSURE	; Goes to mode-dependent jump table
	DC	'AEX',ABORT_EXPOSURE
	DC	'STG',SET_TRIGGER	;  Set Trigger Mode on or off
	DC	'SIP',SET_IMAGE_PARAM
	DC	'SRC',SET_ROWS_COLUMNS ; Set NSR, NPR, and binning
	DC	'INF',GET_INFO		; info command for versioning and more
	
END_APPLICATON_COMMAND_TABLE	EQU	@LCV(L)

	IF	@SCP("DOWNLOAD","HOST")
NUM_COM	EQU	(@LCV(R)-COM_TBL_R)/2	; No. of boot & application commands
;EXPOSING                EQU     CHK_TIM                 ; Address if exposing
;CONTINUE_READING        EQU     RDCCD                   ; Address if reading out
	ENDIF

; ***********  DATA AREAS - READOUT PARAMETERS AND WAVEFORMS  ************
        IF      @SCP("DOWNLOAD","HOST")
        ORG     X:IMGVAR_ADR,X:IMGVAR_ADR
IMAGE_MODE      DC      0
; ISTATUS			DC		0
; bum an unused location in low X: for ISTATUS so JSETs work
; as per Confluence July 5 #3
ISTATUS		EQU	EXP_ADR		; dangerous!

; some X: variables removed as per Confluence July 1 #4
;DSP_VERS	DC	VERSION ; code version must stay in loc,n 102!!
;DSP_FLAV	DC	FLAVOR ;  type of dsp support must stay in loc,n 103!!
; The next three locations are for tracking the readout timing for gain
; calculation, exp-int calculation, and greed factor calculation
; They are locations 0x104, 105, and 106
;INTTIM		DC	INT_TIM ; per-pixel integration in Leach units
;RDELAY		DC	R_DELAY ; serial overlap in Leach units
;SIDELAY		DC	SI_DELAY ; parallel overlap in Leach units

;BINBIT		DC	2	; Bit representation of bin factor, bits 1-5
				; 2 = bit 1 set. Bit zero not used.
; bum a rarely used location in low X: for BINBIT so JSETs work
; as per Confluence July 5 #5
BINBIT		EQU	C100K	; dangerous!
				; Bit representation of bin factor, bits 1-5
				; 2 = bit 1 set. Bit zero not used.
END_APPLICATION_X_MEMORY	EQU	@LCV(L)
        ENDIF           

	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:0,Y:0		; Download address
	ELSE
	ORG     Y:0,P:		; EEPROM address continues from P: above
	ENDIF

; NSR, NPR, NSBIN, and NPBIN are set by SET_ROWS_COLUMNS
GAIN	DC	0		; Video processor gain and integrator speed
NSR     DC      280   	 	; Number Serial Read, prescan + image + bias
NPR     DC      264	     	; Number Parallel Read
NS_CLR	DC      280 		; To clear serial register, twice
NPCLR   DC      528	    	; To clear parallel register, twice 
NSBIN   DC      1       	; Serial binning parameter
NPBIN   DC      1       	; Parallel binning parameter
NROWS	DC	264		; Number of physical rows in CCD
NCOLS	DC	280		; Number of physical columns in CCD

; Miscellaneous definitions
; Delete TST_DAT since it isn't used.  Need the space so S_SIZE doesn't barf.
; TST_DAT	DC	0		; Temporary definition for test images
SH_DEL	DC	3		; Delay in milliseconds between shutter closing 
				;   and image readout.  Actual delay is 1.5x
				;   as long as advertised, e.g. 4.5 ms for 3.
CONFIG	DC	CC		; Controller configuration
; Readout peculiarity parameters
SERIAL_SKIP 	DC	SERIAL_SKIP_LEFT	; Serial skipping waveforms
SERWAVLEN	DC	5			; Serial read waveform table length
SERIAL_CLOCK	DC	SERIAL_CLOCK_LEFT	; Serial waveform table
INITIAL_CLOCK	DC	INITIAL_CLOCK_LEFT	; Serial waveform table
PARALLEL_CLOCK	DC	IS_PARALLEL		; Addr. of parallel clocking

NSERIALS_READ	DC	0		; Number of serials to read
NSCLR		DC	0		; Number of waveforms in fast mode
NSKIP1		DC	0		; Number of waveforms in fast mode
NREAD		DC	0		; Number of waveforms in fast mode
NSKIP2		DC	0		; Number of waveforms in fast mode
NBIAS		DC	0		; Number of waveforms in fast mode

; These three parameters are read from the READ_TABLE when needed by the
;   RDCCD routine as it loops through the required number of boxes
NP_SKIP		DC	0	; Number of rows to skip
NS_SKP1		DC	0	; Number of serials to clear before read
NS_SKP2		DC	0	; Number of serials to clear after read

; Subimage readout parameters. Ten subimage boxes maximum.
; All subimage boxes are the same size, NS_READ x NP_READ
; NR_BIAS, NS_READ, and NP_READ are set by SET_SUBARRAY_SIZES
; The READ_TABLE entries and implicitly NBOXES are set by SET_SUBARRAY_POSITIONS
NBOXES	DC	0		; Number of boxes to read
NR_BIAS	DC	0		; Number of bias pixels to read
NS_READ	DC	0		; Number of columns per box
NP_READ	DC	0		; Number of rows per box
READ_TABLE DC	0,0,0		; #1 = Number of rows to clear, 
	DC	0,0,0		; #2 = Number of columns to skip before 
	DC	0,0,0		;   subimage read 
	DC	0,0,0		; #3 = Number of columns to clear after 
	DC	0,0,0		;   subimage read to get to overscan area
	DC	0,0,0
	DC	0,0,0
	DC	0,0,0
	DC	0,0,0
	
; IMAGE_MODE, SROWS, IFRAMES, and INTERVAL are set by SET_IMAGE_PARAM
; UBSROWS is set later on by UB_CONV.  S_SIZE is hardwired.
SROWS           DC      1       ; Number of Storage image rows to Loop over
UBSROWS		DC	1	; SROWS in unbinned pixels.  Set by UB_CONV
IFRAMES         DC      1       ; Number of Series frames to Loop over
S_SIZE		DC	264	; Number of rows in the Storage Array
				; NOTE: Not equal to # rows in image area!
INTERVAL        DC      7       ; Interval to pause for soft trigger 
AMPVAL		DC	0	; Amplifier selected
IFLPCNT		DC	0	; 24-bit IFRAMES loop counter for timmisc.s
TESTLOC1	DC	0	; Test location
; NOTE:  TESTLOC1 is address 63 in the Y memory.  There are addressing problems
; starting at the next address (64).

; Include the waveform table
	IF	@SCP("IMOMODE","IMO")
	INCLUDE "GWAVES.waveforms.IMO.s" ; Readout and clocking waveforms
	ELSE
	INCLUDE "GWAVES.waveforms.s" ; Readout and clocking waveforms
	ENDIF

END_APPLICATON_Y_MEMORY	EQU	@LCV(L)

;  End of program
	END

