; This file is for utilities that are in common to all the timing board
;   programs, located starting at P:$200 in external SRAM

	COMMENT	*

The following commands are supported in this "timmisc.s" file
PAL_DLY			Subroutine to delay by about 8 microseconds
SET_DAC			Transfer DAC values in (R0) table to the DACs
FASTSKP			Compute number of waveform table entries in a readout 
				for fast clocking
SYNTHETIC_IMAGE		Generate a synthetic image for system testing
OSHUT			Subroutine call for opening the shutter
CSHUT			Subroutine call for closing the shutter
OPEN_SHUTTER		Command for opening the shutter
CLOSE_SHUTTER		Command for closing the shutter
SET_EXP_TIME		Write desired exposure time to timing board variable	
RD_EXP_TIME		Read elapsed exposure time
START_EXPOSURE		Start an exposure - 'DON' reply, clear FPA, open 
			shutter, expose, close shutter, delay Y:SH_DLY, readout
PAUSE_EXPOSURE		Close shutter, stop exposure timer
RESUME_EXPOSURE		Open shutter if necessary, resume exposure timer
ABORT_EXPOSURE		Close shutter, stop exposure timer
INF			Return version and timing information
IDL			Put FPA to clocking when not processing commands or
			reading out
STP			Put FPA to not clocking when not processing commands or
			reading out
READ_CONTROLLER_CONFIGURATION

PWR_OFF			Turn off ananlog power supply voltages to backplane
PWR_ON			Turn on analog power supply voltages to backplane
SETBIAS			Command to call SET_BIASES and reply 'DON'		
SET_BIASES		Subroutine to turn on all bias and clock voltages
			by reading them from the waveform tables and writing
			them to the DACs
SER_ANA			Direct the timing board DSP's synchronous serial 
			transmitter to the analog boards (clock driver, video)
SER_UTL			Direct the timing board DSP's synchronous serial 
			transmitter to the utility board
CLR_SWS			Clear the analog switches in the clock driver and
			video boards to lower their power consumption, as a
			command with a 'DON' reply
CLEAR_SWITCHES		A subroutine call for CLR_WSW
ST_GAIN			Set the video processor gain to one of four values
WR_CNTRL
SET_DC
SET_BIAS_NUMBER
SET_MUX

	*

;  ** Place this file after the custom timmisc.s file so it continues 
;	to be written in the P:$200 address space  ****

; Hardware control bit definitions
SHUTTER	EQU	4	; Shutter control bit = TIM-LATCH0, A30


; Delay for serial writes to the PALs and DACs by 8 microsec
PAL_DLY	DO	#250,DLY	 ; Wait 8 usec for serial data transmission
	NOP
DLY	NOP
	RTS

;  Update the DACs
SET_DAC	MOVE	Y:(R0)+,X0		; Get the number of table entries
        DO      X0,SET_L0		; Repeat X0 times
        MOVEP	Y:(R0)+,X:SSITX		; Send out the waveform
	JSR	<PAL_DLY		; Wait for SSI and PAL to be empty
	NOP				; Do loop restriction
SET_L0
        RTS                     	; Return from subroutine

; Subroutine for computing number of fast clocks needed
FASTSKP	MPY	X0,X1,B		; X1 = number of pixels to skip, 
				; X0 = number of waveform table entries
	ASR	B		; Correct for multiplication left shift
	MOVE	B0,A		; Get only least significant 24 bits
	MOVE	X:<ONE,X1
	SUB	X1,A		; Subtract 1
	MOVE	A,X1		; X1 = X0 * X1 - 1
	RTS

; Subroutine with two entry points.  C_OSHUT is conditional on SHUT
; Open the shutter conditionally based on the shutter status bit
; Open the shutter by setting the backplane bit TIM-LATCH0
C_OSHUT	JCLR    #SHUT,X:STATUS,OSH_RTN
OSHUT	BSET    #ST_SHUT,X:<STATUS 	; Set status bit to mean shutter open
	BCLR	#SHUTTER,X:<LATCH	; Clear hardware shutter bit to open
	MOVEP	X:LATCH,Y:WRLATCH	; Write it to the hardware
OSH_RTN	RTS

