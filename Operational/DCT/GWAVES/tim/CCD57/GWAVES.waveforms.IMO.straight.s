; Waveform tables and definitions for the e2v CCD67 256 sq. frame 
; transfer CCD for GWAVES.  This uses the ARC22 timing, ARC32 clock
; driver and ARC47 4-channel video board.  
;
; This file is a modified version of the Gen II HIPO waveforms file.
; 

; CCD clock voltage definitions
VIDEO		EQU	$000000	; Video processor board select = 0
CLK2		EQU	$002000	; Clock driver board select = 2
CLK3		EQU	$003000	; Clock driver board select = 3 
CLKV		EQU	$200000	; Clock driver board DAC voltage selection address 
VID0		EQU	$000000	; Address of video board DACS
DAC_ADDR	EQU	$0E0000 ; DAC Channel Address
DAC_RegM	EQU	$0F4000 ; DAC m Register
DAC_RegC	EQU	$0F8000 ; DAC c Register
DAC_RegD	EQU	$0FC000 ; DAC X1 Register
Vmax		EQU	13.0	; Maximum clock driver voltage
ZERO		EQU	 0.0	; Unused pins

; INT_TIM, controlled by Makefile def'n INTTIM_SETTING
; as per Confluence July 1 end commentary
	IF	@SCP("INTTIM_SETTING","04")
; 04 setting, noted for its languid "04"-ness
INT_TIM		EQU	$040000
	ENDIF
	IF	@SCP("INTTIM_SETTING","02")
; 02 setting, noted for its bustling "02"-ness
INT_TIM		EQU	$020000
	ENDIF
	IF	@SCP("INTTIM_SETTING","08")
; 08 setting, noted for its lethargic "08"-ness
INT_TIM		EQU	$080000
	ENDIF
	IF	@SCP("INTTIM_SETTING","0C")
; 0C setting, noted for its molassasian "0C"-ness
INT_TIM		EQU	$0C0000
	ENDIF


;INT_TIM	EQU	$040000	; 0.85 us/px - use gain 4.75, experimental
;INT_TIM	EQU	$080000	; 1.0 us/px - use gain 4.75, doesn't clip
;INT_TIM	EQU	$080000	; 1.0 us/px - use gain 9.5, clips @ PRAM
;INT_TIM	EQU	$150000	; 1.5 us/px - use gain 9.5, clips @ ADC
;INT_TIM		EQU	$1D0000	; 1.8 us/px - use gain 4.75, best overall
;INT_TIM	EQU	$470000	; 3.5 us/px - use gain 2, slower & quieter
;INT_TIM	EQU	$920000	; 6.5 us/px - use gain 1, slower & quieter
;INT_TIM	EQU	$6D0000	; 5.0 us/px - use gain 2 or 4.75, clips @ ADC

;ADC_TIM		EQU	$0C0000	; Slow ADC TIME
ADC_TIM		EQU	$000000 ; Fast ADC TIME

; Delay numbers in clocking

; SI_DELAY, controlled by Makefile def'n SIDELAY_SETTING
; as per Confluence July 1 end commentary
	IF	@SCP("SIDELAY_SETTING","86")
; 86 setting, noted for its languid "86"-ness
SI_DELAY	EQU	$860000 ; Fast Storage/Image Delay
	ENDIF
	IF	@SCP("SIDELAY_SETTING","8C")
; 8C setting, noted for its languid "8C"-ness
SI_DELAY	EQU	$8C0000 ; Fast Storage/Image Delay
	ENDIF
	IF	@SCP("SIDELAY_SETTING","92")
; 8C setting, noted for its languid "92"-ness
SI_DELAY	EQU	$92 ; Fast Storage/Image Delay
	ENDIF
	IF	@SCP("SIDELAY_SETTING","9B")
; 8C setting, noted for its languid "9B"-ness
SI_DELAY	EQU	$9B ; Fast Storage/Image Delay
	ENDIF

;SI_DELAY 	EQU	$C00000	; Started with 0x36 Parallel clock delay
;SI_DELAY	EQU	$860000 ; Fast Storage/Image Delay
;SI_DELAY	EQU	$860000 ; Slower Storage/Image Delay

; R_DELAY, controlled by Makefile def'n RDELAY_SETTING
; as per Confluence July 1 end commentary
	IF	@SCP("RDELAY_SETTING","00")
; 00 setting, noted for its bustling "00"-ness
R_DELAY		EQU	$000000	; Fast serial regisiter transfer delay
	ENDIF

