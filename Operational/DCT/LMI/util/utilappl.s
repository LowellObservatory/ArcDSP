       COMMENT *

This file is used to generate DSP code for the utility board. It will time
     the exposure, operate the shutter, control the CCD temperature and 
     turn the analog power on. This is Rev. 3.00 software. 
Modified 1-12-97 for 10 MHz input clock frequency by adding 2 to elapsed
     exposure time rather than one. 
Power ON sequence written for Gen II power control board, Rev. 4A

Modified for a second order temperture metaregulation Oct 2010

Modified for more configurable Makefile as described in the confluence page
 http://jumar.lowell.edu/confluence/display/LIGS/DSP+Code+Upgrades+And+Repository+Restructuring
Version 1.4/1

-d DOWNLOAD 'HOST'	To generate code for downloading to DSP memory.
-d DOWNLOAD 'ROM'	To generate code for writing to the ROM.

	*
        PAGE    132	; Printronix page width - 132 columns
	;INCLUDE	"utilversion.s"	; versioning
	INCLUDE "infospec.s"
	INCLUDE "utilinfospec.s"
	INCLUDE "utilinfo.s"
	INCLUDE "utilversion.s"
UTILCAPABLE	EQU	0

; Name it a section so it doesn't conflict with other application programs
	SECTION	UTILAPPL

;  These are also defined in "utilboot.asm", so be sure they agree
APL_ADR	EQU	$90	; Starting address of application program
BUF_STR	EQU	$80	; Starting address of buffers in X:
BUF_LEN	EQU	$20	; Length of buffers
SSI_BUF	EQU	BUF_STR		; Starting address of SCI buffer in X:
COM_BUF	EQU     SSI_BUF+BUF_LEN	; Starting address of command buffer in X:
COM_TBL	EQU     COM_BUF+BUF_LEN	; Starting address of command table in X:

;  Define some useful constants
APL_XY	EQU	$1EE0	; Starting address in EEPROM of X: and Y: values
DLY_MUX	EQU     70      ; Number of DSP cycles to delay for MUX settling
DLY_AD  	EQU     100     ; Number of DSP cycles to delay for A/D settling

; Assign addresses to port B data register
PBD     	EQU     $FFE4   ; Port B Data Register
IPR     	EQU     $FFFF   ; Interrupt Priority Register

;  Addresses of memory mapped components in Y: data memory space
;  Write addresses first
WR_DIG  	EQU     $FFF0   ; was $FFFF  Write Digital output values D00-D15
WR_MUX  	EQU     $FFF1   ; Select MUX connected to A/D input - one of 16
EN_DIG	EQU	$FFF2	; Enable digital outputs
WR_DAC3 	EQU     $FFF7   ; Write to DAC#3 D00-D11
WR_DAC2 	EQU     $FFF6   ; Write to DAC#2 D00-D11
WR_DAC1 	EQU     $FFF5   ; Write to DAC#1 D00-D11
WR_DAC0 	EQU     $FFF4   ; Write to DAC#0 D00-D11
;WR_DAC0	EQU	$FFF6		; Redirect Heater DAC
;WR_DAC1	EQU	$FFF7		; Redirect Heater DAC

;  Read addresses next
RD_DIG  	EQU     $FFF0   ; Read Digital input values D00-D15
STR_ADC 	EQU     $FFF1   ; Start ADC conversion, ignore data
RD_ADC  	EQU     $FFF2   ; Read A/D converter value D00-D11
WATCH   	EQU     $FFF7   ; Watch dog timer - tell it that DSP is alive

;  Bit definitions of STATUS word
ST_SRVC		EQU     0       ; Set if ADC routine needs executing
ST_EX   	EQU     1       ; Set if timed exposure is in progress
ST_SH   	EQU     2       ; Set if shutter is open
ST_READ 	EQU     3	; Set if a readout needs to be initiated
STRT_EX		EQU	4	; Set to indicate start of exposure
DITHMODE	EQU	7	; Set for dithering during exp.  Bash to set
CONT_EX		EQU	8	; Set to indicate cont. exp mode. Bash to set

; Bit definitions of software OPTIONS word
OPT_SH  	EQU     0       ; Set to open and close shutter.  Bash to set

;  Bit definitions of Port B = Host Processor Interface
PWR_EN1	EQU     0       ; Power enable bit ONE - Output
PWR_EN0	EQU     1       ; Power enable bit ZERO  - Output
PWRST		EQU     2       ; Reset power conditioner counter - Output
SHUTTER	EQU     3       ; Control shutter - Output
IRQ_T   	EQU     4       ; Request interrupt service from timing board - Output
SYS_RST 	EQU     5       ; Reset entire system - Output
WATCH_T 	EQU     8       ; Processed watchdog signal from timing board - Input


;   Definitions for outer working temps loop.
	IF	@SCP("TAVCYCLE","32")
TAVCNT	EQU	32
TAVSHF		EQU 	5	; must match log2(TAVCYCLE)
	ENDIF
	IF	@SCP("TAVCYCLE","64")
TAVCNT	EQU	64
TAVSHF		EQU 	6	; must match log2(TAVCYCLE)
	ENDIF
	IF	@SCP("TAVCYCLE","128")
TAVCNT	EQU	128
TAVSHF		EQU 	7	; must match log2(TAVCYCLE)
	ENDIF

; set up utility board capabilities word
        IF      @SCP("EXPOSECTL","ON")      ;bit 0 (1)
EXPOSECAPABLE      EQU     1
        ELSE
