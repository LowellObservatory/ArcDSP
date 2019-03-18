       COMMENT *

This file contains timing waveforms for the e2v CCD42-40 2048 x 2052 pixel CCD

This CCD has two outputs, left and right.

$00F000	Left 	A/D #0  Blue  Pin 3   LOIS L
$00F021	Right	A/D #1  Red   Pin 10  LOIS R
$00F020	Both	A/D #0 and 1

	*

	PAGE    132     ; Printronix page width - 132 columns

; Definitions of readout variables
CLK2	EQU	$002000		; Clock driver board lower half
CLK3	EQU	$003000		; Clock driver board lower half
VIDEO	EQU	$000000		; Video processor board switches
BA_IDLY EQU	$010000		; Ring delay, 100 ns
BB_IDLY EQU	$010000		; Ring Delay, 100 ns
P_DLY	EQU	$8C0000		; Parallel clock delay, 2 us overlaps
S_DLY	EQU	$000000		; Serial delay, 40 ns overlaps
INT_TIM EQU	$150000		; Dual slope integration time = 500 ns

; Define switch state bits for the CCD clocks
; Leave in the vestigial S3R, SWR, RGR, P1L, P2L, P3L to simplify mods to waveforms
; and to make it easier to use in a future CCD that has these signals.

; Now for CLK2, which is the lower bank
S1L	EQU	1	; Serial shift register phase #1, Left
S2L	EQU	2	; Serial shift register phase #2, Left
S3L	EQU	4	; Serial shift register phase #3, Left
S1R	EQU	8	; Serial shift register phase #1, Right
S2R	EQU	$10	; Serial shift register phase #2, Right
S3R	EQU	$20	; Serial shift register phase #3, Right, not connected
SWL	EQU	$40	; Summing well, Left
SWR	EQU	$80	; Summing well, Right, not connected
RGL	EQU	$100	; Reset gate, Left
RGR	EQU	$200	; Reset gate, Right, not connected

; CLK3, which is the upper bank

P1U	EQU	1	; Parallel shift register phase #1, Upper
P2U	EQU	2	; Parallel shift register phase #2, Upper
P3U	EQU	4	; Parallel shift register phase #3, Upper
P1L	EQU	8	; Parallel shift register phase #1, Lower, not connected
P2L	EQU	$10	; Parallel shift register phase #2, Lower, not connected
P3L     EQU	$20	; Parallel shift register phase #3, Lower, not connected
TGU	EQU	$40	; Transfer Gate Upper, not connected
DGH	EQU	$80	; Dump Gate

; Define the clocking voltages
RG_HI	EQU	+3.2	; Real volts
RG_LO	EQU	-8.8
SW_HI	EQU	+2.2	; These voltages based on e2v test data sheet
SW_LO	EQU	-7.8	;
S_HI	EQU	+2.2	;	
S_LO	EQU	-7.8	;		
P_HI	EQU	+3.2	;	
P_LO	EQU	-8.8	;		
DG_HI	EQU	+3.2
DG_LO	EQU	-8.8
ZERO	EQU	 0.0

; DC Bias definition - tweak to produce correct volts in service
VOD	EQU	+23.30	; Output Drain, real volts - to get 22.2V at the CCD
VRD	EQU	+10.05	; Reset Drain - to get 9.2V at the CCD
VOG1	EQU	-5.85	; Output Gate 1 - to get -5.8V
VOG2	EQU	-4.85	; Output Gate 2 - to get -4.8V
VDD	EQU	+15.65	; Dump Drain - to get 15.2V

; Output offset variables
;OFFSET0		EQU	$8C0 ; Values to use for live CCD gain 2
;OFFSET1		EQU	$8C0 ; Values to use for live CCD gain 2
;OFFSET0         EQU     $A60 ; Values to use for live CCD gain 5
;OFFSET1         EQU     $A60 ; Values to use for live CCD gain 5
OFFSET0	EQU	$700		; Testing Value
OFFSET1	EQU	$700		; Testing Value
OFFSET2	EQU	$A00
OFFSET3	EQU	$BA0