; Subroutine with two entry points.  C_CSHUT is conditional on OPEN_CLOSE
; Close the shutter conditionally based on the open-close ISTATUS bit
; Close the shutter by clearing the backplane bit TIM-LATCH0
C_CSHUT	JCLR    #OPEN_CLOSE,X:ISTATUS,CSH_RTN	; Don't close if always open
CSHUT	BCLR    #ST_SHUT,X:<STATUS 	; Clear status to mean shutter closed
	BSET	#SHUTTER,X:<LATCH	; Set hardware shutter bit to close
	MOVEP	X:LATCH,Y:WRLATCH	; Write it to the hardware
	MOVE    Y:<SH_DEL,A
        TST     A
        JLE     <S_DEL0
        MOVE    #25000,X0
        DO      A,S_DEL0                ; Delay by Y:SH_DEL milliseconds
        DO      X0,S_DEL1
        NOP
S_DEL1  NOP
S_DEL0  NOP
CSH_RTN	RTS

; Open the shutter from the timing board, executed as a command
OPEN_SHUTTER
	JSR	<OSHUT
	JMP	<FINISH

; Close the shutter from the timing board, executed as a command
CLOSE_SHUTTER
	JSR	<CSHUT
	JMP	<FINISH

; Set the desired exposure time
SET_EXP_TIME
	MOVE	X:(R4)+,X0
	MOVE	X0,X:<EXP_TIM		; Write to magic address
	MOVE	X0,X:<TGT_TIM
	JMP	<FINISH


; Abort exposure - close the shutter, stop the timer and resume idle mode
ABORT_EXPOSURE
	BCLR    #TIM_BIT,X:TCSR		; Disable the DSP exposure timer
	JSR	<CSHUT			; Close the shutter
	JCLR	#IDLMODE,X:<STATUS,FINISH ; Check whether to idle after readout
	MOVE	#IDLE,X0		; Idle after readout
	MOVE	X0,X:<IDL_ADR
	JMP	<FINISH

;       Process INF according to the single addressing parameter
GET_INFO
	MOVE	X:(R4)+,A		; 0-4 is generic, >= 0x100 tim specific
	MOVE	#IVERSION,X0
	MOVE	#>GET_VERSION,Y0
        CMP	Y0,A
        JEQ	<FINISH1
	MOVE	#IFLAVOR,X0
	MOVE	#>GET_FLAVOR,Y0
        CMP     Y0,A
        JEQ	<FINISH1
	MOVE	#ITIME0,X0
	MOVE	#>GET_TIME0,Y0
        CMP     Y0,A
        JEQ     <FINISH1               ; Is it Time0?
	MOVE	#ITIME1,X0
	MOVE	#>GET_TIME1,Y0
        CMP     Y0,A
        JEQ     <FINISH1               ; Is it Time1?
	MOVE	#ISVNREV,X0
	MOVE	#>GET_SVNREV,Y0
        CMP     Y0,A
        JEQ     <FINISH1               ; Is it Svn rev?
	MOVE	#TIMCAPABLE,X0
	MOVE	#>GET_CAPABLE,Y0
        CMP     Y0,A
        JEQ     <FINISH1               ; Is it Tim Capabilities?
	MOVE	#INT_TIM,X0
	MOVE	#>GET_INT_TIM,Y0
        CMP     Y0,A
        JEQ     <FINISH1               ; Is it Integration time?
	MOVE	#R_DELAY,X0
	MOVE	#>GET_R_DELAY,Y0
        CMP     Y0,A
        JEQ     <FINISH1               ; Is it Serial time?
	MOVE	#SI_DELAY,X0
	MOVE	#>GET_SI_DELAY,Y0
        CMP     Y0,A
        JEQ     <FINISH1               ; Is it Parallel time?
	JMP	<ERROR


; Set software to IDLE mode
IDL	MOVE	#IDLE,X0		; Exercise clocks when idling
	MOVE	X0,X:<IDL_ADR
	BSET	#IDLMODE,X:<STATUS	; Idle after readout
	JMP     <FINISH			; Need to send header and 'DON'

; Come to here on a 'STP' command so 'DON' can be sent
STP     MOVE	#TST_RCV,X0		; Wait for commands during exposure
	MOVE	X0,X:<IDL_ADR		;  instead of exercising clocks
	BCLR	#IDLMODE,X:<STATUS	; Don't idle after readout
	JMP     <FINISH

; Let the host computer read the controller configuration
READ_CONTROLLER_CONFIGURATION
	MOVE	Y:<CONFIG,X0		; Just transmit the configuration
	JMP	<FINISH1

; Power off
PWR_OFF	JSR	<CLEAR_SWITCHES		; Clear all analog switches
	BCLR	#LVEN,X:PBDDR		; Set these signals to DSP inputs 
	BCLR	#PWRST,X:PBDDR 
	BCLR	#HVEN,X:PBDDR
	BSET	#LVEN,X:PBD		; LVEN = HVEN = 1 => Power reset
	BSET	#PWRST,X:PBD
	BSET	#HVEN,X:PBD
	JMP	<FINISH

