; Miscellaneous IR array control routines, customized for John Monnier

POWER_OFF
	JSR	<CLEAR_SWITCHES		; Clear switches and DACs
	BSET	#LVEN,X:HDR 
	BSET	#HVEN,X:HDR 
	JMP	<FINISH

; Start power-on cycle
POWER_ON
	JSR	<CLEAR_SWITCHES		; Clear all analog switches
	JSR	<PON			; Turn on the power control board
	JCLR	#PWROK,X:HDR,PWR_ERR	; Test if the power turned on properly
	MOVE	#CONT_RST,R0		; Put controller in continuous readout
	MOVE	R0,X:<IDL_ADR		;   state
	JMP	<FINISH

; The power failed to turn on because of an error on the power control board
PWR_ERR	BSET	#LVEN,X:HDR		; Turn off the low voltage emable line
	BSET	#HVEN,X:HDR		; Turn off the high voltage emable line
	JMP	<ERROR

; Now ramp up the low voltages (+/- 6.5V, 16.5V) and delay them to turn on
PON	BSET	#CDAC,X:<LATCH		; Disable clearing of DACs
	MOVEP	X:LATCH,Y:WRLATCH	; Write it to the hardware
	BCLR	#LVEN,X:HDR		; LVEN = Low => Turn on +/- 6.5V, 
	MOVE	Y:<PWR_DLY,A		;   +/- 16.5V
	JSR	<MILLISEC_DELAY

; Write all the bias voltages to the DACs
SET_BIASES
	BSET	#3,X:PCRD		; Turn on the serial clock
	JSR	<PAL_DLY
	MOVE    #<ZERO_BIASES,R0	; Get starting address of DAC values
	JSR     <SET_DAC		; Write it to the hardware
	MOVE	X:<THREE,A
	JSR	<MILLISEC_DELAY
	BSET	#ENCK,X:<LATCH		; Enable clock and DAC output switches
	MOVEP	X:LATCH,Y:WRLATCH

; Turn on Vdd = digital power unit cell to the IR array
	MOVE	Y:VDD,A			; pin #5 = Vdd = array digital power
	JSR	XMIT_A_WORD
	MOVE	Y:<VDD_DLY,A		; Delay for the IR array to settle
	JSR	<MILLISEC_DELAY

	MOVE	#<DC_BIASES,R0		; Get starting address of DAC values
	JSR	<SET_DAC
	MOVE	X:<THREE,A		; Delay three millisec to settle
	JSR	<MILLISEC_DELAY

; Set clock driver DACs
	MOVE	#<DACS,R0		; Get starting address of DAC values
	JSR	<SET_DAC
	JSR	<PAL_DLY
	BCLR	#3,X:PCRD		; Turn the serial clock off
	RTS

SET_BIAS_VOLTAGES
	JSR	<SET_BIASES
	JMP	<FINISH

CLR_SWS	JSR	<CLEAR_SWITCHES
	JMP	<FINISH

CLEAR_SWITCHES
	BSET	#3,X:PCRD	; Turn the serial clock on
	MOVE	#$0C3000,A	; Value of integrate speed and gain switches
	CLR	B
	MOVE	#$100000,X0	; Increment over board numbers for DAC writes
	MOVE	#$001000,X1	; Increment over board numbers for WRSS writes
	DO	#15,L_VIDEO	; Fifteen video processor boards maximum
	JSR	<XMIT_A_WORD	; Transmit A to TIM-A-STD
	ADD	X0,A
	MOVE	B,Y:WRSS
	JSR	<PAL_DLY	; Delay for the serial data transmission
	ADD	X1,B
L_VIDEO	
	BCLR	#CDAC,X:<LATCH		; Clear the DACs
	BCLR	#ENCK,X:<LATCH		; Disable clock and DAC output switches
	MOVEP	X:LATCH,Y:WRLATCH 	; Execute these two operations
	BCLR	#3,X:PCRD		; Turn the serial clock off
	RTS

; Start the exposure timer and monitor its progress
EXPOSE	MOVEP	#0,X:TLR0		; Load 0 into counter timer
	MOVE	X:<EXPOSURE_TIME,B
	TST	B			; Special test for zero exposure time
	JEQ	<END_EXP		; Don't even start an exposure
	SUB	#1,B			; Timer counts from X:TCPR0+1 to zero
	BSET	#TIM_BIT,X:TCSR0	; Enable the timer #0
	MOVE	B,X:TCPR0
CHK_RCV	JCLR    #EF,X:HDR,CHK_TIM	; Simple test for fast execution
	MOVE	#COM_BUF,R3		; The beginning of the command buffer
	JSR	<GET_RCV		; Check for an incoming command
	JCS	<PRC_RCV		; If command is received, go check it