;  ***  Clock word definitions for Y: memory waveform tables  *****
;	DC	CLK2+S_DLY+S1R+S2R+S3R+S1L+S2L+S3L+SWL+SWR+RGL+RGR
;	DC	CLK3+P_DLY+P1U+P2U+P3U+P1L+P2L+P3L+DGH
; Make sure simultaneous clocking of upper and lower banks is DISABLED

; Serial idle in BOTH directions for speed (Serial split)
SERIAL_IDLE
	DC	END_SERIAL_IDLE-SERIAL_IDLE-2
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+S_DLY+000+S2R+000+000+S2L+000+000+000+RGL+RGR
	DC	CLK2+S_DLY+000+S2R+S3R+000+S2L+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+000+S3R+000+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+S3R+S1L+000+S3L+SWL+SWR+000+000
	DC	VIDEO+BA_IDLY+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate
	DC	VIDEO+$000000+%0011011	; Stop Integrate
	DC	CLK2+S_DLY+S1R+000+000+S1L+000+000+000+000+000+000
	DC	VIDEO+BB_IDLY+%0011011	; Delay for signal to settle
	DC	VIDEO+INT_TIM+%0001011	; Integrate
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000
END_SERIAL_IDLE

RESET_NODE
	DC	END_RESET_NODE-RESET_NODE-2
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+RGL+RGR
	DC	VIDEO+$000000+%1110100	; Change nearly everything
END_RESET_NODE

SERIAL_CLOCK_ALL		; Both amplifiers
	DC	END_SERIAL_CLOCK_ALL-SERIAL_CLOCK_ALL-2
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+S2R+000+000+S2L+000+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+S2R+S3R+000+S2L+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+000+S3R+000+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+S3R+S1L+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+000+S1L+000+000+SWL+SWR+000+000
END_SERIAL_CLOCK_ALL

SERIAL_CLOCK_AR		; Serial right, Swap S1L and S2L
	DC	END_SERIAL_CLOCK_AR-SERIAL_CLOCK_AR-2
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+S2R+000+S1L+000+000+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+S2R+S3R+S1L+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+000+S3R+000+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+S3R+000+S2L+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+000+000+S2L+000+SWL+SWR+000+000
END_SERIAL_CLOCK_AR

SERIAL_CLOCK_AL		; Serial left, Swap S1R and S2R
	DC	END_SERIAL_CLOCK_AL-SERIAL_CLOCK_AL-2
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+000+000+S2L+000+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+S3R+000+S2L+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+000+S3R+000+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+S2R+S3R+S1L+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+S2R+000+S1L+000+000+SWL+SWR+000+000
END_SERIAL_CLOCK_AL
	
SERIAL_CLEAR
	DC	END_SERIAL_CLEAR-SERIAL_CLEAR-2
	DC	CLK2+S_DLY+000+S2R+000+000+S2L+000+000+000+RGL+RGR
	DC	CLK2+S_DLY+000+S2R+S3R+000+S2L+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+000+S3R+000+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+S3R+S1L+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+000+S1L+000+000+000+000+000+000
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000
END_SERIAL_CLEAR

VIDEO_PROCESS
	DC	END_VIDEO_PROCESS-VIDEO_PROCESS-2
SXMIT_VIDEO_PROCESS
	DC	$00F021			; Transmit A/D #0 data to host
	DC	VIDEO+BA_IDLY+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate
	DC	VIDEO+$000000+%0011011	; Stop Integrate
CCLK_1	; The following line is overwritten by timmisc.s
	DC	CLK2+S_DLY+S3R+000+000+S3L+000+000+000+000+000+000
	DC	VIDEO+BB_IDLY+%0011011	; Delay for signal to settle
	DC	VIDEO+INT_TIM+%0001011	; Integrate
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
CCLK_2	; The following line is overwritten by timmisc.s, but is correct as is.
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000
END_VIDEO_PROCESS

