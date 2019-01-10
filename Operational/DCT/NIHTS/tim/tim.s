       COMMENT *

This file is used to generate DSP code for the a Gen III = ARC22
	timing board to operate a 1k pixel HAWAII infrared 
	array at 3.0 microsec per pixel and subarray readout.
	It also assumes use of an ARC32 clock driver board. 
   *

   PAGE    132     ; Printronix page width - 132 columns

; Include the boot and header files so addressing is easy
	INCLUDE	"timboot.s"

	ORG	P:,P:

CC	EQU	IRREV4+TIMREV5


; Put number of words of application in P: for loading application from EEPROM
	DC	TIMBOOT_X_MEMORY-@LCV(L)-1

;  Reset entire array and don't transmit any pixel data
RESET_ARRAY
	MOVE	#<READ_ON,R0		; Turn Read ON 
	JSR	<CLOCK
	MOVE	#<FRAME_INIT,R0
	JSR	<CLOCK
	DO	#256,END_FRAME
	MOVE	#<SHIFT_RESET_ODD_ROW,R0 ; Shift and reset the line
	JSR	<CLOCK
	DO	#256,L_ODD
	MOVE	#<SHIFT_ODD_ROW_PIXELS,R0
	JSR	<CLOCK
	NOP
L_ODD
	MOVE	#<SHIFT_RESET_EVEN_ROW,R0 ; Shift and reset the line
	JSR	<CLOCK
	DO	#256,L_EVEN
	MOVE	#<SHIFT_EVEN_ROW_PIXELS,R0
	JSR	<CLOCK
	NOP
L_EVEN	
	JSR	(R5)		; Check for incoming command if in continuous
	JCC	<NOT_COMMAND	;  reset mode
	ENDDO			; If there is an incoming command then exit
	JMP	<RST_END	;  continuous mode and return
NOT_COMMAND
	NOP
END_FRAME NOP
	MOVE	#<READ_OFF,R0	; Turn Read OFF
	JSR	<CLOCK
	RTS			; Return from subroutine call

RST_END	MOVE	#<READ_OFF,R0	; Turn Read OFF
	JSR	<CLOCK
	BSET	#0,SR		; Set carry bit to indicate command was received
	NOP
	RTS

; Dummy subroutine to not call receiver checking routine
NO_CHK	BCLR	#0,SR		; Clear status register clear bit
	NOP
	RTS

;  ***********************   ARRAY READOUT   ********************
RD_ARRAY
	BSET	#ST_RDC,X:<STATUS 	; Set status to reading out
	JSR	<PCI_READ_IMAGE		; Wake up the PCI interface board
	JSET	#TST_IMG,X:STATUS,SYNTHETIC_IMAGE

	MOVE	#<READ_ON,R0		; Turn Read ON and wait 5 milliseconds
	JSR	<CLOCK			;    so first few rows aren't at high
	DO	#598,DLY_ON		;    count levels
	JSR	<PAL_DLY
	NOP
DLY_ON

	MOVE    #<FRAME_INIT,R0		; Initialize the frame for readout
	JSR     <CLOCK

	DO	#256,FRAME

; First shift and read the odd numbered rows
	MOVE	#<SHIFT_ODD_ROW,R0		; Shift odd numbered rows
	JSR	<CLOCK
	MOVE	#<SHIFT_ODD_ROW_PIXELS,R0	; Shift 2 columns, no transmit
	JSR	<CLOCK

	DO	#255,L_ODD_ROW
	MOVE	#<READ_ODD_ROW_PIXELS,R0	; Read the pixels in odd rows
	JSR	<CLOCK
	NOP
L_ODD_ROW
	MOVE	#<SXMIT_EIGHT_PIXELS,R0		; Series transmit last 8 pixels
	JSR	<CLOCK

; Then shift and read the even numbered rows
	MOVE	#<SHIFT_EVEN_ROW,R0		; Shift even numbered rows
	JSR	<CLOCK
	MOVE	#<SHIFT_EVEN_ROW_PIXELS,R0	; Shift 2 columns, no transmit
	JSR	<CLOCK

	DO	#255,L_EVEN_ROW
	MOVE	#<READ_EVEN_ROW_PIXELS,R0	; Read the pixels in even rows
	JSR	<CLOCK
	NOP
L_EVEN_ROW
	MOVE	#<SXMIT_EIGHT_PIXELS,R0		; Series transmit last 8 pixels
	JSR	<CLOCK
	NOP