EXPOSECAPABLE      EQU     0
        ENDIF
        IF      @SCP("POWERCTL","ON")     ;bit 1 (1)
PWRCAPABLE     EQU     2
        ELSE
PWRCAPABLE     EQU     0
        ENDIF
        IF      @SCP("TEMPREG","ON")       ;bit 2 (1)
TEMPREGCAPABLE      EQU     4
        ELSE
TEMPREGCAPABLE      EQU     0
        ENDIF
        IF      @SCP("WRDACS","ON")       ;bit 3 (1)
WDACCAPABLE      EQU     8
        ELSE
WDACCAPABLE      EQU     0
        ENDIF
        IF      @SCP("WRDACSALL","ON")       ;bit 4 (1)
WDACALLCAPABLE      EQU     16
        ELSE
WDACALLCAPABLE      EQU     0
        ENDIF
UTILCAPABLE      EQU EXPOSECAPABLE+PWRCAPABLE+TEMPREGCAPABLE+WDACCAPABLE+WDACALLCAPABLE




;**************************************************************************
;                                                                         *
;    Register assignments  						  *
;	 R1 - Address of SCI receiver contents				  *
;	 R2 - Address of processed SCI receiver contents		  *
;        R3 - Pointer to current top of command buffer                    *
;        R4 - Pointer to processed contents of command buffer		  *
;	 N4 - Address for internal jumps after receiving 'DON' replies	  *
;        R0, R5, R6, A, X0, X1 - For use by program only                  *
;	 R7 - For use by SCI ISR only					  *
;        Y0, Y1, and B - For use by timer ISR only. If any of these	  *
;		registers are needed elsewhere they must be saved and	  *
;	        restored in the TIMER ISR.                        	  *
;**************************************************************************

; Specify execution and load addresses.
	ORG	P:APL_ADR,P:APL_ADR

; The TIMER addresses must be defined here and SERVICE must follow to match
;   up with the utilboot code
	JMP	<SERVICE		; Millisecond timer interrupt

TIMER	RTI				; RTI for now so downloading works
	BSET	#0,Y:<DIG_OUT		; FIDUCIAL PULSE
	MOVEP	#1,Y:EN_DIG	   ; Enable digital outputs
	MOVEP   Y:DIG_OUT,Y:WR_DIG ; Write 16 digital outputs

	IF	@SCP("EXPOSECTL","ON")

	JCLR    #ST_EX,X:STATUS,NO_TIM	; Continue on if we're not exposing
	JCLR	#STRT_EX,X:<STATUS,EX_STRT ; Skip if exposure has been started
	BCLR	#STRT_EX,X:<STATUS	; Clear status = "not start of exposure"
	CLR     B
	MOVE    B,Y:<EL_TIM_MSECONDS	; Initialize elapsed time
	MOVE	B,Y:<EL_TIM_FRACTION
	MOVE	B,Y:<NUMPIC		; clear number of pix in series
	JCLR	#OPT_SH,X:<OPTIONS,NO_TIM ; Don't open shutter if a dark frame
	JSR	<OSHUT 			; Open shutter if start of exposure
	JMP	<NO_TIM			; Don't increment EL_TIM at first
EX_STRT
	CLR	B   Y:<INCR,Y0		; INCR = 0.8 milli? seconds
	MOVE	X:<ZERO,Y1
	MOVE	Y:<EL_TIM_MSECONDS,B1 	; Get elapsed time
	MOVE	Y:<EL_TIM_FRACTION,B0
	ADD	Y,B   Y:<TGT_TIM,Y1	; EL_TIM = EL_TIM + 0.8 milliseconds	
	MOVE	B0,Y:<EL_TIM_FRACTION
	SUB     Y1,B  B1,Y:<EL_TIM_MSECONDS
	JLT     <NO_TIM			; If (EL .GE. TGT) we've timed out

; Close the shutter at once if needed
	JCLR    #OPT_SH,X:OPTIONS,NO_SHUT ; Close the shutter only if needed
	BSET    #SHUTTER,X:PBD		; Set Port B bit #3 to close shutter
	BSET	#ST_SH,X:<STATUS	; Set status to mean shutter closed

; Wait SH_DLY milliseconds for the shutter to fully close before reading out
NO_SHUT
	MOVE	Y:<SH_DEL,Y1		; Get shutter closing time
	SUB	Y1,B			; B = EL_TIM - (TGT_TIM + SH_DEL)
	JLT	<NO_TIM			; If (EL .GE. TGT+DEL) we've timed out
	BSET    #ST_READ,X:<STATUS	; Set so a readout will be initiated
	CLR     B
	MOVE    B,Y:<EL_TIM_MSECONDS	; Initialize elapsed time
	MOVE	B,Y:<EL_TIM_FRACTION	; for next image in series
	MOVE	Y:<NUMPIC,B0		; Increment NUMPIC
	INC	B
	MOVE	B0,Y:<NUMPIC
	MOVE	Y:TGT_PIC,Y0		; Get target number of pix
	MOVE	X:<ZERO,Y1
	SUB	Y,B
	JLT	<NO_TIM			; If NUMPIC .GE. TGT_PIC, done
	BCLR	#ST_EX,X:<STATUS	; No longer exposing
	BCLR	#CONT_EX,X:<STATUS	; or taking a series
	ENDIF

