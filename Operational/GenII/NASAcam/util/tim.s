; Source code for reading out an e2v CCD42-40 device for NASAcam

	PAGE    132     ; Printronix page width - 132 columns

; Define a section name so it doesn't conflict with other application programs
	SECTION	TIM

; Include a header file that defines global parameters
	INCLUDE "timhdr.s"

; Define the application number and controller configuration bits
APL_NUM	EQU	0	; Application number from 0 to 3
CC	EQU	CCDVIDREV3B+TIMREV4+UTILREV3+SHUTTER_CC+TEMP_POLY+SUBARRAY+BINNING+SPLIT_PARALLEL

; Include miscellaneous timing commands
        INCLUDE "timmisc.s"				; Custom
        INCLUDE "timCCDmisc.s"			; Generic 

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
;                                                                         *
;    Other registers                                                      *
;        R0, R7 - Temporary registers used all over the place.            *
;        R5 - Can be used as a temporary register but is circular,        *
;               modulo 32.       					  *
;**************************************************************************

; Specify execution and load addresses
	IF	@SCP("DOWNLOAD","HOST")
	ORG	P:APL_ADR,P:APL_ADR		; Download address
	ELSE
	ORG     P:APL_ADR,P:APL_NUM*N_W_APL	; EEPROM address
	ENDIF

;  ***********************   CCD  READOUT   ***********************
; Overall loop - transfer and read NPR lines
RDCCD	BSET	#ST_RDC,X:<STATUS 	; Set status to reading out
	JSR	<PCI_READ_IMAGE		; Get the PCI board reading the image
	BSET	#WW,X:PBD		; Set WW = 1 for 16-bit image data
	JSET	#TST_IMG,X:STATUS,SYNTHETIC_IMAGE

; Calculate some more readout parameters
	MOVE	Y:<NBOXES,A		; NBOXES = 0 => full image readout
	TST	A
	JNE	<SUB_IMG
	MOVE	A1,Y:<NP_SKIP		; Zero these all out
	MOVE	A1,Y:<NS_SKP1
	MOVE	A1,Y:<NS_SKP2
	MOVE	Y:<NSR,A		; NSERIALS_READ = NSR
	JCLR	#SPLIT_S,X:STATUS,*+3
	ASR	A			; Split serials require / 2
	MOVE	A,Y:<NSERIALS_READ	; Number of columns in each subimage
	JMP	<SETUP

; Loop over the required number of subimage boxes
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
	ASR	A
	MOVE	A,Y:<NSERIALS_READ	; Number of columns in each subimage

; Calculate the fast read parameters
SETUP	JSR	<SETUP_SUBROUTINE

; Skip over the required number of rows for subimage readout
	MOVE	Y:<NP_SKIP,A		; Number of rows NPSKIP to skip
	TST	A
	JEQ	<CLR_SR
	DO      Y:<NP_SKIP,L_SKIP1	; Clock number of rows to skip
	MOVE    Y:PARALLEL_CLEAR,R0
	JSR     <CLOCK
	NOP
L_SKIP1

; Clear out the accumulated charge from the serial shift register 
CLR_SR	MOVE	#(END_SERIAL_SKIP_CLOCKS-SERIAL_SKIP_CLOCKS-1),M1 ; Modularity
	MOVE	Y:<SERIAL_SKIP,R1	; Waveform table starting address
	NOP
	MOVE    Y:(R1)+,A       	; Start the pipeline
	DO	Y:<NSCLR,LS_CLR		; Number of waveform entries total
	MOVE    A,X:(R6) Y:(R1)+,A      ; Send out the waveform
LS_CLR
	MOVE    A,X:(R6)        	; Flush out the pipeline

; Parallel shift the image into the serial shift register
	MOVE	Y:<NPR,X0		; Number of rows set by host computer
	MOVE	Y:<NBOXES,A		; NBOXES = 0 => full image readout
	TST	A
	JEQ	*+2
	MOVE	Y:<NP_READ,X0		; If NBOXES .NE. 0 use subimage table

; Main loop over each line to be read out
	JCLR	#SPLIT_P,X:STATUS,PLOOP	; Split Parallel require / 2
	MOVE	Y:<NPR,A
	ASR	A
	MOVE	A,X0