FRAME
	MOVE	#<READ_OFF,R0		; Turn Read Off
	JSR	<CLOCK
CONTINUE_READ				; No-op
	DO	#1000,*+4		; Delay for the PCI board to catch up
	JSR	<PAL_DLY
	NOP

	BCLR	#ST_RDC,X:<STATUS 	; Set status to reading out
	RTS

;  *********************  Acquire a complete image  **************************
; Reset array, wait, read it out n times, expose, read it out n times
START_EXPOSURE
	MOVE	#$020102,B
	JSR	<XMT_WRD
	MOVE	#'IIA',B
	JSR	<XMT_WRD
	MOVE	#NO_CHK,R5	; Don't check for incoming commands
	JSR	<RESET_ARRAY	; Reset the array twice
	MOVE	Y:<RST_DLY,A	; Enter reset delay into timer
	JSR	<MILLISEC_DELAY	; Let the reset signal settle down
	DO	Y:<N_RA,L_MRA1  ; Read N_RA times
	JSR	<RD_ARRAY       ; Call read array subroutine
	NOP
L_MRA1
	MOVE	#L_MRA2,R7
	JMP	<EXPOSE         ; Delay for specified exposure time
L_MRA2 	
	DO	Y:<N_RA,L_MRA3  ; Read N_RA times again
	JSR	<RD_ARRAY       ; Call read array subroutine
	NOP
L_MRA3
	JMP	<START		; This is the end of the exposure

; Continuously reset array, checking for host commands every line
CONT_RST
	MOVE	#<COM_BUF,R3
	MOVE	#<GET_RCV,R5
	JSR	<RESET_ARRAY
	JCS	<PRC_RCV	; Process the command if its there
	JMP	<CONT_RST

; ******  Minclude many routines not directly needed for readout  *******
	INCLUDE "timIRMisc.s"

TIMBOOT_X_MEMORY	EQU	@LCV(L)

; Define the address in P: space where the table of constants begins

	IF	@SCP("DOWNLOAD","HOST")
	ORG     X:END_COMMAND_TABLE,X:END_COMMAND_TABLE
	ENDIF

	IF	@SCP("DOWNLOAD","ROM")
	ORG     X:END_COMMAND_TABLE,P:
	ENDIF

	DC	'SEX',START_EXPOSURE
	DC      'AEX',ABORT_EXPOSURE
	DC      'PON',POWER_ON
	DC      'POF',POWER_OFF	
	DC	'SET',SET_EXPOSURE_TIME
	DC	'RET',READ_EXPOSURE_TIME
	DC	'SNR',SET_NUM_READS
	DC	'SBN',SET_BIAS_NUMBER
	DC	'SMX',SET_MUX
	DC	'SBV',SET_BIASES   
	DC	'RCC',READ_CONTROLLER_CONFIGURATION 
	DC      'DON',START

END_APPLICATON_COMMAND_TABLE	EQU	@LCV(L)

	IF	@SCP("DOWNLOAD","HOST")
NUM_COM			EQU	(@LCV(R)-COM_TBL_R)/2	; Number of boot + 
							;  application commands
EXPOSING		EQU	CHK_TIM			; Address if exposing
CONTINUE_READING	EQU	CONTINUE_READ 		; Address if reading out
	ENDIF

	IF	@SCP("DOWNLOAD","ROM")
	ORG     Y:0,P:
	ENDIF

; Now let's go for the timing waveform tables
	IF	@SCP("DOWNLOAD","HOST")
        ORG     Y:0,Y:0
	ENDIF

GAIN	DC	END_APPLICATON_Y_MEMORY-@LCV(L)-1

NCOLS	DC	255		; Number of columns (not used)
NROWS	DC	256		; Number of rows (not used)
N_RA	DC	1		; Number of reads
RST_DLY	DC	50		; Delay after array reset for settling
PWR_DLY	DC	100		; Delay in millisec for power to turn on
VDD_DLY	DC	300		; Delay in millise for VDD to settle   
CONFIG	DC	CC		; Controller configuration
TST_DAT	DC	0		; Synthetic image test datum

; Include the waveform table for the PICNIC focal plane array
	INCLUDE "Hawaii.waveforms.s" ; Readout and clocking waveform file

END_APPLICATON_Y_MEMORY	EQU	@LCV(L)

; End of program
	END