; Return from interrupt
NO_TIM	
	BSET    #ST_SRVC,X:<STATUS	; SERVICE needs executing
	BCLR	#0,Y:<DIG_OUT		; FIDUCIAL PULSE
	MOVEP	#1,Y:EN_DIG	   ; Enable digital outputs
	MOVEP   Y:DIG_OUT,Y:WR_DIG ; Write 16 digital outputs
	MOVEC	Y:<SV_SR,SR		; Restore Status Register
	NOP
	RTI				; Return from TIMER interrupt

; This long subroutine is executed every millisecond, but isn't an ISR so
;   that care need not be taken to preserve registers and stacks.
SERVICE	
	BCLR	#ST_SRVC,X:<STATUS	; Clear request to execute SERVICE

	IF	@SCP("EXPOSECTL","ON")
	JCLR	#ST_READ,X:<STATUS,DTH_CHK ; Initiate readout?
	ENDIF

; Extra call if using the VME interface board
	IF	@SCP("INTERFACE","VME")
        MOVE    X:<VME,B
        MOVE    B,X:(R3)+       	; Header ID from Utility to VME
        MOVE    Y:<RDC,B
        MOVE    B,X:(R3)+       	; Put VMEINF board in readout mode
	ENDIF

	IF	@SCP("EXPOSECTL","ON")

	MOVE	X:<TIMING,A
	MOVE	A,X:(R3)+               ; Header from Utility to timing
	MOVE	Y:<RDC,A
	MOVE	A,X:(R3)+               ; Start reading out the CCD
	BCLR	#ST_READ,X:<STATUS	; Readout will be initiated
	JSET    #CONT_EX,X:STATUS,BAILOUT	; Don't clear ST_EX if series
	BCLR	#ST_EX,X:<STATUS	; Exposure is no longer in progress
BAILOUT		
	MOVEP	Y:WATCH,X0		; Reset Watchdog Timer
	RTS				; Return now to save time

; If we are supposed to dither, put a DTH command to timer on queue
DTH_CHK	JCLR #DITHMODE,X:<STATUS,UPD_DIG
	MOVE	X:<TIMING,A
	MOVE	A,X:(R3)+               ; Header from Utility to timing
	MOVE	Y:<DTH,A
	MOVE	A,X:(R3)+               ; Dither command to queue
	ENDIF

; Update all the digital input/outputs; reset watchdog timer
UPD_DIG	MOVEP   Y:RD_DIG,Y:DIG_IN  ; Read 16 digital inputs
	BSET	#1,Y:<DIG_OUT		; FIDUCIAL PULSE
	MOVEP	#1,Y:EN_DIG	   ; Enable digital outputs
	MOVEP   Y:DIG_OUT,Y:WR_DIG ; Write 16 digital outputs
	MOVEP	Y:WATCH,X0	; Reset watchdog timer
; Update the 4 DACs
	MOVEP   Y:DAC0,Y:WR_DAC0 ; Write to DAC0
	MOVEP   Y:DAC1,Y:WR_DAC1 ; Write to DAC1
	MOVEP   Y:DAC2,Y:WR_DAC2 ; Write to DAC2
	MOVEP   Y:DAC3,Y:WR_DAC3 ; Write to DAC3

; Analog Input processor - read the 16 A/D inputs
        MOVE    X:<ONE,X0	; For incrementing accumulator to select MUX
        CLR     A  #<AD_IN,R5	; Will contain MUX number
        DO      Y:NUM_AD,LOOP_AD ; Loop over each A/D converter input
        MOVEP   A,Y:WR_MUX      ; Select MUX input
        DO	#DLY_MUX,L_AD1	; Wait for the MUX to settle
	MOVE	A1,Y:<SV_A1	; DO needed so SSI input can come in
L_AD1
        MOVEP   Y:STR_ADC,X1    ; Start A/D conversion - dummy read
        DO	#DLY_AD,L_AD2	; Wait for the A/D to settle
        MOVE    X:<CFFF,X1
L_AD2	
        MOVEP   Y:RD_ADC,A1     ; Get the A/D value
        AND     X1,A            ; A/D is only valid to 12 bits
        BCHG    #11,A1		; Change 12-bit 2's complement to unipolar
        MOVE    A1,Y:(R5)+      ; Put the A/D value in the table
	MOVE	Y:<SV_A1,A1	; Restore A1 = MUX number
        ADD     X0,A		; Increment A = MUX number by one
LOOP_AD
	MOVEP	X:ONE,Y:WR_MUX ; Sample +5V when idle

	IF	@SCP("TEMPREG","ON")

; Control the CCD Temperature
; The algorithmn assumes a reverse biased diode whose A/D count A_CCDT 
;   is proportional to temperature. Don't start controlling temperature 
;   until it falls below target temperature. ADUs decrease with temp.

; Changed to run an RTD where the ADUs increase with temperature.
; Modified to average a bunch of temps, then change the heater current
; For initialization, depend on assembler setting to zero.
; this loop also averages the cold head temperature, for informational
; purposes. The count for this loop currently fixed at 1024.
;

	MOVE	Y:<B_CCDT,X0	; Get Cold Head temperature
	MOVE    Y:TH_SUM,A0	; Get CH running Sum
	MOVE    X:<ZERO,A1	
	MOVE    A1,X1
	ADD	X,A		; Add CH to running sum
	MOVE    A0,Y:TH_SUM    ; and store it
	MOVE	Y:TH_COUNT,A0	; Get the count
	INC	A		; Add 1
	MOVE	A0,Y:TH_COUNT	; and store it
	MOVE	Y:ONE_K,X0	; Get number to average
	SUB	X,A
	JLT	<C_TEMP		