; Starting Y: address of circular waveforms for no-overhead access
STRT_CIR	 EQU	$A0
ROM_DISP	EQU	APL_NUM*N_W_APL+APL_LEN+MISC_LEN+COM_LEN+STRT_CIR
DAC_DISP	EQU	APL_NUM*N_W_APL+APL_LEN+MISC_LEN+COM_LEN+$100

; Check for Y: data memory overflow
	IF	@CVS(N,*)>STRT_CIR
	WARN    'Application Y: data memory is too large!' ; Make sure Y:
	ENDIF						   ;  will not overflow

; The fast serial code with the circulating address register must start 
;   on a boundary that is a multiple of the address register modulus.

	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR,Y:STRT_CIR			; Download address
	ELSE
	ORG     Y:STRT_CIR,P:ROM_DISP
	ENDIF

; Fast Serials readout for single amplifier readout through the left corner
;    xfer, A/D, integ, Pol+, Pol-, DCclamp, rst  (1 => switch open)
SERIAL_READ_AR	; Read from R amp, swap S1L and S2L
	DC	CLK2+S_DLY+000+S2R+000+000+S1L+000+000+000+RGL+RGR
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+S_DLY+000+S2R+S3R+000+S1L+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+000+S3R+000+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+S3R+S2L+000+S3L+SWL+SWR+000+000
SXMIT_AR
	DC	$00F021			; Transmit A/D #1 data to host
	DC	VIDEO+BA_IDLY+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate
	DC	VIDEO+$000000+%0011011	; Stop Integrate
RCLK_1	DC	CLK2+S_DLY+S1R+000+000+S2L+000+000+000+000+000+000
	DC	VIDEO+BB_IDLY+%0011011	; Delay for signal to settle
	DC	VIDEO+INT_TIM+%0001011	; Integrate
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
RCLK_2	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000
END_SERIAL_READ_AR

	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR+$10,Y:STRT_CIR+$10		; Download address
	ELSE
	ORG     Y:STRT_CIR+$10,P:ROM_DISP+$10
	ENDIF

SERIAL_READ_AL	; Read from L amp, swap S1R and S2R
	DC	CLK2+S_DLY+S1R+000+000+000+S2L+000+000+000+RGL+RGR
	DC	VIDEO+$000000+%1110100	;Change nearly everything
	DC	CLK2+S_DLY+S1R+000+S3R+000+S2L+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+000+S3R+000+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+S2R+S3R+S1L+000+S3L+SWL+SWR+000+000
SXMIT_AL
	DC	$00F000		; Transmit A/D #0 data to host
	DC	VIDEO+BA_IDLY+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate
	DC	VIDEO+$000000+%0011011	; Stop Integrate
	DC	CLK2+S_DLY+000+S2R+000+S1L+000+000+000+000+000+000
	DC	VIDEO+BB_IDLY+%0011011	; Delay for signal to settle
	DC	VIDEO+INT_TIM+%0001011	; Integrate
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000
END_SERIAL_READ_AL

	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR+$20,Y:STRT_CIR+$20		; Download address
	ELSE
	ORG     Y:STRT_CIR+$20,P:ROM_DISP+$20
	ENDIF

SERIAL_READ_ALL
	DC	CLK2+S_DLY+000+S2R+000+000+S2L+000+000+000+RGL+RGR
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+S_DLY+000+S2R+S3R+000+S2L+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+000+S3R+000+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+S3R+S1L+000+S3L+SWL+SWR+000+000
SXMIT_ALL
	DC	$00F020			; Transmit A/D #0 & #1 data to host
	DC	VIDEO+BA_IDLY+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate
	DC	VIDEO+$000000+%0011011	; Stop Integrate
	DC	CLK2+S_DLY+S1R+000+000+S1L+000+000+000+000+000+000
	DC	VIDEO+BB_IDLY+%0011011	; Delay for signal to settle
	DC	VIDEO+INT_TIM+%0001011	; Integrate
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000
END_SERIAL_READ_ALL

	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR+$30,Y:STRT_CIR+$30		; Download address
	ELSE
	ORG     Y:STRT_CIR+$30,P:ROM_DISP+$30
	ENDIF

	; These are the three skipping tables. Make sure they're all the same