;R_DELAY		EQU	$080000	; Serial register transfer delay
;R_DELAY		EQU	$000000	; Fast serial regisiter transfer delay


SKIP_DELAY 	EQU	$000000	; Serial register skipping delay


; bitwise symbols for integrator manipulation from LMI waveforms file.
; Video processor bit definition
;             6     5    4     3      2        1         0
;            xfer, A/D, integ, Pol-, fixed 0, DCrestore, rst (1 => switch open)
; for the ARC-47 1C (incl. all of gen-ii) it was
;            xfer, A/D, integ, Pol+, Pol-,    DCrestore, rst (1 => switch open)

; goes with VIDEO
INT_INIT        EQU     %1111000        ; Change nearly everything
; goes with VIDEO
INT_RSTOFF      EQU     %1111011        ; Stop resetting integrator
; goes with VIDEO and INT_TIM
INT_MINUS       EQU     %0001011        ; Integrate reset level
; goes with VIDEO
INT_STOP        EQU     %0010011        ; Stop Integrate
; goes with VIDEO and INT_TIM
INT_PLUS        EQU     %0000011        ; Integrate signal level
; goes with VIDEO and ADC_TIM
INT_SMPL        EQU     %0010011        ; Stop integrate, A/D is sampling
; goes with VIDEO
INT_DCR         EQU     %0010000        ; Reset integ. and DC restore

; Clock voltages in volts 
RG_HI	EQU	+3.0	; Reset
RG_LO	EQU	-9.0	; 
R_HI	EQU	+1.0	; Serials
R_LO	EQU	-8.0	; 
SI_HI	EQU	+3.0	; Parallels
SI_LO	EQU -9.0	;
DG_HI	EQU	+3.0	; Dump Gate
DG_LO	EQU	-9.0	;

; DC Bias voltages in volts		
	IF	@SCP("VODSETTING","21.0")
VOD	EQU	21.0	; Output Drain
	ENDIF
	IF	@SCP("VODSETTING","20.0")
VOD	EQU	20.0	; Output Drain
	ENDIF
	IF	@SCP("VODSETTING","19.0")
VOD	EQU	19.0	; Output Drain
	ENDIF
VRD	EQU	 9.00	; Reset Drain
VOG	EQU	-6.0	; Output Gate
VABG	EQU	-6.0	; Anti-blooming gate
VDD	EQU	19.0	; Dump Drain - xxx Not used, keep as placeholder
PWR	EQU	+6.0	; Preamp power - xxx Not used, keep as placeholder

OFFSET	EQU	$2E00	; xxx These need to be tweaked
;OFFSET0	EQU	$2E00	; Left Side Of Frame
;OFFSET1	EQU	$2E00	; Right Side Of Frame  
OFFSET0	EQU	$1F00	; Left Side Of Frame
OFFSET1	EQU	$1E00	; Right Side Of Frame  
OFFSET2	EQU	OFFSET	; Channels 2 and 3 not used
OFFSET3	EQU	OFFSET

; Define switch state bits for the lower CCD clock driver bank CLK2
;XXX	EQU	1	; Unused, Pin 1 - clock 0
;XXX	EQU	2	; Unused, Pin 2 - clock 1
RGL	EQU	4	; Reset Gate Left, Pin 3 - clock 2
H3L	EQU	8	; Serial #3 Left, Pin 4 - clock 3
H2L	EQU	$10	; Serial #2 Left, Pin 5 - clock 4
H1L	EQU	$20	; Serial #1 Left, Pin 6 - clock 5
;XXX	EQU	$40	; Unused, Pin 7 - clock 6
;XXX	EQU	$80	; Unused, Pin 8 - clock 7
H1R	EQU	$100	; Serial #1 Right, Pin 9 - clock 8
H2R	EQU	$200	; Serial #2 Right, Pin 10 - clock 9
H3R	EQU	$400	; Serial #3 Right, Pin 11 - clock 10
RGR	EQU	$800	; Reset Gate Right, Pin 12 - clock 11

; Define switch state bits for the upper CCD clock driver bank CLK3
I1	EQU	1	; Image, phase #1, Pin 13 - clock 12
I2	EQU	2	; Image, phase #2, Pin 14 - clock 13
I3	EQU	4	; Image, phase #3, Pin 15 - clock 14
;XX	EQU	8	; Unused, Pin 16 - clock 15
DG	EQU	$10	; Dump Gate, Pin 17 - clock 16
;XX	EQU	$20	; Unused, Pin 18 - clock 17
;XX	EQU	$40	; Unused, Pin 19 - clock 18
;XX	EQU	$80	; Unused, Pin 33 - clock 19
S3	EQU	$100	; Storage, phase #3, Pin 34 - clock 20
S2	EQU	$200	; Storage, phase #2, Pin 35 - clock 21
S1	EQU	$400	; Storage, phase #1, Pin 36 - clock 22
;XX	EQU	$800	; Unused, Pin 37 - clock 23