; If TH_COUNT .GE. 1024, find avg, update
	MOVE	Y:TH_SUM,A0	; Here if done.  Get final sum
	REP	#10
	ASR	A		; Averaging the temperature
	MOVE	A0,Y:TH_AVG	; Save the average temperature

	CLR	A		; Now clear sum and count
	MOVE	A0,Y:TH_SUM
	MOVE    A0,Y:TH_COUNT

; This is section handles the CCD detector temperature. It reads the temp then
; averages and applies the heater current if necessary 
C_TEMP
	MOVE    Y:<A_CCDT,X0	; Get actual CCD temperature
	MOVE	Y:<T_SUM,A0	; Get the running sum
	MOVE	X:<ZERO,A1
	MOVE	A1,X1
	ADD	X,A		; add on this temperature
	MOVE	A0,Y:<T_SUM	; and store it

	IF	@SCP("TEMPSTATS","ON")
	MOVE	X0,X1
	MPY	X0,X1,B		; this is (A_CCDT**2)*2
	MOVE	A1,X1
	MOVE	Y:T_RSQ_1,A1
	MOVE	Y:T_RSQ_0,A0
	ADD	A,B
	ENDIF

	MOVE	Y:<T_COUNT,A0	; Get the count
	MOVE	X1,A1

	IF	@SCP("TEMPSTATS","ON")
	MOVE	B1,Y:T_RSQ_1
	MOVE	B0,Y:T_RSQ_0	; accumulate sum of the square
	ENDIF
	INC	A		; Add 1
	MOVE	A0,Y:<T_COUNT	; and store it
	MOVE	Y:ONE_K,X0	; Get number to average
	SUB	X,A
	JLT	<SKIP_T		
; If T_COUNT .GE. 1024, find avg, update
	MOVE	Y:<T_SUM,A0	; Here if done.  Get final sum
	NOP
	IF	@SCP("TEMPSTATS","ON")
	MOVE	A0,Y:T_LAVG	; make the "last cycle" copy of temps sum
	ENDIF
	REP	#10
	ASR	A		; Averaging the temperature
	MOVE	A0,Y:T_AVG	; Save the average temperature
	MOVE	A0,X0		; and stick in X0

	IF	@SCP("TEMPSTATS","ON")
	MOVE	Y:T_RSQ_0,Y0	; make the "last cycle" copy of squares sum
	MOVE	Y0,Y:T_LSQ_0
	MOVE	Y:T_RSQ_1,Y0
	MOVE	Y0,Y:T_LSQ_1
	ENDIF

	CLR	A		; Now clear sum and count
	MOVE	A0,Y:<T_SUM
	IF	@SCP("TEMPSTATS","ON")
	MOVE	A0,Y:T_RSQ_0
	MOVE	A0,Y:T_RSQ_1
	ENDIF
	MOVE	A0,Y:<T_COUNT
	MOVE    Y:W_CCDT,A	; Get target CCD temperature
	SUB	X0,A
	MOVE	A,X0		; X0 now target - actual
	MOVE	Y:<T_COEFF,X1	
	MPY	X0,X1,A		; A = (target - actual) * T_COEFF
	ASR	A		; Shift right to fix *2
	MOVE	Y:<HTMAX,X0	; Heats greater than this are not allowed
	MOVE	A0,A1		; 
	CMP	X0,A
	JLT	<TST_LOW
	MOVE	X0,A		; Make it the maximum heat
	JMP	<WR_DAC
TST_LOW	
	TST	A		; Heats of less than zero are not allowed
	JGT	<WR_DAC
	MOVE	X:<ZERO,A	; No heat
WR_DAC
	MOVEP	A1,Y:WR_DAC0	; Update DAC and record of it
	MOVE	A1,Y:<DAC0
	MOVE	A1,Y:<DAC0_LS

	IF	@SCP("TEMPWSETPT","ON")

;	code to manage new 'working' detector setpoint temperature
        MOVE	Y:T_AVG,X0	; outermost 2 minute loop- sum average actual
	MOVE	Y:TAV_SUM,A
	ADD	X0,A
	MOVE	A1,Y:TAV_SUM	; update sum, actual ccd temp
	MOVE	Y:W_COUNT,B
        MOVE    X:<ONE,X0
	ADD	X0,B
	MOVE	B1,Y:W_COUNT
	MOVE	Y:TAVLOOP,X0
	SUB	X0,B
	JLT	SKIP_T
	; convert TAV_SUM in A to average by right shift
	REP	#TAVSHF
	ASR	A		; ROUND?
	MOVE	Y:<T_CCDT,X0
	SUB	X0,A		; actual regulated - target
	NEG	A
	ASR	A		; DeltaT*0.5 in A
	MOVE	Y:W_CCDT,Y0
	ADD	Y0,A		; add correction to W_CCDT
	MOVE	A1,Y1
	SUB	X0,A		; W_CCDT proposed - target
	MOVE	Y:MBOUND,X1		; apply bound 
	CMP	X1,A
	JLT	INRANGEHI
        ; out of bounds above-  make W_CCDT = T_CDDT + 36
	MOVE	X0,A
	ADD	X1,A
	MOVE	A1,Y1
	JMP	SET_W_CCDT
INRANGEHI
	; set if W_CCDT proposed is too low
	ADD	X1,A
	JGT	SET_W_CCDT
        ; out of bounds below-  make W_CCDT = T_CDDT - 36
	MOVE	X0,A
	SUB	X1,A
	MOVE	A1,Y1