SERIAL_SKIP_CLOCKS		; Serial clocking waveform for skipping All
	DC	END_SERIAL_SKIP_CLOCKS-SERIAL_SKIP_CLOCKS-2
	DC	CLK2+S_DLY+000+S2R+000+000+S2L+000+000+000+RGL+RGR
	DC	CLK2+S_DLY+000+S2R+S3R+000+S2L+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+000+S3R+000+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+S3R+S2L+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+000+S2L+000+000+000+000+000+000
	DC	CLK2+S_DLY+S1R+S2R+000+S2L+S1L+000+000+000+000+000
END_SERIAL_SKIP_CLOCKS

	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR+$40,Y:STRT_CIR+$40		; Download address
	ELSE
	ORG     Y:STRT_CIR+$40,P:ROM_DISP+$40
	ENDIF

SERIAL_SKIP_AL		; Serial skip to Left amp, reverse S1R & S2R
	DC	END_SERIAL_SKIP_AL-SERIAL_SKIP_AL-2
	DC	CLK2+S_DLY+S1R+000+000+000+S2L+000+000+000+RGL+RGR
	DC	CLK2+S_DLY+S1R+000+S3R+000+S2L+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+000+S3R+000+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+S2R+S3R+S1L+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+S2R+000+S1L+000+000+000+000+000+000
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000
END_SERIAL_SKIP_AL

	
	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR+$50,Y:STRT_CIR+$50		; Download address
	ELSE
	ORG     Y:STRT_CIR+$50,P:ROM_DISP+$50
	ENDIF

	

SERIAL_SKIP_AR		; Serial skip to right amp, reverse S1L & S2L
	DC	END_SERIAL_SKIP_AR-SERIAL_SKIP_AR-2
	DC	CLK2+S_DLY+000+S2R+000+S1L+000+000+000+000+RGL+RGR
	DC	CLK2+S_DLY+000+S2R+S3R+S1L+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+000+000+S3R+000+000+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+S3R+000+S2L+S3L+SWL+SWR+000+000
	DC	CLK2+S_DLY+S1R+000+000+000+S2L+000+000+000+000+000
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000
END_SERIAL_SKIP_AR

	

; Put all the following code in SRAM.
	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:$100,Y:$100				; Download address
	ELSE
	ORG	Y:$100,P:DAC_DISP
	ENDIF

PARALLEL_LOWER
	DC	END_PARALLEL_LOWER-PARALLEL_LOWER-2 ; 3 -> 1 -> 2 -> 3;2 -> TG
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+RGL+RGR
	DC	CLK3+P_DLY+000+000+P2L+P2U+000+000+000
	DC	CLK3+P_DLY+000+000+P2L+P2U+P3L+P3U+000
	DC	CLK3+P_DLY+000+000+000+000+P3L+P3U+000
	DC	CLK3+P_DLY+P1L+P1U+000+000+P3L+P3U+000
	DC	CLK3+P_DLY+P1L+P1U+000+000+000+000+000
	DC	CLK3+P_DLY+P1L+P1U+P2L+P2U+000+000+000
	DC	CLK3+P_DLY+000+000+P2L+P2U+000+000+000
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000
END_PARALLEL_LOWER
	