;  ***  Definitions for Y: memory waveform tables  *****
; Clock only the Storage clocks : S1->S2->S3
S_PARALLEL
	DC	END_S_PARALLEL-S_PARALLEL-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore
	DC	CLK2+00000000+RGL+RGR+H1L+H1R+H2L+H2R+000+000
;	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00	; Probably not needed
	DC	CLK3+SI_DELAY+I1+00+00+S1+S2+00
	DC	CLK3+SI_DELAY+I1+00+00+00+S2+00
	DC	CLK3+SI_DELAY+I1+00+00+00+S2+S3
	DC	CLK3+SI_DELAY+I1+00+00+00+00+S3
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+S3
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00
	DC	CLK3+SI_DELAY+00+00+00+00+00+00	; IMO line
END_S_PARALLEL

; Reverse clock only the Storage clocks : S1->S3->S2->S1
; Use in pipelined occultation mode
R_S_PARALLEL
	DC	END_R_S_PARALLEL-R_S_PARALLEL-1
	DC	CLK2+00000000+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+S3
	DC	CLK3+SI_DELAY+I1+00+00+00+00+S3
	DC	CLK3+SI_DELAY+I1+00+00+00+S2+S3
	DC	CLK3+SI_DELAY+I1+00+00+00+S2+00
	DC	CLK3+SI_DELAY+I1+00+00+S1+S2+00
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00
;	DC	CLK3+SI_DELAY+00+00+00+00+00+00	; IMO line
END_R_S_PARALLEL

; Clock only the Storage clocks : S1->S2->S3 with DG
S_CLEAR
	DC	END_S_CLEAR-S_CLEAR-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore
	DC	CLK2+00000000+RGL+RGR+H1L+H1R+H2L+H2R+000+000
;	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00	; Probably not needed
	DC	CLK3+SI_DELAY+I1+00+00+S1+S2+00+DG
	DC	CLK3+SI_DELAY+I1+00+00+00+S2+00+DG
	DC	CLK3+SI_DELAY+I1+00+00+00+S2+S3+DG
	DC	CLK3+SI_DELAY+I1+00+00+00+00+S3+DG
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+S3+DG
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00+DG
;	DC	CLK3+SI_DELAY+00+00+00+00+00+00	; IMO line
END_S_CLEAR	
; 2 microsecond delay before readout starts may be needed here
;	DC	CLK3+$600000+I1+00+00+S1+00+0000

; Clock both the Storage and Image clocks : I1->I2->I3 and S1->S2->S3
IS_PARALLEL
	DC	END_IS_PARALLEL-IS_PARALLEL-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore
	DC	CLK2+00000000+RGL+RGR+H1L+H1R+H2L+H2R+000+000
;	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00	; Probably not needed
	DC	CLK3+SI_DELAY+I1+I2+00+S1+S2+00
	DC	CLK3+SI_DELAY+00+I2+00+00+S2+00
	DC	CLK3+SI_DELAY+00+I2+I3+00+S2+S3
	DC	CLK3+SI_DELAY+00+00+I3+00+00+S3
	DC	CLK3+SI_DELAY+I1+00+I3+S1+00+S3
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00
	DC	CLK3+SI_DELAY+00+00+00+00+00+00	; IMO line
END_IS_PARALLEL

; Clock both the Storage and Image clocks : I1->I2->I3 and S1->S2->S3
IS_CLEAR
	DC	IS_CLEAR_END-IS_CLEAR-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore
	DC	CLK2+00000000+RGL+RGR+H1L+H1R+H2L+H2R+000+000
;	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00+00 ; Probably not needed
	DC	CLK3+SI_DELAY+I1+I2+00+S1+S2+00+DG
	DC	CLK3+SI_DELAY+00+I2+00+00+S2+00+DG
	DC	CLK3+SI_DELAY+00+I2+I3+00+S2+S3+DG
 	DC	CLK3+SI_DELAY+00+00+I3+00+00+S3+DG
 	DC	CLK3+SI_DELAY+I1+00+I3+S1+00+S3+DG
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00+DG
;	DC	CLK3+SI_DELAY+00+00+00+00+00+00	; IMO line
IS_CLEAR_END

