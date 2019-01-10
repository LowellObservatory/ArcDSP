; Modified 12 Aug 2015 by plc to swap pins 5 and 6- these were Pixel, Read, 
; respectively
; are now
; Read, Pixel, respectively.
;
; This due to a wiring error in the cable from clock board to hermetic connector
; as per ewd email Aug 12, 2015 "NIHTS DSP Change"
;
; Miscellaneous definitions
VIDEO	EQU     $000000	; Video board select = 0 for first A/D board with biases
CLK2	EQU     $002000 ; Clock board select = 2 
F_DELAY	EQU	$050000 ; Delay for fast clocking operations 
S_DELAY	EQU	$300000 ; Delay for slow clocking operations 
SXMIT   EQU     $00F0C0 ; Series transmit A/D channels #0 to 3

; Clock voltage definitions
CLK_HI	EQU	4.0	; Assuming a 5.0 volt board
CLK_LO	EQU	0.2
Vmax	EQU	5.0	; Maximum clock driver voltage
ZERO	EQU	0.0

; DAC settings for the video offsets
DC_BIASES
	DC	END_DC_BIASES-DC_BIASES-1
OFF_0	DC	$0c0705		; Input offset board #0, channel A
OFF_1	DC	$0c49E2		; Input offset board #0, channel B
OFF_2	DC	$1c0AAA		; Input offset board #1, channel A
OFF_3	DC	$1c48D7		; Input offset board #1, channel B

; DAC settings to generate DC bias voltages for the HAWAII array
VOFFSET	DC	$0c8c20		; Board 0, pin #1 = preamp offset = +3.79 volts
VUNUSE1	DC	$0cc000		; Board 0, pin #2 = unused to 0V
VRESET1	DC	$1c8195		; Board 1, pin #1 = reset = +0.5 volts
VRESET2	DC	$1cc195		; Board 1, pin #2 = reset = +0.5 volts
VRESET3	DC	$1d0195		; Board 1, pin #3 = reset = +0.5 volts
VRESET4	DC	$1d4195		; Board 1, pin #4 = reset = +0.5 volts
VD	DC	$0d0fff		; Board 0, pin #3 = analog power = +5.0 volts
VUNUSE2	DC	$0d4000		; Board 0, pin #4 = unused to 0V
ICTL1_4	DC	$1d8bd4		; Board 1, pin #5 = current control = +3.7 volts
ICTL2_3	DC	$1dcbd4		; Board 1, pin #6 = current control = +3.7 volts
VDD	DC	$0d8ccb		; Board 0, pin #5 = digital power = +4.0 volts  
VUNUSE3	DC	$0dc000		; Board 0, pin #6 = unused to 0V
END_DC_BIASES

;  Zero out the DC biases during the power-on sequence
ZERO_BIASES
	DC END_ZERO_BIASES-ZERO_BIASES-1
	DC $0c8000     ; Pin #1, board #0
	DC $0cc000     ; Pin #2
	DC $0d0000     ; Pin #3
	DC $0d4000     ; Pin #4
	DC $0d8000     ; Pin #5
	DC $0dc000     ; Pin #6

	DC $1c8000     ; Pin #1, board #1
	DC $1cc000     ; Pin #2
	DC $1d0000     ; Pin #3
	DC $1d4000     ; Pin #4
	DC $1d8000     ; Pin #5
	DC $1dc000     ; Pin #6
END_ZERO_BIASES