; Start power-on cycle
PWR_ON	BSET	#LVEN,X:PBDDR		; Set these signals to DSP outputs 
	BSET	#PWRST,X:PBDDR 
	BSET	#HVEN,X:PBDDR
	JSR	<CLEAR_SWITCHES		; Clear all analog switches

; Ramp up the low voltages (+/- 6.5V, 16.5V) and then delay
	BCLR	#LVEN,X:PBD		; LVEN = Low => Turn on +/- 6.5V, 
	BCLR	#PWRST,X:PBD
	MOVE	#60000,X0
	DO      X0,WT_PON1		; Wait 10 millisec or so for settling
	MOVE	A,P:RSTWDT 		; Reset watchdog timer
	MOVE	A,P:RSTWDT
WT_PON1

; Ramp up the high +36 volt power line and then delay
	BCLR	#HVEN,X:PBD		; HVEN = Low => Turn on +36V
	MOVE	#60000,X0
	DO      X0,WT_PON2		; Wait 10 millisec or so for settling
	MOVE	A,P:RSTWDT 		; Reset watchdog timer
	MOVE	A,P:RSTWDT 
WT_PON2
	JSR	<SET_BIASES		; Turn on the DC bias supplies
	MOVE	#IDLE,X0
	MOVE	X0,X:<IDL_ADR
	JMP	<FINISH			; All done with 'DON'

SETBIAS	JSR	<SET_BIASES
	JMP	<FINISH

; Set all the DC bias voltages and video processor offset values, reading
;   them from the table labeled DACS in this file
SET_BIASES
	JSR	<SER_ANA
	BSET	#CDAC,X:<LATCH		; Disable clearing of DACs
	BSET	#ENCK,X:<LATCH		; Enable clock and DAC output switches
	MOVEP	X:LATCH,Y:WRLATCH 	; Disable clear of DAC and enable clocks
	JSR	<PAL_DLY		; Delay for all this to happen
	JSR	<PAL_DLY		; Delay for all this to happen

; Disable simultaneous update of clock driver boards
	BCLR	#1,X:<LATCH
	MOVEP	X:LATCH,Y:WRLATCH

; Read DAC values from a table, and set DACs
	MOVE	#DACS,R0		; Get starting address of DAC values
	JSR	<SET_DAC

; Set all video processor analog switches to open to disable them (1 => OFF)
	MOVE	#$000FFF,A 
	MOVE    A,X:(R6)		; Send out the waveform
	NOP

; Let the DAC voltages all ramp up before exiting
	MOVE	#400,A			; Delay 4 millisec
	DO	A,L_SBI1
	JSR	<PAL_DLY 		; Delay for all this to happen
	NOP
L_SBI1
	JSR	<SER_UTL		; SSI -> utility board communication
	RTS

; Enable serial communication to the analog boards
SER_ANA	BSET	#0,X:PBD		; Set H0 for analog boards SSI
	MOVEP	#$0000,X:PCC		; Software reset of SSI
	BCLR	#10,X:CRB		; SSI -> continuous clock for analog 
	MOVEP   #$0160,X:PCC		; Re-enable the SSI
	RTS

; Enable serial communication to the utility board
SER_UTL	MOVEP	#$0000,X:PCC		; Software reset of SSI
	BSET	#10,X:CRB		; SSI -> gated clock for util board 
	MOVEP   #$0160,X:PCC		; Enable the SSI
	BCLR	#0,X:PBD		; Clear H0 for utility board SSI
	RTS

CLR_SWS	JSR	<CLEAR_SWITCHES
	JMP	<FINISH

; Clear all video processor analog switches to lower their power dissipation
CLEAR_SWITCHES
	JSR	<SER_ANA	; Set SSI to analog board communication
	MOVE	#$0C3000,A	; Value of integrate speed and gain switches
	CLR	B
	MOVE	#$100000,X0	; Increment over board numbers for DAC writes
	MOVE	#$001000,X1	; Increment over board numbers for WRSS writes
	DO	#15,L_VIDEO	; Fifteen video processor boards maximum
	MOVEP	A,X:SSITX 	; Gain, integrate speed
	ADD	X0,A
	MOVE	B,X:WRSS
	JSR	<PAL_DLY	; Delay for the serial data transmission
	ADD	X1,B