; Special IMO waveform for long initial clock after integration
; Initial IMO clock duration is 142.8 microseconds.
IMO_FIRST_CLOCK
	DC	IMO_FIRST_CLOCK_END-IMO_FIRST_CLOCK-1
	DC	CLK3+$FF0000+I1+00+00+S1+00+00	; Max delay, 20.4 us, IMO
	DC	CLK3+$FF0000+I1+00+00+S1+00+00	; Max delay, 20.4 us, IMO
	DC	CLK3+$FF0000+I1+00+00+S1+00+00	; Max delay, 20.4 us, IMO
	DC	CLK3+$FF0000+I1+00+00+S1+00+00	; Max delay, 20.4 us, IMO
	DC	CLK3+$FF0000+I1+00+00+S1+00+00	; Max delay, 20.4 us, IMO
	DC	CLK3+$FF0000+I1+00+00+S1+00+00	; Max delay, 20.4 us, IMO
	DC	CLK3+$FF0000+I1+00+00+S1+00+00	; Max delay, 20.4 us, IMO
IMO_FIRST_CLOCK_END

IMO_LAST_CLOCK
        DC      IMO_LAST_CLOCK_END-IMO_LAST_CLOCK-1
	DC	CLK3+SI_DELAY+00+00+00+00+00+00	; IMO line
IMO_LAST_CLOCK_END

DCRST_LAST
        DC      DCRST_LAST_END-DCRST_LAST-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore
DCRST_LAST_END

DUMP_SERIAL
	DC	END_DUMP_SERIAL-DUMP_SERIAL-1
	DC	CLK2+SI_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00+DG
	DC	CLK2+SI_DELAY+RGL+RGR+000+000+000+000+000+000
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00+00
	DC	CLK2+SI_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
END_DUMP_SERIAL
	COMMENT	*
; Michigan AIMO clocking - this is vestigial and commented out
PARALLEL DC	PARALLEL_CLEAR-PARALLEL-1
	DC	CLK2+$000000+RGL+RGR+H1L+H1R+H2L+H2R+00+000+000+00
	DC	CLK3+P_DELAY+00+00+I3
	DC	CLK3+P_DELAY+00+00+I3
	DC	CLK3+P_DELAY+I1+00+I3
	DC	CLK3+P_DELAY+I1+00+00
	DC	CLK3+P_DELAY+I1+I2+00
	DC	CLK3+P_DELAY+00+I2+00
	DC	CLK3+P_DELAY+00+I2+I3
	DC	CLK3+P_DELAY+00+00+I3
	DC	CLK3+P_DELAY+00+00+I3
	DC	CLK3+P_DELAY+00+00+00
	*

; For serial clocking we know that the serial registers are laid out as
; follows for a backside part per communication with Paul Jorden:	

;	   Right Side		    Left Side
;	OG  3  2  1  3 .........  3  2  1  3  OG

; Left amp is   2 -> 1 -> 3
; Right amp is  1 -> 2 -> 3
	
; For a frontside part the left and right are reversed.
; Parallel phase 3 dumps into serial 1 and 2.

; Between serial clock code lumps the serials are left as follows:
; LEFT	Phase 2 L and R both high
; RIGHT	Phase 1 L and R both high
; SPLIT	H1R and H2L are high

; Video processor bit definition
;	     xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)

SERIAL_IDLE				; Split serial
	DC	END_SERIAL_IDLE-SERIAL_IDLE-1
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+$030000+000+000+000+H1R+H2L+000+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+$000000+INT_SMPL	; Stop integrate, A/D is sampling
; Not needed, so comment out
;	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
END_SERIAL_IDLE

; The following waveforms are for binned operation.  This is tricky with the
; CCD47 because it doesn't have a summing well.  The reset level integration
; has to happen before serial 3 drops for the first time and the data level
; integration has to happen after it drops for the last time.  The initial
; clocks go through the reset integration, the serial clocks are the 
; intervening clocks for additional pixels binned with the first one, and
; the video process is left to do the last clock and data integration.

	IF	@SCP("ENABLESPLITS","ON")
INITIAL_CLOCK_SPLIT                ; Both amplifiers
	DC      END_INITIAL_CLOCK_SPLIT-INITIAL_CLOCK_SPLIT-1
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
;	DC	$00F020			; Transmit A/D data to host
	DC	$00F040			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