PLOOP	DO      X0,LPR			; Number of rows to read out

; Check for a command once per line. Only the ABORT command is allowed
	JSR	<GET_RCV		; Was a command received?
	JCC	<CONT_RD		; If no, continue reading out
	JMP	<CHK_SSI		; If yes, go process it

; Abort the readout currently underway
ABR_RDC JCLR	#ST_RDC,X:<STATUS,START	; Do nothing - we're not reading out
	ENDDO				; Properly terminate readout loop
	MOVE	Y:<NBOXES,A		; NBOXES = 0 => full image readout
	TST	A
	JEQ	*+2
	ENDDO				; Properly terminate readout loop
	JMP	<RDC_END

CONT_RD	DO      Y:<NPBIN,LPR_I  	; Transfer # of rows, with binning
	MOVE    Y:PARALLEL_CLOCK,R0
	JSR     <CLOCK  		; Go clock out the CCD charge
	NOP
LPR_I

; Skip over NS_SKP1 columns for subimage readout
	MOVE	Y:<NS_SKP1,A		; Number of columns to skip
	TST	A
	JEQ	<L_READ
	MOVE	#<(END_SERIAL_SKIP_CLOCKS-SERIAL_SKIP_CLOCKS-1),M1 ;Modularity
	MOVE	Y:<SERIAL_SKIP,R1	; Waveform table starting address
	NOP
	MOVE    Y:(R1)+,A       	; Start the pipeline
	DO	Y:<NSKIP1,LS_SKIP1	; Number of waveform entries total
	MOVE    A,X:(R6) Y:(R1)+,A      ; Send out the waveform
LS_SKIP1
	MOVE    A,X:(R6)        	; Flush out the pipeline

; Finally read some real pixels - this is the serial binning routine
L_READ	MOVE	Y:<NSBIN,B		; Serial binning parameter
	MOVE	X:<ONE,X0
	CMP	X0,B
	JEQ	<NO_BIN			; Skip over serial binning softwarebe
	DO      Y:<NSERIALS_READ,LSR_BIN ; Number of pixels to read out
	MOVE	#RESET_NODE,R0
	JSR	<CLOCK
	DO      Y:<NSBIN,LSR_I  	; Bin serially NSBIN times
	MOVE	Y:<SERIAL_CLOCK,R0 	; Clock the charge in the serial
	JSR     <CLOCK			;   shift register
	NOP
LSR_I
	MOVE	#VIDEO_PROCESS,R0 	; Video process the binned pixel
	JSR     <CLOCK
	NOP
LSR_BIN
	JMP	<OVER_RD		; All done binning

; This is the routine for NO serial binning 
NO_BIN	MOVE	#<(END_SERIAL_READ_ALL-SERIAL_READ_ALL-1),M1 ; Modularity
	MOVE	Y:<SERIAL_READ,R1	; Waveform table starting address
	NOP
	MOVE    Y:(R1)+,A       	; Start the pipeline
	DO	Y:<NREAD,LSR		; Number of waveform entries total
	MOVE    A,X:(R6) Y:(R1)+,A      ; Send out the waveform
LSR
	MOVE    A,X:(R6)        	; Flush out the pipeline

; Skip over NS_SKP1 columns for subimage readout
OVER_RD	MOVE	Y:<NS_SKP2,A		; Number of columns to skip
	TST	A
	JEQ	<L_BIAS
	MOVE	#<(END_SERIAL_SKIP_CLOCKS-SERIAL_SKIP_CLOCKS-1),M1 ;Modularity
	MOVE	Y:<SERIAL_SKIP,R1	; Waveform table starting address
	NOP
	MOVE    Y:(R1)+,A       	; Start the pipeline
	DO	Y:<NSKIP2,LS_SKIP2	; Number of waveform entries total
	MOVE    A,X:(R6) Y:(R1)+,A      ; Send out the waveform
LS_SKIP2
	MOVE    A,X:(R6)        	; Flush out the pipeline

; And read the bias pixels if in subimage readout mode
L_BIAS	MOVE	Y:<NBOXES,A		; NBOXES = 0 => full image readout
	TST	A
	JEQ	<END_ROW