L_VIDEO	
	BCLR	#CDAC,X:<LATCH		; Enable clearing of DACs
	BCLR	#ENCK,X:<LATCH		; Disable clock and DAC output switches
	MOVEP	X:LATCH,Y:WRLATCH 	; Execute these two operations
	MOVE	#IDLE,X0
	MOVE	X0,X:<IDL_ADR
	JSR	<SER_UTL		; Return SSI to utility board
	RTS

; Set the clock multiplexers
SET_MUX	JSR	<SER_ANA	; Set SSI to analog board communication
	MOVE	X:(R4)+,A	; Clock driver board number
	REP	#20
	LSL	A
	MOVE	#$003000,X0
	OR	X0,A
	MOVE	A,X1		; Move here for storage

; Get the first MUX number
	MOVE	X:(R4)+,A	; Get the first MUX number
	JLT	ERR_SM1
	MOVE	#>24,X0		; Check for argument less than 32
	CMP	X0,A
	JGE	ERR_SM1
	MOVE	A,B
	MOVE	#>7,X0
	AND	X0,B
	MOVE	#>$18,X0
	AND	X0,A
	JNE	<SMX_1		; Test for 0 <= MUX number <= 7
	BSET	#3,B1
	JMP	<SMX_A
SMX_1	MOVE	#>$08,X0
	CMP	X0,A		; Test for 8 <= MUX number <= 15
	JNE	<SMX_2
	BSET	#4,B1
	JMP	<SMX_A
SMX_2	MOVE	#>$10,X0
	CMP	X0,A		; Test for 16 <= MUX number <= 23
	JNE	<ERR_SM1
	BSET	#5,B1
SMX_A	OR	X1,B1		; Add prefix to MUX numbers
	MOVE	B1,Y1

; Add on the second MUX number
	MOVE	X:(R4)+,A	; Get the next MUX number
	JLT	ERR_SM2
	MOVE	#>24,X0		; Check for argument less than 32
	CMP	X0,A
	JGE	ERR_SM2
	REP	#6
	LSL	A
	MOVE	A,B
	MOVE	#$1C0,X0
	AND	X0,B
	MOVE	#>$600,X0
	AND	X0,A
	JNE	<SMX_3		; Test for 0 <= MUX number <= 7
	BSET	#9,B1
	JMP	<SMX_B
SMX_3	MOVE	#>$200,X0
	CMP	X0,A		; Test for 8 <= MUX number <= 15
	JNE	<SMX_4
	BSET	#10,B1
	JMP	<SMX_B
SMX_4	MOVE	#>$400,X0
	CMP	X0,A		; Test for 16 <= MUX number <= 23
	JNE	<ERR_SM2
	BSET	#11,B1
SMX_B	ADD	Y1,B		; Add prefix to MUX numbers

	MOVEP	B1,X:SSITX
	JSR	<PAL_DLY	; Delay for all this to happen
	JSR	<SER_UTL	; Return SSI to utility board communication
	JMP	<FINISH
ERR_SM1	MOVE	X:(R4)+,A
ERR_SM2	JSR	<SER_UTL	; Return SSI to utility board communication
	JMP	<ERROR


; Set the video processor gain and integrator speed for all video boards
;  Command syntax is  SGN  #GAIN  #SPEED, #GAIN = 1, 2, 5 or 10	
;					  #SPEED = 0 for slow, 1 for fast
ST_GAIN	JSR	<SER_ANA	; Set SSI to analog board communication
	MOVE	X:(R4)+,A	; Gain value (1,2,5 or 10)
	MOVE	#>1,X0
	CMP	X0,A		; Check for gain = x1
	JNE	<STG2
	MOVE	#>$77,B
	JMP	<STG_A
STG2	MOVE	#>2,X0		; Check for gain = x2
	CMP	X0,A
	JNE	<STG5
	MOVE	#>$BB,B
	JMP	<STG_A
STG5	MOVE	#>5,X0		; Check for gain = x5
	CMP	X0,A
	JNE	<STG10
	MOVE	#>$DD,B
	JMP	<STG_A
STG10	MOVE	#>10,X0		; Check for gain = x10
	CMP	X0,A
	JNE	<ERROR
	MOVE	#>$EE,B

STG_A	MOVE	X:(R4)+,A	; Integrator Speed (0 for slow, 1 for fast)
	JCLR	#0,A1,STG_B
	BSET	#8,B1
	BSET	#9,B1
STG_B	MOVE	#$0C3C00,X0
	OR	X0,B
	MOVE	B,Y:<GAIN	; Store the GAIN value for later us