CHK_TIM	JCLR	#TCF,X:TCSR0,CHK_RCV	; Wait for timer to equal compare value
END_EXP	BCLR	#TIM_BIT,X:TCSR0	; Disable the timer
	JMP	(R7)			; This contains the return address

; Check for a command at the end of readout. Only ABORT should be issued.
RDA_END	MOVE	#<COM_BUF,R3
	JSR	<GET_RCV		; Was a command received?
	JCS	<CHK_ABORT_COMMAND	; If yes, see if its an abort command

; Reset array, as a subroutine
RST_FPA	MOVE	#NO_CHK,R5	; Don't check for incoming commands
	JSR	<RESET_ARRAY	; Reset the array
	MOVE	Y:<RST_DLY,A	; Enter reset delay into timer
	JSR	<MILLISEC_DELAY	; Let the reset signal settle down
	RTS

; Set the desired exposure time
SET_EXPOSURE_TIME
	MOVE	X:(R3)+,Y0
	MOVE	Y0,X:EXPOSURE_TIME
	MOVEP	Y0,X:TCPR0
	JMP	<FINISH

; Read the time remaining until the exposure ends
READ_EXPOSURE_TIME
	MOVE	X:TCR0,Y1		; Read elapsed exposure time
	JMP	<FINISH1

; Pause the exposure - close the shutter, and stop the timer
PAUSE_EXPOSURE
	MOVEP	X:TCR0,X:ELAPSED_TIME	; Save the elapsed exposure time
	BCLR    #TIM_BIT,X:TCSR0	; Disable the DSP exposure timer
	JMP	<FINISH

; Resume the exposure - open the shutter if needed and restart the timer
RESUME_EXPOSURE
	BSET	#TRM,X:TCSR0		; To be sure it will load TLR0
	MOVEP	X:TCR0,X:TLR0		; Restore elapsed exposure time
	BSET	#TIM_BIT,X:TCSR0	; Re-enable the DSP exposure timer
	JMP	<FINISH

; See if the command issued during readout is a 'ABR'. If not continue readout
CHK_ABORT_COMMAND
	MOVE	X:(R3)+,X0		; Get candidate header
	MOVE	#$000202,A 
	CMP	X0,A
	JNE	<START
WT_COM	JSR	<GET_RCV		; Get the command
	JCC	<WT_COM
	MOVE	X:(R3)+,X0		; Get candidate header
	MOVE	#'ABR',A 
	CMP	X0,A
	JNE	<START

; Special ending after abort command to send a 'DON' to the host computer
RDCCD_END_ABORT
	JCLR	#ST_RDC,X:<STATUS,ABORT_EXPOSURE
	MOVE	X:<ONE,A
	JSR	<MILLISEC_DELAY		; Wait one millisec
	MOVE	#CONT_RST,R0
	MOVE	R0,X:<IDL_ADR
	JSR	<WAIT_TO_FINISH_CLOCKING
	BCLR	#ST_RDC,X:<STATUS	; Set status to not reading out
	MOVE	#$000202,X0		; Send 'DON' to the host computer
	MOVE	X0,X:<HEADER
	JMP	<FINISH

; Abort exposure - close the shutter, stop the timer and resume idle mode
ABORT_EXPOSURE
	BCLR    #TIM_BIT,X:TCSR0	; Disable the DSP exposure timer
	JMP	<RDA_END

; Generate a synthetic image by simply incrementing the pixel counts
SYNTHETIC_IMAGE
	CLR	A
	DO      Y:<NROWS,LPR_TST      	; Loop over each line readout
	DO      Y:<NCOLS,LSR_TST	; Loop over number of pixels per line
	REP	#20			; #20 => 1.0 microsec per pixel
	NOP
	ADD	#1,A			; Pixel data = Pixel data + 1
	NOP
	MOVE	A,B
	JSR	<XMT_PIX		;  transmit them
	NOP
LSR_TST	
	NOP
LPR_TST	
        JMP     <RDA_END		; Normal exit

; Transmit the 16-bit pixel datum in B1 to the host computer
XMT_PIX	ASL	#16,B,B
	NOP
	MOVE	B2,X1
	ASL	#8,B,B
	NOP
	MOVE	B2,X0
	NOP
	MOVEP	X1,Y:WRFO
	MOVEP	X0,Y:WRFO
	RTS

; Alert the PCI interface board that images are coming soon
PCI_READ_IMAGE
	MOVE	#$020104,B		; Send header word to the FO transmitter
	JSR	<XMT_WRD
	MOVE	#'RDA',B
	JSR	<XMT_WRD
	MOVE	#1024,B		; Number of columns to read
	JSR	<XMT_WRD
	MOVE	#1024,B		; Number of rows to read	
	JSR	<XMT_WRD
	RTS

; Wait for the clocking to be complete before proceeding
WAIT_TO_FINISH_CLOCKING
	JSET	#SSFEF,X:PDRD,*		; Wait for the SS FIFO to be empty	
	RTS