; Initialization of clock driver and video processor DACs and switches
DACS	DC	END_DACS-DACS-1
	DC	$2A0080				; DAC = unbuffered mode
	DC	$200100+@CVI((CLK_HI/Vmax)*255)	; Pin #1, Reset
	DC	$200200+@CVI((CLK_LO/Vmax)*255)
	DC	$200400+@CVI((CLK_HI/Vmax)*255)	; Pin #2, Line
	DC	$200800+@CVI((CLK_LO/Vmax)*255)
	DC	$202000+@CVI((CLK_HI/Vmax)*255)	; Pin #3, Lsync
	DC	$204000+@CVI((CLK_LO/Vmax)*255)
	DC	$208000+@CVI((CLK_HI/Vmax)*255)	; Pin #4, Fsync
	DC	$210000+@CVI((CLK_LO/Vmax)*255)
	DC	$220100+@CVI((CLK_HI/Vmax)*255)	; Pin #5, Read
	DC	$220200+@CVI((CLK_LO/Vmax)*255)
	DC	$220400+@CVI((CLK_HI/Vmax)*255)	; Pin #6, Pixel
	DC	$220800+@CVI((CLK_LO/Vmax)*255)
	DC	$222000+@CVI((ZERO/Vmax)*255)	; Pin #7, Unused
	DC	$224000+@CVI((ZERO/Vmax)*255)
	DC	$228000+@CVI((ZERO/Vmax)*255)	; Pin #8, Unused
	DC	$230000+@CVI((ZERO/Vmax)*255)
	DC	$240100+@CVI((ZERO/Vmax)*255)	; Pin #9, Unused
	DC	$240200+@CVI((ZERO/Vmax)*255)
	DC	$240400+@CVI((ZERO/Vmax)*255)	; Pin #10, Unused
	DC	$240800+@CVI((ZERO/Vmax)*255)
	DC	$242000+@CVI((ZERO/Vmax)*255)	; Pin #11, Unused
	DC	$244000+@CVI((ZERO/Vmax)*255)
	DC	$248000+@CVI((ZERO/Vmax)*255)	; Pin #12, Unused
	DC	$250000+@CVI((ZERO/Vmax)*255)
	
	DC	$260100+@CVI((ZERO/Vmax)*255)	; Pin #13, Unused
	DC	$260200+@CVI((ZERO/Vmax)*255)
	DC	$260400+@CVI((ZERO/Vmax)*255)	; Pin #14, Unused
	DC	$260800+@CVI((ZERO/Vmax)*255)
	DC	$262000+@CVI((ZERO/Vmax)*255)	; Pin #15, Unused
	DC	$264000+@CVI((ZERO/Vmax)*255)
	DC	$268000+@CVI((ZERO/Vmax)*255)	; Pin #16, Unused
	DC	$270000+@CVI((ZERO/Vmax)*255)
	DC	$280100+@CVI((ZERO/Vmax)*255)	; Pin #17, Unused
	DC	$280200+@CVI((ZERO/Vmax)*255)
	DC	$280400+@CVI((ZERO/Vmax)*255)	; Pin #18, Unused
	DC	$280800+@CVI((ZERO/Vmax)*255)
	DC	$282000+@CVI((ZERO/Vmax)*255)	; Pin #19, Unused
	DC	$284000+@CVI((ZERO/Vmax)*255)
	DC	$288000+@CVI((ZERO/Vmax)*255)	; Pin #33, Unused
	DC	$290000+@CVI((ZERO/Vmax)*255)
	DC	$2A0100+@CVI((ZERO/Vmax)*255)	; Pin #34, Unused
	DC	$2A0200+@CVI((ZERO/Vmax)*255)
	DC	$2A0400+@CVI((ZERO/Vmax)*255)	; Pin #35, Unused
	DC	$2A0800+@CVI((ZERO/Vmax)*255)
	DC	$2A2000+@CVI((ZERO/Vmax)*255)	; Pin #36, Unused
	DC	$2A4000+@CVI((ZERO/Vmax)*255)
	DC	$2A8000+@CVI((ZERO/Vmax)*255)	; Pin #37, Unused
	DC	$2B0000+@CVI((ZERO/Vmax)*255)
END_DACS

; Define the switch state bits for the first group of 12 clocks = CLK2
H_RESET	EQU	1	; Pin #1
L_RESET	EQU	0
H_LINE	EQU	2	; Pin #2
L_LINE	EQU	0
H_LSYNC	EQU	4	; Pin #3
L_LSYNC	EQU	0
H_FSYNC	EQU	8	; Pin #4
L_FSYNC	EQU	0
H_READ 	EQU	$10	; Pin #5
L_READ 	EQU	0
H_PIXEL EQU	$20	; Pin #6
L_PIXEL EQU	0

; Symbolic definitions
;	DC	CLK2+DELAY+L_FSYNC+L_PIXEL+L_LSYNC+L_LINE+L_READ+H_RESET

