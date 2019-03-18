; This file is for utilities that are in common to all the timing board
;   programs, located starting at P:$200 in external SRAM


;  ****************  PROGRAM CODE IN SRAM PROGRAM SPACE    *******************
; Put all the following code in SRAM, starting at P:$200.
	IF	@SCP("DOWNLOAD","HOST")
	ORG	P:$200,P:$200	; Download address
	ELSE
	ORG	P:$200,P:APL_NUM*N_W_APL+APL_LEN ; EEPROM address
	ENDIF

; Select which readouts to process
;   'SOS'  Amplifier_name  
;	Amplifier_name = '__L', '__R','_LR'

SEL_OS	MOVE	X:(R4)+,X0		; Get amplifier(s) name
	MOVE	X0,Y:<OS
	JSR	<SELECT_OUTPUT_SOURCE
	JMP	<FINISH1

; A massive subroutine for setting all the addresses depending on the
;   output source(s) selection. 
SELECT_OUTPUT_SOURCE

; Set all the waveform addresses depending on which readout mode

CMP_L	MOVE	#'__L',A		; Amplifier AL = readout #0
	CMP	X0,A
	JNE	<CMP_R
	MOVE	#SERIAL_SKIP_AL,A
	MOVE	A,Y:SERIAL_SKIP
	MOVE	#SERIAL_READ_AL,A
	MOVE	A,Y:SERIAL_READ
	MOVE	#$00F000,A
	MOVE	A,Y:SXMIT_AL
	MOVE	A,Y:SXMIT_VIDEO_PROCESS
	MOVE	#SERIAL_CLOCK_AL,A
	MOVE	A,Y:SERIAL_CLOCK
	MOVE    #(CLK2+S_DLY+000+S2R+000+S1L+000+000+000+000+000+000),A
	MOVE	A,Y:CCLK_1
	MOVE	#(CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000),A
	MOVE	A,Y:CCLK_2
	MOVE	#PARALLEL_LOWER,A
	MOVE	A,Y:PARALLEL_CLOCK
	BCLR	#SPLIT_S,X:STATUS
	BCLR	#SPLIT_P,X:STATUS
	JMP	<CMP_END

CMP_R	MOVE	#'__R',A		; Amplifier AR = readout #1
	CMP	X0,A
	JNE	<CMP_LR
	MOVE	#SERIAL_SKIP_AR,A
	MOVE	A,Y:SERIAL_SKIP
	MOVE	#SERIAL_READ_AR,A
	MOVE	A,Y:SERIAL_READ
	MOVE	#$00F021,A
	MOVE	A,Y:SXMIT_VIDEO_PROCESS
	MOVE	A,Y:SXMIT_AR
	MOVE	#SERIAL_CLOCK_AR,A
	MOVE	A,Y:SERIAL_CLOCK
	MOVE    #(CLK2+S_DLY+S1R+000+000+000+S2L+000+000+000+000+000),A
	MOVE	A,Y:CCLK_1
	MOVE	#(CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000),A
	MOVE	A,Y:CCLK_2
	MOVE	#PARALLEL_LOWER,A
	MOVE	A,Y:PARALLEL_CLOCK
	BCLR	#SPLIT_S,X:STATUS
	BCLR	#SPLIT_P,X:STATUS
	JMP	<CMP_END



CMP_LR	MOVE	#'_LR',A		; Amplifiers AL and AR = readouts #0,1
	CMP	X0,A
	JNE	<CMP_ERROR
	MOVE	#SERIAL_SKIP_CLOCKS,A
	MOVE	A,Y:SERIAL_SKIP
	MOVE	#SERIAL_READ_ALL,A
	MOVE	A,Y:SERIAL_READ
	MOVE	#$00F020,A
	MOVE	A,Y:SXMIT_ALL
	MOVE	A,Y:SXMIT_VIDEO_PROCESS
	MOVE	#SERIAL_CLOCK_ALL,A
	MOVE	A,Y:SERIAL_CLOCK
	MOVE    #(CLK2+S_DLY+S1R+000+000+S1L+000+000+000+000+000+000),A
	MOVE	A,Y:CCLK_1
	MOVE	#(CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000),A
	MOVE	A,Y:CCLK_2
	MOVE	#PARALLEL_LOWER,A
	MOVE	A,Y:PARALLEL_CLOCK
	BCLR	#SPLIT_P,X:STATUS
	BSET	#SPLIT_S,X:STATUS
	JMP	<CMP_END