END_INITIAL_CLOCK_SPLIT
	ENDIF

INITIAL_CLOCK_RIGHT         ; Serial right, Swap S1L and S2L
	DC      END_INITIAL_CLOCK_RIGHT-INITIAL_CLOCK_RIGHT-1
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
;	DC	$00F021			; Transmit A/D data to host
	DC	$00F041			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
END_INITIAL_CLOCK_RIGHT

INITIAL_CLOCK_LEFT ; Serial left, Swap S1R and S2R
	DC      END_INITIAL_CLOCK_LEFT-INITIAL_CLOCK_LEFT-1
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
END_INITIAL_CLOCK_LEFT
        
	IF	@SCP("ENABLESPLITS","ON")
SERIAL_CLOCK_SPLIT                ; Both amplifiers
	DC      END_SERIAL_CLOCK_SPLIT-SERIAL_CLOCK_SPLIT-1
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
END_SERIAL_CLOCK_SPLIT
	ENDIF

SERIAL_CLOCK_RIGHT         ; Serial right, Swap S1L and S2L
	DC      END_SERIAL_CLOCK_RIGHT-SERIAL_CLOCK_RIGHT-1
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
END_SERIAL_CLOCK_RIGHT

SERIAL_CLOCK_LEFT ; Serial left, Swap S1R and S2R
	DC      END_SERIAL_CLOCK_LEFT-SERIAL_CLOCK_LEFT-1
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
END_SERIAL_CLOCK_LEFT
        
VIDEO_PROCESS   
        DC      END_VIDEO_PROCESS-VIDEO_PROCESS-1
CCLK_1  ; The following line is overwritten by timmisc.s
	DC	CLK2+$030000+000+000+H1L+H1R+000+000+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+$000000+INT_SMPL	; Stop integrate, A/D is sampling
CCLK_2  ; The following line is overwritten by timmisc.s, but is correct as is.
; Actually it shouldn't be needed so comment it out.
;	DC      CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000
END_VIDEO_PROCESS

; Starting Y: address of circular waveforms for no-overhead access
STRT_CIR EQU	$C0
;ROM_DISP	EQU	APL_NUM*N_W_APL+APL_LEN+MISC_LEN+COM_LEN+STRT_CIR
;DAC_DISP	EQU	APL_NUM*N_W_APL+APL_LEN+MISC_LEN+COM_LEN+$100

; Check for Y: data memory overflow
	IF	@CVS(N,*)>STRT_CIR
	WARN    'Application Y: data memory is too large!' ; Make sure Y:
	ENDIF						   ;  will not overflow

; The fast serial code with the circulating address register must start 
;   on a boundary that is a multiple of the address register modulus.

	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR,Y:STRT_CIR			; Download address
;	ELSE
;	ORG     Y:STRT_CIR,P:ROM_DISP
	ENDIF

; This is an area to copy in the serial fast binned waveforms from high Y memory
; It is 0x28 = 40 locations long, enough to put in a binned-by-five waveform
;	     xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+000+000+H2L+H2R+H3L+H3R
SXMIT
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+$030000+000+000+000+000+H2L+H2R+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL

; Serial clocking waveform for skipping
	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR+$28,Y:STRT_CIR+$28		; Download address
;	ELSE
;	ORG     Y:STRT_CIR+$28,P:ROM_DISP+$28
	ENDIF

; There are three serial skip waveforms that must all be the same length
SERIAL_SKIP_LEFT
;	DC	END_SERIAL_SKIP_LEFT-SERIAL_SKIP_LEFT-1
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
END_SERIAL_SKIP_LEFT

	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR+$30,Y:STRT_CIR+$30		; Download address
;	ELSE
;	ORG     Y:STRT_CIR+$30,P:ROM_DISP+$30
	ENDIF

SERIAL_SKIP_RIGHT
;	DC	END_SERIAL_SKIP_RIGHT-SERIAL_SKIP_RIGHT-1
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
END_SERIAL_SKIP_RIGHT

	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR+$38,Y:STRT_CIR+$38		; Download address
;	ELSE
;	ORG     Y:STRT_CIR+$38,P:ROM_DISP+$38
	ENDIF

	IF	@SCP("ENABLESPLITS","ON")
SERIAL_SKIP_SPLIT
;	DC	END_SERIAL_SKIP_SPLIT-SERIAL_SKIP_SPLIT-1
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
END_SERIAL_SKIP_SPLIT
	ENDIF

; Put all the following code in SRAM.
	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:$100,Y:$100				; Download address