; Turn READ ON for readout and reset
READ_ON
	DC	END_READ_ON-READ_ON-1
	DC	CLK2+H_FSYNC+H_LSYNC+L_PIXEL+L_LINE+H_READ+H_RESET
	DC	CLK2+H_FSYNC+H_LSYNC+L_PIXEL+L_LINE+H_READ+H_RESET
END_READ_ON

; Turn READ OFF during exposure
READ_OFF
	DC	END_READ_OFF-READ_OFF-1
	DC	CLK2+H_FSYNC+L_PIXEL+H_LSYNC+L_LINE+L_READ+H_RESET
	DC	CLK2+H_FSYNC+L_PIXEL+H_LSYNC+L_LINE+L_READ+H_RESET
END_READ_OFF

FRAME_INIT 
	DC	END_FRAME_INIT-FRAME_INIT-1
	DC	CLK2+S_DELAY+L_FSYNC+H_LSYNC+L_PIXEL+L_LINE+H_READ+H_RESET
	DC	CLK2+S_DELAY+L_FSYNC+L_LSYNC+L_PIXEL+L_LINE+H_READ+H_RESET
	DC	CLK2+0000000+H_FSYNC+L_LSYNC+L_PIXEL+L_LINE+H_READ+H_RESET
END_FRAME_INIT

SHIFT_RESET_ODD_ROW
	DC	END_SHIFT_RESET_ODD_ROW-SHIFT_RESET_ODD_ROW-1
	DC	CLK2+S_DELAY+H_FSYNC+L_LSYNC+L_PIXEL+L_LINE+H_READ+H_RESET
	DC	CLK2+S_DELAY+H_FSYNC+H_LSYNC+L_PIXEL+L_LINE+H_READ+H_RESET
	DC	CLK2+S_DELAY+H_FSYNC+H_LSYNC+L_PIXEL+H_LINE+H_READ+H_RESET
	DC	CLK2+S_DELAY+H_FSYNC+H_LSYNC+L_PIXEL+H_LINE+H_READ+L_RESET
	DC	CLK2+S_DELAY+H_FSYNC+H_LSYNC+L_PIXEL+H_LINE+H_READ+H_RESET
END_SHIFT_RESET_ODD_ROW

SHIFT_RESET_EVEN_ROW
	DC	END_SHIFT_RESET_EVEN_ROW-SHIFT_RESET_EVEN_ROW-1
	DC	CLK2+S_DELAY+H_FSYNC+L_LSYNC+L_PIXEL+H_LINE+H_READ+H_RESET
	DC	CLK2+S_DELAY+H_FSYNC+H_LSYNC+L_PIXEL+H_LINE+H_READ+H_RESET
	DC	CLK2+S_DELAY+H_FSYNC+H_LSYNC+L_PIXEL+L_LINE+H_READ+H_RESET
	DC	CLK2+S_DELAY+H_FSYNC+H_LSYNC+L_PIXEL+L_LINE+H_READ+L_RESET
	DC	CLK2+S_DELAY+H_FSYNC+H_LSYNC+L_PIXEL+L_LINE+H_READ+H_RESET
END_SHIFT_RESET_EVEN_ROW

SHIFT_EVEN_ROW
	DC	END_SHIFT_EVEN_ROW-SHIFT_EVEN_ROW-1
	DC	CLK2+S_DELAY+H_FSYNC+L_LSYNC+L_PIXEL+H_LINE+H_READ+H_RESET
	DC	CLK2+S_DELAY+H_FSYNC+L_LSYNC+L_PIXEL+H_LINE+H_READ+H_RESET
	DC	CLK2+S_DELAY+H_FSYNC+H_LSYNC+L_PIXEL+H_LINE+H_READ+H_RESET
	DC	CLK2+S_DELAY+H_FSYNC+H_LSYNC+L_PIXEL+L_LINE+H_READ+H_RESET
END_SHIFT_EVEN_ROW