; Finally read some real bias pixels
	MOVE	Y:<NSBIN,B		; Serial binning parameter
	MOVE	X:<ONE,X0
	CMP	X0,B
	JEQ	<NO_BIN_BIAS		; Skip over serial binning software

	MOVE	Y:<NR_BIAS,A
	JCLR	#SPLIT_S,X:STATUS,*+3
	ASR	A			; Split serials require / 2
	DO      A,LBIAS_BIN		; Number of pixels to read out
	MOVE	#RESET_NODE,R0
	JSR	<CLOCK
	DO      Y:<NSBIN,LBIAS_I  	; Bin serially NSBIN times
	MOVE	Y:<SERIAL_CLOCK,R0 	; Clock the charge in the serial
	JSR     <CLOCK			;   shift register
	NOP
LBIAS_I
	MOVE	#VIDEO_PROCESS,R0 	; Video process the binned pixel
	JSR     <CLOCK
	NOP
LBIAS_BIN
	JMP	<END_ROW		; All done binning

; This is the NO serial binning routine
NO_BIN_BIAS
	MOVE	#<(END_SERIAL_READ_ALL-SERIAL_READ_ALL-1),M1 ; Modularity
	MOVE	Y:<SERIAL_READ,R1	; Waveform table starting address
	NOP
	MOVE    Y:(R1)+,A       	; Start the pipeline
	DO	Y:<NBIAS,LR_BIAS	; Number of waveform entries total
	MOVE    A,X:(R6) Y:(R1)+,A      ; Send out the waveform
LR_BIAS
	MOVE    A,X:(R6)        	; Flush out the pipeline
END_ROW	NOP
LPR	NOP				; End of parallel loop
L_NBOXES NOP				; End of subimage boxes loop

; Restore the controller to non-image data transfer and idling if necessary
RDC_END	BCLR	#WW,X:PBD		; Clear WW to 0 for 32-bit commands
	BCLR	#ST_RDC,X:<STATUS 	; Set status to reading out
	JCLR	#IDLMODE,X:<STATUS,START ; Don't idle after readout
	MOVE	#IDLE,X0
	MOVE	X0,X:<IDL_ADR
        JMP     <START			; Wait for a new command

;  *************************    SUBROUTINE    ***********************
; Core subroutine for clocking out CCD charge
CLOCK   MOVE    Y:(R0)+,X0      ; # of waveform entries 
        MOVE    Y:(R0)+,A       ; Start the pipeline
        DO      X0,CLK1                 ; Repeat X0 times
        MOVE    A,X:(R6) Y:(R0)+,A      ; Send out the waveform
CLK1
        MOVE    A,X:(R6)        ; Flush out the pipeline
        RTS                     ; Return from subroutine

; Check for program overflow
        IF	@CVS(N,*)>$200
        WARN    'Application P: program is too large!'	; Make sure program
	ENDIF						;  will not overflow

; ***********  DATA AREAS - READOUT PARAMETERS AND WAVEFORMS  ************