; Send this same value to 15 video processor boards whether they exist or not
	MOVE	#$100000,X0	; Increment value
	DO	#15,STG_LOOP
	MOVE	B,X:SSITX	; Transmit the SSI word
	JSR	<PAL_DLY	; Wait for SSI and PAL to be empty
	ADD	X0,B		; Increment the video processor board number
STG_LOOP

	JSR	<SER_UTL	; Return SSI to utility board communication
	JMP	<FINISH
ERR_SGN	MOVE	X:(R4)+,A
	JSR	<SER_UTL	; Return SSI to utility board communication
	JMP	<ERROR

; Write an arbitraty control word over the SSI link to any register, any board
; Command syntax is  WRC number, number is 24-bit number to be sent to any board
;WR_CNTRL			
;	JSR	<SER_ANA	; Set SSI to analog board communication
;	JSR	<PAL_DLY	; Wait for the number to be sent
;        MOVEP	X:(R4)+,X:SSITX	; Send out the waveform
;	JSR	<PAL_DLY	; Wait for SSI and PAL to be empty
;	JSR	<SER_UTL	; Return SSI to utility board communication
;	JMP	<FINISH



; Specify subarray readout coordinates, one rectangle only
; Call this subroutine BEFORE SET_SUBARRAY_POSITIONS since it
; initializes NBOXES
SET_SUBARRAY_SIZES
	CLR	A	
	MOVE	A,Y:<NBOXES		; Number of subimage boxes = 0 to start
	MOVE    X:(R4)+,X0
	MOVE	X0,Y:<NR_BIAS		; Number of bias pixels to read
	MOVE    X:(R4)+,X0
	MOVE	X0,Y:<NS_READ		; Number of columns in subimage read
	MOVE    X:(R4)+,X0
	MOVE	X0,Y:<NP_READ		; Number of rows in subimage read	
	JMP	<FINISH

; Call this routine once for every subarray to be added to the table
; Note that the way the variables are arranged the subframes all are the
; same dimensions.  They also cannot overlap in the row direction.
; SET_SUBARRAY_SIZES must be called first to initialize NBOXES
SET_SUBARRAY_POSITIONS
	MOVE	Y:<NBOXES,X0	; Next available slot
	MOVE	X:<THREE,X1
	MPY	X0,X1,A
	ASR	A
	MOVE	A0,A1
	MOVE	#>24,X0
	CMP	X0,A
	JGT	<ERROR		; Error if number of boxes > 9
	MOVE	#READ_TABLE,X0
	ADD	X0,A
	MOVE	A1,R7
	MOVE	X:(R4)+,X0
	MOVE	X0,Y:(R7)+	; Number of rows (parallels) to clear
	MOVE	X:(R4)+,X0
	MOVE	X0,Y:(R7)+	; Number of columns (serials) clears before
	MOVE	X:(R4)+,X0	;  the box readout
	MOVE	X0,Y:(R7)+	; Number of columns (serials) clears after	
	MOVE	Y:<NBOXES,A	;  the box readout
	MOVE	X:<ONE,X0
	ADD	X0,A		; Update the next available slot position
	MOVE	A,Y:<NBOXES
	JMP	<FINISH

; Alert the PCI interface board that images are coming soon
; This tells the PCI card how many pixels to expect for each SEX command
; This is fairly complex.  The first value sent is NSR*NPR (NAXIS1*NAXIS2).
; The second value is IFRAMES, but if NBOXES > 0, it is IFRAMES*NBOXES
PCI_READ_IMAGE
	MOVE	#$020104,X0		; Send header word to the FO transmitter
	JSR	<XMT_FO
	MOVE	#'RDA',X0
	JSR	<XMT_FO
	MOVE	Y:NSR,X0		; NSR = NAXIS1
	MOVE	Y:NPR,X1		; NPR = NAXIS2
	MPY	X0,X1,B
	ASR	B		; Correct for multiplication left shift
	MOVE	B0,X0	
	JSR	<XMT_FO		; Send NSR*NPR to PCI card
	MOVE	Y:IFRAMES,X0	; IFRAMES = NAXIS3
	MOVE	Y:<NBOXES,A	; If NBOXES = 0, transmit that to PCI
	TST	A
	JEQ	XMT
	MOVE	Y:<NBOXES,X1	; If NBOXES = 0, transmit that to PCI
	MPY	X0,X1,B		; If not, multiply by NBOXES, then send
	ASR	B		; Correct for multiplication left shift
	MOVE	B0,X0		; Get only least significant 24 bits
XMT	NOP
	JSR	<XMT_FO
	RTS

XMT_FO	MOVEP	X0,Y:WRFO
	REP	#15
	NOP
	RTS