SHIFT_ODD_ROW
	DC	END_SHIFT_ODD_ROW-SHIFT_ODD_ROW-1
	DC	CLK2+S_DELAY+H_FSYNC+L_LSYNC+L_PIXEL+L_LINE+H_READ+H_RESET
	DC	CLK2+S_DELAY+H_FSYNC+L_LSYNC+L_PIXEL+L_LINE+H_READ+H_RESET
	DC	CLK2+S_DELAY+H_FSYNC+H_LSYNC+L_PIXEL+L_LINE+H_READ+H_RESET
	DC	CLK2+S_DELAY+H_FSYNC+H_LSYNC+L_PIXEL+H_LINE+H_READ+H_RESET
END_SHIFT_ODD_ROW

READ_EVEN_ROW_PIXELS
	DC	END_READ_EVEN_ROW_PIXELS-READ_EVEN_ROW_PIXELS-1
	DC	CLK2+F_DELAY+H_READ+H_PIXEL+H_LSYNC+L_LINE+H_FSYNC+H_RESET
	DC	$400000		; A/D sample
	DC	$010033		; Start A/D conversion
	DC	SXMIT		; Series transmit four pixels' data
	DC	0		
	DC	CLK2+F_DELAY+H_READ+L_PIXEL+H_LSYNC+L_LINE+H_FSYNC+H_RESET
	DC	$400000		; A/D sample
	DC	$010033		; Start A/D conversion
	DC	SXMIT		; Series transmit four pixels' data
	DC	0		; Return SXMIT to zero
END_READ_EVEN_ROW_PIXELS

READ_ODD_ROW_PIXELS
	DC	END_READ_ODD_ROW_PIXELS-READ_ODD_ROW_PIXELS-1
	DC	CLK2+F_DELAY+H_READ+H_PIXEL+H_LSYNC+H_LINE+H_FSYNC+H_RESET
	DC	$400000		; A/D sample
	DC	$010033		; Start A/D conversion
	DC	SXMIT		; Series transmit four pixels' data
	DC	0		
	DC	CLK2+F_DELAY+H_READ+L_PIXEL+H_LSYNC+H_LINE+H_FSYNC+H_RESET
	DC	$400000		; A/D sample
	DC	$010033		; Start A/D conversion
	DC	SXMIT		; Series transmit four pixels' data
	DC	0		; Return SXMIT to zero
END_READ_ODD_ROW_PIXELS

SHIFT_EVEN_ROW_PIXELS
	DC	END_SHIFT_EVEN_ROW_PIXELS-SHIFT_EVEN_ROW_PIXELS-1
	DC	CLK2+F_DELAY+H_READ+H_PIXEL+H_LSYNC+L_LINE+H_FSYNC+H_RESET
	DC	$400000		; A/D sample
	DC	$010033		; Start A/D conversion
	DC	CLK2+F_DELAY+H_READ+L_PIXEL+H_LSYNC+L_LINE+H_FSYNC+H_RESET
	DC	$400000		; A/D sample
	DC	$010033		; Start A/D conversion
END_SHIFT_EVEN_ROW_PIXELS

SHIFT_ODD_ROW_PIXELS
	DC	END_SHIFT_ODD_ROW_PIXELS-SHIFT_ODD_ROW_PIXELS-1
	DC	CLK2+F_DELAY+H_READ+H_PIXEL+H_LSYNC+H_LINE+H_FSYNC+H_RESET
	DC	$400000		; A/D sample
	DC	$010033		; Start A/D conversion
	DC	CLK2+F_DELAY+H_READ+L_PIXEL+H_LSYNC+H_LINE+H_FSYNC+H_RESET
	DC	$400000		; A/D sample
	DC	$010033		; Start A/D conversion
END_SHIFT_ODD_ROW_PIXELS

SXMIT_EIGHT_PIXELS
	DC	END_SXMIT_EIGHT_PIXELS-SXMIT_EIGHT_PIXELS-1
	DC	F_DELAY+$000033
	DC	$100000		; A/D sample
	DC	$000033		; Start A/D conversion
SXMIT2	DC	SXMIT		; Series transmit four pixels' data
	DC	F_DELAY+$000033
	DC	$100000		; A/D sample
	DC	$000033		; Start A/D conversion
SXMIT3	DC	SXMIT		; Series transmit four pixels' data
	DC	0		; Return SXMIT to zero
END_SXMIT_EIGHT_PIXELS