SET_W_CCDT
	MOVE	Y1,Y:W_CCDT
	CLR	A
	MOVE	A1,Y:W_COUNT
	MOVE	A1,Y:TAV_SUM
	ENDIF

	ENDIF
	
SKIP_T	
	BCLR	#1,Y:<DIG_OUT		; FIDUCIAL PULSE
	MOVEP	#1,Y:EN_DIG		; Enable digital outputs
	MOVEP   Y:DIG_OUT,Y:WR_DIG	; Write 16 digital outputs
	RTS				; Return from subroutine SERVICE call

	IF	@SCP("EXPOSECTL","ON")

; Shutter support subroutines for the TIMER executive
; Also support shutter connection to timing board for now.
OSHUT	BCLR    #SHUTTER,X:PBD		; Clear Port B bit #3 to open shutter
        BCLR    #ST_SH,X:<STATUS	; Clear status bit to mean shutter open
        RTS

CSHUT	BSET    #SHUTTER,X:PBD  ; Set Port B bit #3 to close shutter
        BSET    #ST_SH,X:<STATUS ; Set status to mean shutter closed
        RTS
	ENDIF

; These are called directly by command, so need to call subroutines in turn
; the labels will be removed shortly after we fix the cmd table.
OPEN	
	IF	@SCP("EXPOSECTL","ON")

	JSR	OSHUT		; Call open shutter subroutine

	JMP	<FINISH		; Send 'DON' reply
	ENDIF
; the labels will be removed shortly after we fix the cmd table.
CLOSE	
	IF	@SCP("EXPOSECTL","ON")

	JSR	CSHUT		; Call close shutter subroutine
	ENDIF

	JMP	<FINISH		; Send 'DON' reply


;       Process INF according to the single addressing parameter
;       We'll shortly add a capability bit for working setpt temp regulation. 
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
	MOVE	#UTILCAPABLE,X0
	MOVE	#>GET_CAPABLE,Y0
        CMP     Y0,A
        JEQ     <FINISH1               ; Is it UTIL Capabilities?
	JMP	<ERROR

;  **************  BEGIN  COMMAND  PROCESSING  ***************
	IF	@SCP("POWERCTL","ON")
; Power off
	IF	@SCP("POWER","R6")
PWR_OFF
	BSET	#LVEN,X:PBD	; LVEN = HVEN = 1 => Power reset
	BSET	#PWRST,X:PBD
	BSET	#HVEN,X:PBD
	ELSE			; Earlier Revision power control boards
PWR_OFF
	BSET	#PWRST,X:PBD	; Reset power control board
	BCLR	#PWRST,X:PBD
	ENDIF	
	JMP	<FINISH		; Reply 'DON'

; Start power-on cycle
; PWRST must be the same as PWR_EN0 because they're connected on the backplane
PWR_ON	
	MOVEP   #$2000,X:IPR    ; Disable TIMER interrupts
	BSET	#9,X:PBDDR	; Make sure PWREN is an input
	IF	@SCP("POWER","R6")
	BSET	#LVEN,X:PBD	; LVEN = HVEN = 1 => Power reset
	BSET	#PWRST,X:PBD	; PWRST must be the same as LVEN because
	BSET	#HVEN,X:PBD	;   they're connected on the backplane
	ELSE
	BSET	#PWRST,X:PBD	; Reset power control board
	REP	#30
	NOP
	BCLR	#PWRST,X:PBD
	ENDIF

; Set up the bias voltage DACs and clock drivers on the analog boards
	MOVE	X:<TIMING,A
	MOVE	A,X:(R3)+       ; Header from Utility to timing
	MOVE	Y:<IDL,A
	MOVE	A,X:(R3)+       ; Start up the clock drivers
	MOVE	#PWR_ON1,N4	; Set internal jump address after 'DON'
	JMP	<XMT_CHK	; Send out commands to timing board

; Wait a little while for at least one cycle of serial and parallel clocks
PWR_ON1	
	MOVE	#30000,X0
	DO      X0,WT_PON1	; Wait 20 millisec or so for settling
        REP	#5
	MOVEP	Y:WATCH,X0	; Reset watchdog timer
WT_PON1
	MOVE	X:<TIMING,A
	MOVE	A,X:(R3)+       ; Header from Utility to timing
	MOVE	Y:<STP,A
	MOVE	A,X:(R3)+       ; Stop the clocks during power on
	MOVE	#PWR_ON2,N4	; Set internal jump address after 'DON'
	JMP	<XMT_CHK	; Send the command to the timing board

; Now ramp up the low voltages (+/- 6.5V, 16.5V) 
	IF	@SCP("POWER","R6")
PWR_ON2	BCLR	#LVEN,X:PBD	; LVEN = Low => Turn on +/- 6.5V, +/- 16.5V
	BCLR	#PWRST,X:PBD
	ELSE
PWR_ON2	BSET	#LVEN,X:PBD	; Make sure line is high to start with
	DO	#255,L_PON1	; The power conditioner board wants to
	BCHG    #LVEN,X:PBD	;   see 128 H --> L transitions
	NOP			; Backplane signal settling time delay
L_PON1
	ENDIF

	JSR	<PWR_DLY	; Delay for a little while
	MOVEP   #2,Y:WR_MUX     ; Select +15V MUX input
	MOVE	#40000,X0
	DO      X0,WT_PON2	; Wait 20 millisec or so for settling
	REP	#5
	MOVEP	Y:WATCH,X0	; Reset watchdog timer