; This MOVEP instruction executes in 30 nanosec, 20 nanosec for the MOVEP,
;   and 10 nanosec for the wait state that is required for SRAM writes and 
;   FIFO setup times. It looks reliable, so will be used for now.

; Core subroutine for clocking
CLOCK	JCLR	#SSFHF,X:HDR,*		; Only write to FIFO if < half full
	NOP
	JCLR	#SSFHF,X:HDR,CLOCK	; Guard against metastability
	MOVE    Y:(R0)+,X0      	; # of waveform entries 
	DO      X0,CLK1                 ; Repeat X0 times
	MOVEP	Y:(R0)+,Y:WRSS		; 30 nsec Write the waveform to the SS 	
CLK1
	NOP
	RTS                     	; Return from subroutine

; Delay for serial writes to the PALs and DACs by 8 microsec
PAL_DLY	DO	#800,DLY	 ; Wait 8 usec for serial data transmission
	NOP
DLY	NOP
	RTS

; Let the host computer read the controller configuration
READ_CONTROLLER_CONFIGURATION
	MOVE	Y:<CONFIG,Y1		; Just transmit the configuration
	JMP	<FINISH1

; Set a particular DAC numbers, for setting DC bias voltages, clock driver  
;   voltages and video processor offset
; This is code for the ARC32 clock driver
;
; SBN  #BOARD  #DAC  ['CLK' or 'VID'] voltage
;
;				#BOARD is from 0 to 15
;				#DAC number
;				#voltage is from 0 to 4095

SET_BIAS_NUMBER			; Set bias number
	BSET	#3,X:PCRD	; Turn on the serial clock
	MOVE	X:(R3)+,A	; First argument is board number, 0 to 15
	REP	#20
	LSL	A
	NOP
	MOVE	A,X1		; Save the board number
	MOVE	X:(R3)+,A	; Second argument is DAC number
	NOP
	MOVE	A1,Y:0		; Save the DAC number for a little while
	MOVE	X:(R3),B	; Third argument is 'VID' or 'CLK' string
	CMP	#'VID',B
	JNE	<CLK_DRV
	REP	#14
	LSL	A
	NOP
	BSET	#19,A1		; Set bits to mean video processor DAC
	NOP
	BSET	#18,A1
	JMP	<BD_SET
CLK_DRV	CMP	#'CLK',B
	JNE	<ERR_SBN

; For ARC32 do some trickiness to set the chip select and address bits
	MOVE	A1,B
	REP	#14
	LSL	A
	MOVE	#$0E0000,X0
	AND	X0,A
	MOVE	#>7,X0
	AND	X0,B		; Get 3 least significant bits of clock #
	CMP	#0,B
	JNE	<CLK_1
	BSET	#8,A
	JMP	<BD_SET
CLK_1	CMP	#1,B
	JNE	<CLK_2
	BSET	#9,A
	JMP	<BD_SET
CLK_2	CMP	#2,B
	JNE	<CLK_3
	BSET	#10,A
	JMP	<BD_SET
CLK_3	CMP	#3,B
	JNE	<CLK_4
	BSET	#11,A
	JMP	<BD_SET
CLK_4	CMP	#4,B
	JNE	<CLK_5
	BSET	#13,A
	JMP	<BD_SET
CLK_5	CMP	#5,B
	JNE	<CLK_6
	BSET	#14,A
	JMP	<BD_SET
CLK_6	CMP	#6,B
	JNE	<CLK_7
	BSET	#15,A
	JMP	<BD_SET
CLK_7	CMP	#7,B
	JNE	<BD_SET
	BSET	#16,A

BD_SET	OR	X1,A		; Add on the board number
	NOP
	MOVE	A,X0
	MOVE	X:(R3)+,B	; Third argument (again) is 'VID' or 'CLK' string
	CMP	#'VID',B
	JEQ	<VID
	MOVE	X:(R3)+,A	; Fourth argument is voltage value, 0 to $fff
	REP	#4
	LSR	A		; Convert 12 bits to 8 bits for ARC32
	MOVE	#>$FF,Y0	; Mask off just 8 bits
	AND	Y0,A
	OR	X0,A
	JMP	<XMT_SBN
VID	MOVE	X:(R3)+,A	; Fourth argument is voltage value for video, 12 bits
	OR	X0,A

XMT_SBN	JSR	<XMIT_A_WORD	; Transmit A to TIM-A-STD
	JSR	<PAL_DLY	; Wait for the number to be sent
	BCLR	#3,X:PCRD	; Turn the serial clock off
	JMP	<FINISH
ERR_SBN	MOVE	X:(R3)+,A	; Read and discard the fourth argument
	BCLR	#3,X:PCRD	; Turn the serial clock off
	JMP	<ERROR
	