; Command table - make sure there are exactly 32 entries in it
	IF	@SCP("DOWNLOAD","HOST")
	ORG	X:COM_TBL,X:COM_TBL			; Download address
	ELSE			
        ORG     P:COM_TBL,P:APL_NUM*N_W_APL+APL_LEN+MISC_LEN ; EEPROM address
	ENDIF
	DC	'IDL',IDL  	; Put CCD in IDLE mode    
	DC	'STP',STP  	; Exit IDLE mode
	DC	'SBV',SETBIAS 	; Set DC bias supply voltages  
	DC	'RDC',RDCCD 	; Begin CCD readout    
	DC	'CLR',CLEAR  	; Fast clear the CCD   
	DC	'SGN',ST_GAIN  	; Set video processor gain     
	DC	'SDC',SET_DC	; Set DC coupled diagnostic mode
	DC	'SBN',SET_BIAS_NUMBER	; Set bias number
	DC	'SMX',SET_MUX	; Set clock driver MUX outputs
	DC	'ABR',ABR_RDC	; Abort readout
	DC	'CRD',CONT_RD	; Continue reading out
	DC	'CSW',CLR_SWS	; Clear analog switches to reduce power drain
	DC	'SOS',SEL_OS	; Select Output Source
	DC	'RCC',READ_CONTROLLER_CONFIGURATION 
	DC	'SSS',SET_SUBARRAY_SIZES
	DC	'SSP',SET_SUBARRAY_POSITIONS
	DC	'DON',START	; Nothing special

	DC	'OSH',OPEN_SHUTTER
	DC	'CSH',CLOSE_SHUTTER
	DC      'PON',PWR_ON		; Turn on all camera biases and clocks
	DC      'POF',PWR_OFF		; Turn +/- 15V power supplies off

	DC	'SET',SET_EXP_TIME 	; Set exposure time
	DC	'RET',RD_EXP_TIME 	; Read elapsed exposure time
	DC	'SEX',START_EXPOSURE
	DC	'PEX',PAUSE_EXPOSURE
	DC	'REX',RESUME_EXPOSURE
	DC	'AEX',ABORT_EXPOSURE
	DC	0,START,0,START,0,START,0,START
	DC	0,START

	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:0,Y:0		; Download address
	ELSE
	ORG     Y:0,P:		; EEPROM address continues from P: above
	ENDIF

GAIN	DC 	0		; Video processor gain and integrator speed
NSR     DC      2228   	 	; Number Serial Read, prescan + image + bias
NPR     DC      2052	     	; Number Parallel Read of each readout only
NS_CLR	DC      2250    	; To clear serial register
NPCLR   DC      2060	    	; To clear parallel register
NSBIN   DC      1       	; Serial binning parameter
NPBIN   DC      1       	; Parallel binning parameter

; Miscellaneous definitions
TST_DAT	DC	0		; Place for synthetic test image pixel data
SH_DEL	DC	50		; Delay in milliseconds between shutter  
				;   closing and image readout
CONFIG	DC	CC		; Controller configuration
OS	DC	0		; Output Source selection
N_PAR	DC	10		; Delay parameter for parallel clocks

; Readout peculiarity parameters. Default values are selected here.
SERIAL_SKIP 	DC	SERIAL_SKIP_AR	; Serial skipping waveforms
SERIAL_READ	DC	SERIAL_READ_AR		; Serial reading table
SERIAL_CLOCK 	DC	SERIAL_CLOCK_AR		; Serial clocking waveforms
PARALLEL_CLOCK 	DC	PARALLEL_LOWER		; Parallel waveform table
PARALLEL_CLEAR	DC	PARALLEL_SPLIT_CLEAR	; 

; Parameters computed by this program
NSERIALS_READ	DC	0		; Number of serials to read
NSCLR		DC	0		; Number of waveforms
NSKIP1		DC	0		; Number of waveforms
NREAD		DC	0		; Number of waveforms
NSKIP2		DC	0		; Number of waveforms
NBIAS		DC	0		; Number of waveforms

; These three parameters are read from the READ_TABLE when needed by the
;   RDCCD routine as it loops through the required number of boxes
NP_SKIP		DC	0	; Number of rows to skip
NS_SKP1		DC	0	; Number of serials to clear before read
NS_SKP2		DC	0	; Number of serials to clear after read

; Subimage readout parameters. Ten subimage boxes maximum.
NBOXES	DC	0		; Number of boxes to read
NR_BIAS	DC	0		; Number of bias pixels to read
NS_READ	DC	0		; Number of columns in subimage read
NP_READ	DC	0		; Number of rows in subimage read
READ_TABLE DC	0,0,0		; #1 = Number of rows to clear, 
	DC	0,0,0		; #2 = Number of columns to skip before 
	DC	0,0,0		;   subimage read 
	DC	0,0,0		; #3 = Number of rows to clear after 
	DC	0,0,0		;   subimage clear
	DC	0,0,0
	DC	0,0,0
	DC	0,0,0
	DC	0,0,0
	DC	0,0,0

; Include the waveform table
        INCLUDE "NASAcam.Waveforms.s"	; e2v CCD42-40 readout waveforms

	ENDSEC		; End of section TIM

;  End of program
	END