WT_PON2
        MOVEP   Y:STR_ADC,X0    ; Start A/D conversion - dummy read
        DO	#DLY_AD,L_PON2	; Wait for the A/D to settle
        CLR     A  X:<CFFF,X0	; This saves some space
L_PON2
        MOVEP   Y:RD_ADC,A1     ; Get the A/D value
        AND     X0,A  Y:<T_P15,X0 ; A/D is only valid to 12 bits

; Test that the voltage is in the range abs(initial - target) < margin
        SUB     X0,A  A1,Y:<I_P15
        ABS     A  Y:<K_P15,X0
        SUB     X0,A
        JGT     <PERR           ; Take corrective action

TST_M15 MOVEP   #3,Y:WR_MUX     ; Select -15v MUX input
        DO	#DLY_MUX,L_PON3	; Wait for the MUX to settle
        NOP
L_PON3
        MOVEP   Y:STR_ADC,X0    ; Start A/D conversion - dummy read
        DO	#DLY_AD,L_PON4	; Wait for the A/D to settle
        CLR     A  X:<CFFF,X0	; Clear A, so put it in DO loop
L_PON4
        MOVEP   Y:RD_ADC,A1     ; Get the A/D value
        AND     X0,A  Y:<T_M15,X0 ; A/D is only valid to 12 bits

; Test that the voltage is in the range abs(initial - target) < margin
        SUB     X0,A  A1,Y:<I_M15
        ABS     A  Y:<K_M15,X0
        SUB     X0,A
        JGT     <PERR

; Now turn on the high voltage HV (nominally +36 volts)
	IF	@SCP("POWER","R6")
HV_ON	BCLR	#HVEN,X:PBD	; HVEN = Low => Turn on +36V
	ELSE
HV_ON	BSET	#HVEN,X:PBD	; Make sure line is high to start with
	DO	#255,L_PON5	; The power conditioner board wants to
	BCHG    #HVEN,X:PBD	;   see 128 H --> L transitions
L_PON5
	ENDIF

	JSR	<PWR_DLY	; Delay for a little while	
	MOVEP   #1,Y:WR_MUX     ; Select high voltage MUX input
	MOVE	#30000,X0
	DO      X0,WT_HV	; Wait a few millisec for settling
	NOP
WT_HV
	MOVEP   Y:STR_ADC,X0    ; Start A/D conversion - dummy read
	DO	#DLY_AD,L_PON6	; Wait for the A/D to settle
	CLR     A  X:<CFFF,X0	; Clear A, so put it in DO loop
L_PON6
	MOVEP   Y:RD_ADC,A1     ; Get the A/D value
	AND     X0,A  Y:<T_HV,X0 ; A/D is only valid to 12 bits

; Test that the voltage is in the range abs(initial - target) < margin
	SUB     X0,A  A1,Y:<I_HV
	ABS     A  Y:<K_HV,X0
	SUB     X0,A
	JGT     <PERR           ; Take corrective action

; Command the timing board to turn on the analog board DC bias voltages
	MOVE	X:<TIMING,A
	MOVE	A,X:(R3)+       ; Header from Utility to timing
	MOVE	Y:<SBV,A
	MOVE	A,X:(R3)+       ; Set bias voltages
	MOVE	#PWR_ON3,N4	; Set internal jump address after 'DON'
	JMP	<XMT_CHK	; Send out commands to timing board

; Reply with a DONE message to the host computer
PWR_ON3	MOVE    X:<HOST,A
	MOVE    A,X:(R3)+       ; Header to host
	MOVE    X:<DON,A
	MOVE    A,X:(R3)+       ; Power is now ON
	MOVEP   #$2007,X:IPR    ; Enable TIMER interrupts
	JMP     <XMT_CHK	; Go transmit reply

; Or, return with an error message
PERR	MOVE    X:<HOST,A
	MOVE    A,X:(R3)+       ; Header to host
	MOVE    X:<ERR,A
        MOVE    A,X:(R3)+	; Power is ON
	MOVEP   #$2007,X:IPR    ; Enable TIMER interrupts
	JMP     <XMT_CHK	; Go transmit reply

; Delay between power control board instructions
PWR_DLY	DO	#4000,L_DLY
	NOP			
L_DLY
	RTS
	ENDIF

	IF	@SCP("WRDACS","ON")

	IF	@SCP("WRDACSALL","ON")
; both dacs, no reply, for pci dsp based imc on hipo
WRITE_TO_DACA
        MOVE    X:(R4)+,A       ; DAC Number to change
        MOVEP   A1,Y:WR_DAC2    ; Update DAC and record of it
        MOVE    A1,Y:<DAC2

        MOVE    X:(R4)+,A       ; Value to set
        MOVEP   A1,Y:WR_DAC3    ; Update DAC and record of it
        MOVE    A1,Y:<DAC3
        MOVE    Y:DACAWRS,A
        MOVE    X:<ONE,X0
        ADD     X0,A
        NOP
        MOVE    A1,Y:DACAWRS    ; increment count of 2 dac writes
        JMP     <XMT_CHK
	ENDIF


WRITE_TO_DAC2
	MOVE	X:(R4)+,A	; DAC Number to change
	MOVEP	A1,Y:WR_DAC2	; Update DAC and record of it
	MOVE	A1,Y:<DAC2
	JMP	<FINISH
WRITE_TO_DAC3
	MOVE	X:(R4)+,A	; Value to set
	MOVEP	A1,Y:WR_DAC3	; Update DAC and record of it
	MOVE	A1,Y:<DAC3
	JMP	<FINISH
	ENDIF

	
	IF	@SCP("EXPOSECTL","ON")
	