CMP_END	MOVE	#'DON',X0	
	RTS

CMP_ERROR
	MOVE	#'ERR',X0
	RTS

; Fast clear of CCD, executed as a command
CLEAR	JSR	<CLR_CCD
	JMP     <FINISH

; Fast clear image before each exposure, executed as a subroutine
CLR_CCD	MOVE	Y:<NPCLR,X0
	DO      X0,LPCLR		; Loop over number of lines in image
	MOVE    Y:PARALLEL_CLEAR,R0	; Address of parallel transfer waveform
	JSR     <CLOCK
	NOP
LPCLR
	DO	Y:<NS_CLR,LSCLR1
	MOVE	#<SERIAL_CLEAR,R0
	JSR	<CLOCK
	NOP
LSCLR1
	MOVE	#TST_RCV,X0		; Wait for commands during exposure
	MOVE	X0,X:<IDL_ADR		;  instead of idling
	RTS

; Keep the CCD idling when not reading out
IDLE	DO      Y:<NSR,IDL1     ; Loop over number of pixels per line
	MOVE    #SERIAL_IDLE,R0 ; Serial transfer on pixel
	JSR     <CLOCK  	; Go to it
	JSR	<GET_RCV	; Check for FO or SSI commands
	JCC	<NO_COM		; Continue IDLE if no commands received
	ENDDO   		; Cancel the DO loop system stack numbers
	JMP     <CHK_SSI	; Go process header and command
NO_COM  NOP
IDL1	
	MOVE    Y:PARALLEL_CLEAR,R0 ; Address of parallel clocking waveform
	JSR     <CLOCK  	; Go clock out the CCD charge
	JMP     <IDLE

; Calculate the fast read parameters for each readout box
SETUP_SUBROUTINE
	MOVE	#(END_SERIAL_READ_ALL-SERIAL_READ_ALL),X0 ; # of waveforms
	MOVE	Y:<NSERIALS_READ,X1	; Number of pixels to read
	JSR	<FASTSKP		; Compute number of clocks required
	MOVE	X1,Y:<NREAD		; Number of waveforms per line
	MOVE	Y:<NR_BIAS,A		; Number of pixels to read
	JCLR	#SPLIT_S,X:STATUS,*+3	; Split serials require / 2
	ASR	A
	MOVE	A,X1			; Number of waveforms per line
	JSR	<FASTSKP		; Compute number of clocks required
	MOVE	X1,Y:<NBIAS		; Number of waveforms per line
	MOVE	#(END_SERIAL_SKIP_CLOCKS-SERIAL_SKIP_CLOCKS),X0 ; # of waveforms
	MOVE	Y:<NS_CLR,X1		; Number of pixels to skip
	JSR	<FASTSKP		; Compute number of clocks required
	MOVE	X1,Y:<NSCLR		; Number of waveforms per line
	MOVE	Y:<NS_SKP1,X1		; Number of pixels to skip
	MOVE	Y:<NSBIN,Y1		; Adjust for binning
	MPY	Y1,X1,A
	ASR	A
	MOVE	A0,X1
	JSR	<FASTSKP		; Compute number of clocks required
	MOVE	X1,Y:<NSKIP1		; Number of waveforms per line
	MOVE	Y:<NS_SKP2,X1		; Number of pixels to skip
	MOVE	Y:<NSBIN,Y1		; Adjust for binning
	MPY	Y1,X1,A
	ASR	A
	MOVE	A0,X1
	JSR	<FASTSKP		; Compute number of clocks required
	MOVE	X1,Y:<NSKIP2		; Number of waveforms per line
	MOVE	Y:<NP_SKIP,X1
	MOVE	Y:<NPBIN,Y1
	MPY	X1,Y1,A
	ASR	A
	MOVE	A0,Y:<NP_SKIP
	RTS