;	ELSE
;	ORG	Y:$100,P:DAC_DISP
	ENDIF

; Initialization of clock driver and video processor DACs and switches
; This is for the ARC 47 4-channel video board
DACS	DC	END_DACS-DACS-1
	DC	CLKV+$0A0080					; DAC = unbuffered mode
	DC	CLKV+$000100+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #1, Unused
	DC	CLKV+$000200+@CVI((ZERO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$000400+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #2, Unused
	DC	CLKV+$000800+@CVI((ZERO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$002000+@CVI((RG_HI+Vmax)/(2*Vmax)*255)	; Pin #3, RG Left
	DC	CLKV+$004000+@CVI((RG_LO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$008000+@CVI((R_HI+Vmax)/(2*Vmax)*255)	; Pin #4, S3 Left
	DC	CLKV+$010000+@CVI((R_LO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$020100+@CVI((R_HI+Vmax)/(2*Vmax)*255)	; Pin #5, S2 Left
	DC	CLKV+$020200+@CVI((R_LO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$020400+@CVI((R_HI+Vmax)/(2*Vmax)*255)	; Pin #6, S1 Left
	DC	CLKV+$020800+@CVI((R_LO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$022000+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #7, Unused
	DC	CLKV+$024000+@CVI((ZERO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$028000+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #8, Unused
	DC	CLKV+$030000+@CVI((ZERO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$040100+@CVI((R_HI+Vmax)/(2*Vmax)*255)	; Pin #9, S1 Right
	DC	CLKV+$040200+@CVI((R_LO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$040400+@CVI((R_HI+Vmax)/(2*Vmax)*255)	; Pin #10, S2 Right
	DC	CLKV+$040800+@CVI((R_LO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$042000+@CVI((R_HI+Vmax)/(2*Vmax)*255)	; Pin #11, S3 Right
	DC	CLKV+$044000+@CVI((R_LO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$048000+@CVI((RG_HI+Vmax)/(2*Vmax)*255)	; Pin #12, RG Right
	DC	CLKV+$050000+@CVI((RG_LO+Vmax)/(2*Vmax)*255)

	DC	CLKV+$060100+@CVI((SI_HI+Vmax)/(2*Vmax)*255)	; Pin #13, I1
	DC	CLKV+$060200+@CVI((SI_LO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$060400+@CVI((SI_HI+Vmax)/(2*Vmax)*255)	; Pin #14, I2
	DC	CLKV+$060800+@CVI((SI_LO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$062000+@CVI((SI_HI+Vmax)/(2*Vmax)*255)	; Pin #15, I3
	DC	CLKV+$064000+@CVI((SI_LO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$068000+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #16, Unused
	DC	CLKV+$070000+@CVI((ZERO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$080100+@CVI((DG_HI+Vmax)/(2*Vmax)*255)	; Pin #17, DG
	DC	CLKV+$080200+@CVI((DG_LO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$080400+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #18, Unused
	DC	CLKV+$080800+@CVI((ZERO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$082000+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #19, Unused
	DC	CLKV+$084000+@CVI((ZERO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$088000+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #33, Unused
	DC	CLKV+$090000+@CVI((ZERO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A0100+@CVI((SI_HI+Vmax)/(2*Vmax)*255)	; Pin #34, S3
	DC	CLKV+$0A0200+@CVI((SI_LO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A0400+@CVI((SI_HI+Vmax)/(2*Vmax)*255)	; Pin #35, S2
	DC	CLKV+$0A0800+@CVI((SI_LO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A2000+@CVI((SI_HI+Vmax)/(2*Vmax)*255)	; Pin #36, S1
	DC	CLKV+$0A4000+@CVI((SI_LO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A8000+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #37, Unused
	DC	CLKV+$0B0000+@CVI((ZERO+Vmax)/(2*Vmax)*255)
	
; Commands for the ARC-47 video board 
	DC	VID0+$0C0000		; Normal Image data D17-D2

; Gain : $0D000g, g = 0 to %1111, Gain = 4.75 to 1.0 in steps of 0.25
; xxx I don't understand this PRAM arrangement.
;	DC	VID0+$0D000F
	DC	VID0+$0D0000	; fix for arc-47 gen-iii default gain 1
	DC	VID0+$0C0180	; integrator parameter for 0.5 us
	
VOD_MAX	EQU	30.45
VRD_MAX	EQU	19.90
VOG_MAX	EQU	8.70
DAC_VOD	EQU	@CVI((VOD/VOD_MAX)*16384-1)		; Unipolar
DAC_VRD	EQU	@CVI((VRD/VRD_MAX)*16384-1)		; Unipolar
DAC_VOG	EQU	@CVI(((VOG+VOG_MAX)/VOG_MAX)*8192-1)	; Bipolar
DAC_VABG	EQU	@CVI(((VABG+VOG_MAX)/VOG_MAX)*8192-1)	; Bipolar
DAC_VDD	EQU	@CVI((VDD/VOD_MAX)*16384-1)		; Unipolar
DAC_PWR	EQU	@CVI(((PWR+VOG_MAX)/VOG_MAX)*8192-1)	; Bipolar
DAC_ZERO EQU	$1FFF					; Bipolar

; Initialize the ARC-47 DAC For DC_BIAS
; xxx These need to be revisited with Rich - which is which?
	DC	VID0+DAC_ADDR+$000000		; Vod0, pin 52
	DC	VID0+DAC_RegD+DAC_VOD
	DC	VID0+DAC_ADDR+$000004		; Vrd0, pin 13
	DC	VID0+DAC_RegD+DAC_VRD	
	DC	VID0+DAC_ADDR+$000008		; Vog0, pin 29
	DC	VID0+DAC_RegD+DAC_VOG		
	DC	VID0+DAC_ADDR+$00000C		; Vabg, pin 5, NC
	DC	VID0+DAC_RegD+DAC_ZERO

	DC	VID0+DAC_ADDR+$000001		; Vod1, pin 32
	DC	VID0+DAC_RegD+DAC_VOD
	DC	VID0+DAC_ADDR+$000005		; Vrd1, pin 55
	DC	VID0+DAC_RegD+DAC_VRD	
	DC	VID0+DAC_ADDR+$000009		; Vabg, pin 8
	DC	VID0+DAC_RegD+DAC_VABG		
	DC	VID0+DAC_ADDR+$00000D		; Vrsv1, pin 47, NC
	DC	VID0+DAC_RegD+DAC_ZERO

	DC	VID0+DAC_ADDR+$000002		; Vod2, pin 11
	DC	VID0+DAC_RegD+DAC_VOD
	DC	VID0+DAC_ADDR+$000006		; Vrd2, pin 35
	DC	VID0+DAC_RegD+0	
	DC	VID0+DAC_ADDR+$00000A		; Vog2, pin 50
	DC	VID0+DAC_RegD+DAC_VOG		
	DC	VID0+DAC_ADDR+$00000E		; Vrsv2, pin 27
	DC	VID0+DAC_RegD+DAC_ZERO
	
	DC	VID0+DAC_ADDR+$000003		; Vod3, pin 53
	DC	VID0+DAC_RegD+DAC_VOD
	DC	VID0+DAC_ADDR+$000007		; Vrd3, pin 14
	DC	VID0+DAC_RegD+0	
	DC	VID0+DAC_ADDR+$00000B		; Vog3, pin 30
	DC	VID0+DAC_RegD+DAC_VOG	
	DC	VID0+DAC_ADDR+$00000F		; Vrsv3, pin 6
	DC	VID0+DAC_RegD+DAC_ZERO
		
	DC	VID0+DAC_ADDR+$000010		; Vod4, pin 33
	DC	VID0+DAC_RegD+DAC_VDD
	DC	VID0+DAC_ADDR+$000011		; Vrd4, pin 56
	DC	VID0+DAC_RegD+DAC_PWR	
	DC	VID0+DAC_ADDR+$000012		; Vog4, pin 9
	DC	VID0+DAC_RegD+DAC_ZERO	
	DC	VID0+DAC_ADDR+$000013		; Vrsv4,pin 48
	DC	VID0+DAC_RegD+DAC_ZERO

; Initialize the ARC-47 DAC For Video Offsets
	DC	VID0+DAC_ADDR+$000014
	DC	VID0+DAC_RegD+OFFSET0
	DC	VID0+DAC_ADDR+$000015
	DC	VID0+DAC_RegD+OFFSET1
	DC	VID0+DAC_ADDR+$000016
	DC	VID0+DAC_RegD+OFFSET2
	DC	VID0+DAC_ADDR+$000017
	DC	VID0+DAC_RegD+OFFSET3

END_DACS

;	These are the 15 fast serial read waveforms for left, right, 
;	and split reads for serial binning factors from 1 to 5.

;	Unbinned waveforms
;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_LEFT_1
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+000+000+H2L+H2R+H3L+H3R
SXMIT_LEFT_1
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+$000000+INT_STOP	; Stop integrating
	DC	CLK2+$030000+000+000+000+000+H2L+H2R+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_LEFT_1

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_RIGHT_1
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+H1L+H1R+000+000+H3L+H3R
SXMIT_RIGHT_1
;	DC	$00F021			; Transmit A/D data to host
	DC	$00F041			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+$030000+000+000+H1L+H1R+000+000+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+$000000+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_RIGHT_1

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_SPLIT_1
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
SXMIT_SPLIT_1
;	DC	$00F020			; Transmit A/D data to host
	DC	$00F040			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+$030000+000+000+000+H1R+H2L+000+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+$000000+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_SPLIT_1

; Bin by 2 waveforms
;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_LEFT_2
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+000+000+H2L+H2R+H3L+H3R
SXMIT_LEFT_2
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+$030000+000+000+000+000+H2L+H2R+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_LEFT_2

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_RIGHT_2
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+H1L+H1R+000+000+H3L+H3R
SXMIT_RIGHT_2
;	DC	$00F021			; Transmit A/D data to host
	DC	$00F041			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+$030000+000+000+H1L+H1R+000+000+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+$000000+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_RIGHT_2

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_SPLIT_2
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
SXMIT_SPLIT_2
;	DC	$00F020			; Transmit A/D data to host
	DC	$00F040			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	CLK2+$030000+000+000+000+H1R+H2L+000+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+$000000+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_SPLIT_2


;	Binned by 3 waveforms
;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_LEFT_3
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+000+000+H2L+H2R+H3L+H3R
SXMIT_LEFT_3
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+$030000+000+000+000+000+H2L+H2R+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_LEFT_3

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_RIGHT_3
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+H1L+H1R+000+000+H3L+H3R
SXMIT_RIGHT_3
;	DC	$00F021			; Transmit A/D data to host
	DC	$00F041			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+$030000+000+000+H1L+H1R+000+000+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+$000000+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_RIGHT_3

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_SPLIT_3
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
SXMIT_SPLIT_3
;	DC	$00F020			; Transmit A/D data to host
	DC	$00F040			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	CLK2+$030000+000+000+000+H1R+H2L+000+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+$000000+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_SPLIT_3

;	Binned by 4 waveforms
;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_LEFT_4
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+000+000+H2L+H2R+H3L+H3R
SXMIT_LEFT_4
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+$030000+000+000+000+000+H2L+H2R+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_LEFT_4

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_RIGHT_4
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+H1L+H1R+000+000+H3L+H3R
SXMIT_RIGHT_4
;	DC	$00F021			; Transmit A/D data to host
	DC	$00F041			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+$030000+000+000+H1L+H1R+000+000+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+$000000+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_RIGHT_4

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_SPLIT_4
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
SXMIT_SPLIT_4
;	DC	$00F020			; Transmit A/D data to host
	DC	$00F040			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	CLK2+$030000+000+000+000+H1R+H2L+000+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+$000000+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_SPLIT_4

;	Binned by 5 waveforms
;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_LEFT_5
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+000+000+H2L+H2R+H3L+H3R
SXMIT_LEFT_5
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+$030000+000+000+000+000+H2L+H2R+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_LEFT_5

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_RIGHT_5
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+H1L+H1R+000+000+H3L+H3R
SXMIT_RIGHT_5
;	DC	$00F021			; Transmit A/D data to host
	DC	$00F041			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+$030000+000+000+H1L+H1R+000+000+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+$000000+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_RIGHT_5

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_SPLIT_5
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+INT_INIT	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
SXMIT_SPLIT_5
;	DC	$00F020			; Transmit A/D data to host
	DC	$00F040			; Transmit A/D data to host
	DC	VIDEO+$000000+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+$000000+INT_STOP	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	CLK2+$030000+000+000+000+H1R+H2L+000+000+000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+$000000+INT_SMPL	; Stop integrate, A/D is sampling
END_SERIAL_READ_SPLIT_5

; this small table is for writing the 2 dacs to control 
; the GWAVES SH and retro leds.
; The values will be filled in via VRD2_V and VRD3_V
SET_VRD2_3
        DC	ENDSET_VRD2_3-SET_VRD2_3-1
	DC	VID0+DAC_ADDR+$000006		; Vrd2, pin 35
VRD2_V	DC	VID0+DAC_RegD+0	
	DC	VID0+DAC_ADDR+$000007		; Vrd3, pin 14
VRD3_V	DC	VID0+DAC_RegD+0	
ENDSET_VRD2_3