; Start an exposure by first issuing a 'CLR' to the timing board
START_EX
	MOVE	X:<TIMING,A
	MOVE	A,X:(R3)+       ; Header from Utility to timing
	MOVE	Y:<NCL,A	; Move no clear command into accumulator
	MOVE	A,X:(R3)+       ; Setup the exposure without flushing the CCD
	MOVE	#DONECLR,N4	; Set internal jump address after 'DON'
	JMP	<XMT_CHK	; Transmit these

; Come to here after timing board has signaled that clearing is done
DONECLR	
	BSET	#STRT_EX,X:<STATUS
	BSET    #ST_EX,X:<STATUS ; Exposure is in progress
	MOVE	X:<HOST,A
	MOVE	A,X:(R3)+
	MOVE	X:<DON,A
	MOVE	A,X:(R3)+
	JMP     <XMT_CHK	; Issue a 'DON' - exposure has begun
	ENDIF

	IF	@SCP("EXPOSECTL","ON")
PAUSE  

	BCLR    #ST_EX,X:<STATUS ; Take out of exposing mode
        JSSET   #OPT_SH,X:<OPTIONS,CSHUT ; Close shutter if needed
        JMP     <FINISH		; Issue 'DON' and get next command
	ENDIF


	IF	@SCP("EXPOSECTL","ON")

RESUME	
	BSET    #ST_EX,X:<STATUS ; Put in exposing mode
	JSSET   #OPT_SH,X:<OPTIONS,OSHUT ; Open shutter if needed
        JMP     <FINISH		; Issue 'DON' and get next command
	ENDIF


	IF	@SCP("EXPOSECTL","ON")

ABORT	
	JSR     <CSHUT          ; To be sure
	BCLR    #ST_EX,X:<STATUS ; Take out of exposing mode
	BCLR    #CONT_EX,X:<STATUS ; Take out of continuous exposing mode
	MOVE    X:<TIMING,A
	MOVE    A,X:(R3)+       ; Header from Utility to timing
	MOVE    Y:<RDC,A
	MOVE    A,X:(R3)+       ; Read out the last frame
	JMP     <FINISH		; Issue 'DON' and get next command
	ENDIF

; A 'DON' reply has been received in response to a command issued by
;    the Utility board. Read the X:STATUS bits in responding to it.

; Test if an internal program jump is needed after receiving a 'DON' reply
PR_DONE	MOVE	N4,R0		; Get internal jump address
	MOVE	#<START,N4	; Set internal jump address to default
	JMP	(R0)		; Jump to the internal jump address

; Check for program overflow
        IF      @CVS(N,*)>$200
        WARN    'Application P: program is too large!'  ; Make sure program
        ENDIF                                           ;  will not overflow



; Command table resident in X: data memory
;  The last part of the command table is not defined for "bootrom"
;     because it contains application-specific commands

;  The commands tbl has been modified so they are keyed to EXPOSECTL and POWER

	IF	@SCP("DOWNLOAD","HOST")
	ORG	X:COM_TBL,X:COM_TBL
	ELSE			; Memory offsets for generating EEPROMs
        ORG     P:COM_TBL,P:APL_XY
	ENDIF

	IF	@SCP("POWERCTL","ON")
	DC	'PON',PWR_ON	; Power ON
	DC      'POF',PWR_OFF	; Power OFF
	ELSE
	DC	0,START,0,START
	ENDIF

	IF	@SCP("EXPOSECTL","ON")
	DC	'SEX',START_EX	; Start exposure
	DC	'PEX',PAUSE	; Pause exposure
	DC	'REX',RESUME	; Resume exposure
	DC	'AEX',ABORT	; Abort exposure
	DC	'OSH',OPEN	; Open shutter
	DC	'CSH',CLOSE	; Close shutter
	ELSE
	DC	0,START,0,START
	DC	0,START,0,START
	DC	0,START,0,START
	ENDIF

	DC      'DON',PR_DONE	; Process DON reply
	
	
	IF	@SCP("WRDACS","ON")
	DC	'WD2',WRITE_TO_DAC2 ;  Write a value to the DAC
	DC	'WD3',WRITE_TO_DAC3 ; 

	IF	@SCP("WRDACSALL","ON")
        DC      'WDA',WRITE_TO_DACA ; write to both dacs, no reply
	ELSE
	DC	0,START
	ENDIF

	ELSE
	DC	0,START
	DC	0,START,0,START
	ENDIF

	DC	'INF',GET_INFO ; Info/version command

	DC	0,START
	DC	0,START,0,START

; Y: parameter table definitions, containing no "bootrom" definitions
	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:0,Y:0		; Download address
	ELSE
        ORG     Y:0,P:		; EEPROM address continues from P: above
	ENDIF
DIG_IN  DC      0       ; Values of 16 digital input lines
DIG_OUT DC      0       ; Values of 16 digital output lines
;DAC0    DC      0       ; Table of four DAC values to be output
;DAC1    DC      1000
DAC0    DC      0000       ; Table of four DAC values to be output
DAC1    DC      0000		
DAC2    DC      2048            
DAC3    DC      2048            
NUM_AD  DC      16      ; Number of inputs to A/D converter
AD_IN   DC      0,0,0,0,0,0,0,0
        DC      0,0,0,0,0,0,0,0 ; Table of 16 A/D values