; Specify the MUX value to be output on the clock driver board
; Command syntax is  SMX  #clock_driver_board #MUX1 #MUX2
;				#clock_driver_board from 0 to 15
;				#MUX1, #MUX2 from 0 to 23

SET_MUX BSET    #3,X:PCRD       ; Turn on the serial clock
        MOVE    X:(R3)+,A       ; Clock driver board number
        REP     #20
        LSL     A
        MOVE    #$001000,X0     ; Bits to select MUX on ARC32 board
        OR      X0,A
        NOP
        MOVE    A1,X1           ; Move here for later use
        
; Get the first MUX number
        MOVE    X:(R3)+,A       ; Get the first MUX number
        TST     A
        JLT     <ERR_SM1
        MOVE    #>24,X0         ; Check for argument less than 32
        CMP     X0,A
        JGE     <ERR_SM1
        MOVE    A,B
        MOVE    #>7,X0
        AND     X0,B
        MOVE    #>$18,X0
        AND     X0,A
        JNE     <SMX_1          ; Test for 0 <= MUX number <= 7
        BSET    #3,B1
        JMP     <SMX_A
SMX_1   MOVE    #>$08,X0
        CMP     X0,A            ; Test for 8 <= MUX number <= 15
        JNE     <SMX_2
        BSET    #4,B1
        JMP     <SMX_A
SMX_2   MOVE    #>$10,X0
        CMP     X0,A            ; Test for 16 <= MUX number <= 23
        JNE     <ERR_SM1
        BSET    #5,B1
SMX_A   OR      X1,B1           ; Add prefix to MUX numbers
        NOP
        MOVE    B1,Y1

; Add on the second MUX number
        MOVE    X:(R3)+,A       ; Get the next MUX number
        TST     A
        JLT     <ERR_SM2
        MOVE    #>24,X0         ; Check for argument less than 32
        CMP     X0,A
        JGE     <ERR_SM2
        REP     #6
        LSL     A
        NOP
        MOVE    A,B
        MOVE    #$1C0,X0
        AND     X0,B
        MOVE    #>$600,X0
        AND     X0,A
        JNE     <SMX_3          ; Test for 0 <= MUX number <= 7
        BSET    #9,B1
        JMP     <SMX_B
SMX_3   MOVE    #>$200,X0
        CMP     X0,A            ; Test for 8 <= MUX number <= 15
        JNE     <SMX_4
        BSET    #10,B1
        JMP     <SMX_B
SMX_4   MOVE    #>$400,X0
        CMP     X0,A            ; Test for 16 <= MUX number <= 23
        JNE     <ERR_SM2
        BSET    #11,B1
SMX_B   ADD     Y1,B            ; Add prefix to MUX numbers
        NOP
        MOVE    B1,A
        AND     #$F01FFF,A      ; Just to be sure
        JSR     <XMIT_A_WORD    ; Transmit A to TIM-A-STD
        JSR     <PAL_DLY        ; Delay for all this to happen
        BCLR    #3,X:PCRD       ; Turn the serial clock off
        JMP     <FINISH
ERR_SM1 MOVE    X:(R3)+,A       ; Throw off the last argument
ERR_SM2 BCLR    #3,X:PCRD       ; Turn the serial clock off
        JMP     <ERROR

; Write a number to an analog board over the serial link
WR_BIAS	BSET	#3,X:PCRD	; Turn on the serial clock
	JSR	<PAL_DLY
	JSR	<XMIT_A_WORD	; Transmit it to TIM-A-STD
	JSR	<PAL_DLY
	BCLR	#3,X:PCRD	; Turn off the serial clock
	JSR	<PAL_DLY
	RTS

; Read DAC values from a table, and write them to the DACs
SET_DAC	DO      Y:(R0)+,L_DAC		; Repeat Y:(R0)+ times
	MOVE	Y:(R0)+,A		; Read the table entry
	JSR	<XMIT_A_WORD		; Transmit it to TIM-A-STD
	NOP
L_DAC	RTS
	
; Short delay for the array to settle down after a global reset
MILLISEC_DELAY
	TST	A
	JNE	<DLY_IT
	RTS
DLY_IT	SUB	#1,A
	MOVEP	#0,X:TLR0		; Load 0 into counter timer
	BSET	#TIM_BIT,X:TCSR0	; Enable the timer #0
	MOVE	A,X:TCPR0		; Desired elapsed time
CNT_DWN	JCLR	#TCF,X:TCSR0,CNT_DWN	; Wait here for timer to count down
	BCLR	#TIM_BIT,X:TCSR0
	RTS

; Set number of readout pairs in multiple readout mode
SET_NUM_READS
	MOVE	X:(R3)+,X0
	MOVE	X0,Y:<N_RA
	JMP	<FINISH