; Define a faster delay time for flush (clear) mode, and do it in split mode
PARALLEL_SPLIT_CLEAR 	
	DC	END_PARALLEL_SPLIT_CLEAR-PARALLEL_SPLIT_CLEAR-2
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+RGL+RGR
	DC	CLK3+P_DLY+000+000+P2L+P2U+000+000+000
	DC	CLK3+P_DLY+000+000+P2L+P2U+P3L+P3U+000
	DC	CLK3+P_DLY+000+000+000+000+P3L+P3U+000
	DC	CLK3+P_DLY+P1L+P1U+000+000+P3L+P3U+000
	DC	CLK3+P_DLY+P1L+P1U+000+000+000+000+000
	DC	CLK3+P_DLY+P1L+P1U+P2L+P2U+000+000+000
	DC	CLK3+P_DLY+000+000+P2L+P2U+000+000+DGH
	DC	CLK2+S_DLY+000+000+000+000+000+000+000+000+RGL+RGR
	DC	CLK3+P_DLY+000+000+P2L+P2U+000+000+DGH
	DC	CLK3+P_DLY+000+000+P2L+P2U+000+000+000
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+RGL+RGR
	DC	CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000
END_PARALLEL_SPLIT_CLEAR
; Initialization of clock driver and video processor DACs and switches
DACS	DC	END_DACS-DACS-1
	DC	(CLK2<<8)+(0<<14)+@CVI((S_HI+10.0)/20.0*4095) 	; #1, Serial Phase 1L
	DC	(CLK2<<8)+(1<<14)+@CVI((S_LO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(2<<14)+@CVI((S_HI+10.0)/20.0*4095) 	; #2, Serial Phase 2L
	DC	(CLK2<<8)+(3<<14)+@CVI((S_LO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(4<<14)+@CVI((S_HI+10.0)/20.0*4095)	; #3, Serial Phase 3L
	DC	(CLK2<<8)+(5<<14)+@CVI((S_LO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(6<<14)+@CVI((S_HI+10.0)/20.0*4095)	; #4, Serial Phase 1R
	DC	(CLK2<<8)+(7<<14)+@CVI((S_LO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(8<<14)+@CVI((S_HI+10.0)/20.0*4095)	; #5, Serial Phase 2R
	DC	(CLK2<<8)+(9<<14)+@CVI((S_LO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(10<<14)+@CVI((ZERO+10.0)/20.0*4095)	; #6, Not Connected
	DC	(CLK2<<8)+(11<<14)+@CVI((ZERO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(12<<14)+@CVI((SW_HI+10.0)/20.0*4095)	; #7, Summing Well
	DC	(CLK2<<8)+(13<<14)+@CVI((SW_LO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(14<<14)+@CVI((ZERO+10.0)/20.0*4095)	; #8, Not Connected
	DC	(CLK2<<8)+(15<<14)+@CVI((ZERO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(16<<14)+@CVI((RG_HI+10.0)/20.0*4095)	; #9, Reset Gate
	DC	(CLK2<<8)+(17<<14)+@CVI((RG_LO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(18<<14)+@CVI((ZERO+10.0)/20.0*4095)	; #10, Not Connected
	DC	(CLK2<<8)+(19<<14)+@CVI((ZERO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(20<<14)+@CVI((ZERO+10.0)/20.0*4095)	; #11, Not Connected
	DC	(CLK2<<8)+(21<<14)+@CVI((ZERO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(22<<14)+@CVI((ZERO+10.0)/20.0*4095)	; #12, Not Connected
	DC	(CLK2<<8)+(23<<14)+@CVI((ZERO+10.0)/20.0*4095)

; These are the same definitions except for the upper half of the CCD
	DC	(CLK2<<8)+(24<<14)+@CVI((P_HI+10.0)/20.0*4095)  ; #13, Parallel #1
	DC	(CLK2<<8)+(25<<14)+@CVI((P_LO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(26<<14)+@CVI((P_HI+10.0)/20.0*4095)  ; #14, Parallel #2
	DC	(CLK2<<8)+(27<<14)+@CVI((P_LO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(28<<14)+@CVI((P_HI+10.0)/20.0*4095)	; #15, Parallel #3
	DC	(CLK2<<8)+(29<<14)+@CVI((P_LO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(30<<14)+@CVI((ZERO+10.0)/20.0*4095)	; #16, Not Connected
	DC	(CLK2<<8)+(31<<14)+@CVI((ZERO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(32<<14)+@CVI((ZERO+10.0)/20.0*4095)	; #17, Not Connected
	DC	(CLK2<<8)+(33<<14)+@CVI((ZERO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(34<<14)+@CVI((ZERO+10.0)/20.0*4095)	; #18, Not Connected
	DC	(CLK2<<8)+(35<<14)+@CVI((ZERO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(36<<14)+@CVI((ZERO+10.0)/20.0*4095)	; #19, Not Connected
	DC	(CLK2<<8)+(37<<14)+@CVI((ZERO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(38<<14)+@CVI((DG_HI+10.0)/20.0*4095) ; #33, Dump Gate
	DC	(CLK2<<8)+(39<<14)+@CVI((DG_LO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(40<<14)+@CVI((ZERO+10.0)/20.0*4095)	; #34, Not Connected
	DC	(CLK2<<8)+(41<<14)+@CVI((ZERO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(42<<14)+@CVI((ZERO+10.0)/20.0*4095)	; #35, Not Connected
	DC	(CLK2<<8)+(43<<14)+@CVI((ZERO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(44<<14)+@CVI((ZERO+10.0)/20.0*4095)	; #36, Not Connected
	DC	(CLK2<<8)+(45<<14)+@CVI((ZERO+10.0)/20.0*4095)
	DC	(CLK2<<8)+(46<<14)+@CVI((ZERO+10.0)/20.0*4095)	; #37, Not Connected
	DC	(CLK2<<8)+(47<<14)+@CVI((ZERO+10.0)/20.0*4095)

; Set gain and integrator speed. x2 gain, fast integrate
	DC	$0c3fbb	
	DC	$1c3fbb

;	DC	$0c3f77			; x1    Gain, fast integrate
;	DC	$0c3fbb			; x2    Gain, fast integrate
;	DC	$0c3fdd			; x4.75 Gain, fast integrate
;	DC	$0c3fee			; x9    Gain, fast integrate

; Input offset voltages for DC coupling. Target is U4#6 = 24 volts
	DC	$0c0800			; Input offset, Left
	DC	$0c8800			; Input offset, Right
	DC	$1c0800			; Input offset, Left
	DC	$1c8800			; Input offset, Right

; Output offset voltages to get about 1000 A/D units
	DC	$0c4000+OFFSET0		; Output video offset, Left
	DC	$0cc000+OFFSET1		; Output video offset, Right
;	DC	$1c4000+OFFSET2		; Output video offset, Left
;	DC	$1cc000+OFFSET3		; Output video offset, Right

; Various gate voltages, video board #0
	DC	$0d0000+@CVI((VOD-7.5)/22.5*4095)	; Vod Output Drain, Left, pin #1
	DC	$0d4000+@CVI((VOD-7.5)/22.5*4095)	; Vod Output Drain, Right, pin #2
	DC	$0d8000+@CVI((VRD-5.0)/15.0*4095)	; Vrd Reset Drain, Left, pin #3
	DC	$0dc000+@CVI((VRD-5.0)/15.0*4095)	; Vrd Reset Drain, Right, pin #4
	DC	$0e0000+@CVI((VDD-5.0)/15.0*4095)	; VDD Dump Drain, pin #5

	DC	$0f0000+@CVI((ZERO+5.0)/10.0*4095) 	; Not connected, pin #9
	DC	$0f4000+@CVI((ZERO+5.0)/10.0*4095) 	; Not connected, pin #10
	DC	$0f8000+@CVI((VOG1+10.0)/20.0*4095) 	; Output Gate 1, pin #11
	DC	$0fc000+@CVI((VOG2+10.0)/20.0*4095) 	; Output Gate 2, pin #12


END_DACS

; Check for overflow in the EEPROM case
	IF	@SCP("DOWNLOAD","EEPROM")
		IF	@CVS(N,@LCV(L))>(APL_NUM+1)*N_W_APL
	WARN    'EEPROM overflow!'	; Make sure the next application
		ENDIF			;  will not be overwritten
	ENDIF