EL_TIM_MSECONDS  DC      0       ; Number of milliseconds elapsed
TGT_TIM DC      6000    ; Number of milliseconds desired in exposure
U_CCDT  DC      $C20    ; Upper range of CCD temperature control loop
L_CCDT  DC      $C50    ; Lower range of CCD temperature control loop
K_CCDT  DC      85      ; Constant of proportionality for CCDT control
A_CCDT  	EQU     AD_IN+5 ; Address of CCD temperature in A/D table
B_CCDT	EQU	AD_IN+6	; Address of Cold Head temperature in A/D table
T_CCDT	DC	$C00	; Target CCD T for small increment algorithmn
T_COEFF	DC	$70	; Coefficient for difference in temperatures
DAC0_LS	DC	0	; Least significant part of heater voltage

; Define power supply turn-on variables
	IF	@SCP("POWER","R6")
T_HV	DC      $240    ; Target HV supply voltage for Rev 6 pwr contl board
	ELSE
T_HV	DC      $4D0    ; Target HV supply voltage for Rev 2 or 3 boards
	ENDIF
K_HV	DC      $080    ; Tolerance of HV supply voltage
T_P15   DC      $5C0    ; Target +15 volts supply voltage
K_P15   DC      $080     ; Tolerance of +15 volts supply voltage
T_M15   DC      $A40    ; Target -15 volts supply voltage
K_M15   DC      $080     ; Tolerance of -15 volts supply voltage
I_HV	DC      0       ; Initial value of HV
I_P15   DC      0       ; Initial value of +15 volts
I_M15   DC      0       ; Initial value of -15 volts

; Define some command names
CLR     DC      'CLR'   ; Clear CCD
RDC     DC      'RDC'   ; Readout CCD
ABR     DC      'ABR'   ; Abort readout
OSH     DC      'OSH'   ; Open shutter connected to timing board
CSH     DC      'CSH'   ; Close shutter connected to timing board
POK     DC      'POK'   ; Message to host - power in OK
PER     DC      'PER'   ; Message to host - ERROR in power up sequence
SBV	DC	'SBV'	; Message to timing - set bias voltages
IDL	DC	'IDL'	; Message to timing - put camera in idle mode
STP	DC	'STP'	; Message to timing - Stop idling
NCL	DC	'NCL'	; Message to timing - Don't clear the CCD before an Exposure
DTH	DC	'DTH'	; Message to Timing - Dither ccd charge 

; Miscellaneous
; Heater value has been pegged to the limit given the current limiting resistors
; as of 2008 Aug 05
; CC00 now called HTMAX 2010 Oct 15

HTMAX	DC	$FFF	; Maximum heater voltage so the board doesn't burn up
;CC00	DC	$FFF	; Maximum heater voltage so the board doesn't burn up
;CC00	DC	$C00	; Maximum heater voltage so the board doesn't burn up
;CC00	DC	$000		; Set different max
SV_A1	DC	0	; Save register A1 during analog processing
SV_SR	DC	0	; Save status register during timer processing
EL_TIM_FRACTION DC 0	; Fraction of a millisecond of elapsed exposure time
INCR	DC	$CCCCCC	; Exposure time increment = 0.8 milliseconds
SH_DEL	DC	0	; Shutter closing time.  No shutter in kepler system
TEMP	DC	0	; Temporary storage location for X:PBD word
DAC1_LS	DC	0	; Least significant part of heater voltage
TGT_PIC DC	1	; Target number of pix in series.  Set by bashing
NUMPIC  DC	0	; Number of pix taken so far in this series
T_COUNT DC	0	; Number of temp samples this integration
T_SUM	DC	0	; Running sum of temps
T_AVG	DC	0	; Average temp from last integration
TH_COUNT	DC	0	; Number of temp samples this integration
TH_SUM	DC	0	; Running sum of temps
TH_AVG	DC	0	; Average temp from last integration
ONE_K   DC	1024	; Number of samples in the integration, pwr of 2
WRDAC0	DC	0	; DAC0 Voltage 
WRDAC1  DC	0	; DAC1 Voltage
WRDAC2  DC	0	; DAC2 Voltage
WRDAC3  DC	0	; DAC3 Voltage 
DSP_VERS DC	VERSION  ; code version  This must remain at locn $49!!
DACAWRS DC      0       ; count of WDA cmds received
W_CCDT	DC	$C00	; working target temperature, initially = T_CCDT
TAV_SUM	DC	0	; sum actual temperature
W_COUNT	DC	0	; count for working temp outer loop
T_RSQ_0	DC	1	; LSW for ccd dt running squared sum
T_RSQ_1	DC	1	; MSW for ccd dt running squared sum
T_LSQ_0	DC	1	; LSW for ccd dt last cycle squared sum
T_LSQ_1	DC	1	; MSW for ccd dt last cycle squared sum
T_LAVG  DC	1	; sum actual temp last cycle

	IF	@SCP("TEMPWSETPT","ON")
TAVLOOP	DC	TAVCNT	; meta-regulation loop - must match TAVSHF
MBOUND	DC	36	; bounds around T_CCDT
	ENDIF
	
; During the downloading of this application program the one millisecond 
;   timer interrupts are enabled, so the utility board will attempt to execute 
;   the partially downloaded TIMER routine, and crash. A workaround is to 
;   put a RTI as the first instruction of TIMER so it doesn't execute, then 
;   write the correct instruction only after all the rest of the application 
;   program has been downloaded. Here it is - 

	ORG	P:APL_ADR+1,P:APL_ADR+1
TIMER1	MOVEC	SR,Y:<SV_SR 		; Save Status Register


	ENDSEC		; End of SECTION UTILAPPL

; End of program
        END 
