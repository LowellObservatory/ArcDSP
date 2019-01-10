; Waveform tables and definitions for the e2v CCD231 6K sq. frame 
; transfer CCD for LMI.

; CCD clock voltage definitions
VIDEO		EQU	$000000	; Video processor board select = 0
CLK2		EQU	$002000	; Clock driver board select = 2
CLK3		EQU	$003000	; Clock driver board select = 3 
CLKV            EQU     $200000 ; Clock driver board DAC voltage selection address 
VID0            EQU     $000000 ; Address of video board DACS
DAC_ADDR        EQU     $0E0000 ; DAC Channel Address
DAC_RegM        EQU     $0F4000 ; DAC m Register
DAC_RegC        EQU     $0F8000 ; DAC c Register
DAC_RegD        EQU     $0FC000 ; DAC X1 Register
Vmax            EQU     13.0    ; Maximum clock driver voltage
ZERO            EQU      0.0    ; Unused pins


; For NASA42 we uncommented one of these lines at a time
;INT_TIM	EQU	$080000	; 1.0 us/px - use gain 9.5, clips at PRAM
;INT_TIM	EQU	$130000	; 1.4 us/px - use gain 4.75, clips at PRAM
;INT_TIM		EQU	$1D0000	; 1.8 us/px - use gain 2
;INT_TIM	EQU	$2D0000	; 2.5 us/px - use gain 2, doesn't clip
;INT_TIM	EQU	$600000	; 4.7 us/px - use gain 1; Doesn't clip

; INT_TIM, controlled by Makefile def'n INTTIM_SETTING
; as per Confluence July 1 2010 end commentary

        IF      @SCP("INTTIM_SETTING","08")
; on nasa42, 1.0 us/pxl- using gain 9.5, clips at PRAM
INT_TIM         EQU     $080000
        ENDIF
        IF      @SCP("INTTIM_SETTING","13")
; on nasa42, 1.4 us/pxl- using gain 4.75, clips at PRAM
INT_TIM         EQU     $130000
        ENDIF
        IF      @SCP("INTTIM_SETTING","1D")
; on nasa42, 1.8 us/pxl- use gain 2
; this is in production at the 42"
INT_TIM         EQU     $1D0000
        ENDIF
        IF      @SCP("INTTIM_SETTING","2D")
; on nasa42, 2.5 us/pxl- use gain 2, doesn't clip
INT_TIM         EQU     $2D0000
        ENDIF
        IF      @SCP("INTTIM_SETTING","E")
; on limi, 2.5 us/pxl
INT_TIM         EQU     $0E0000
        ENDIF
        IF      @SCP("INTTIM_SETTING","60")
; on nasa42, 4.7 us/pxl- use gain 1, doesn't clip
INT_TIM         EQU     $600000
        ENDIF



;ADC_TIM		EQU	$0C0000	; Slow ADC TIME
ADC_TIM		EQU	$000000 ; Fast ADC TIME


; Delay numbers in clocking
;SI_DELAY	EQU	$A70000 ; 25 microsecond parallel delay time

; SI_DELAY, controlled by Makefile def'n SIDELAY_SETTING
; as per Confluence July 1 2010 end commentary
        IF      @SCP("SIDELAY_SETTING","BF")
; 10 us parallel delay time
SI_DELAY        EQU     $BF0000 ; Fast Storage/Image Delay
        ENDIF
        IF      @SCP("SIDELAY_SETTING","A7")
; 25 us parallel delay time
SI_DELAY	EQU	$A70000 ; 25 microsecond parallel delay time
	ENDIF


DG_DELAY	EQU	$A70000 ; 25 microsecond dump gate delay time
; 
;R_DELAY		EQU	$060000	; Fast serial regisiter transfer delay.  Set to $0x060000.

; R_DELAY, controlled by Makefile def'n RDELAY_SETTING
; as per Confluence July 1 2010 end commentary
        IF      @SCP("RDELAY_SETTING","00")

R_DELAY         EQU     $000000 ; Fast serial register transfer delay
        ENDIF
        IF      @SCP("RDELAY_SETTING","06")
R_DELAY		EQU	$060000	; Fast serial regisiter transfer delay.  Set to $0x060000
	ENDIF



CDS_TIM		EQU	$030000 ; Delay for single clock between reset & data


; bitwise symbols for integrator manipulation.
; Video processor bit definition
;             6     5    4     3      2        1         0
;	     xfer, A/D, integ, Pol-, fixed 0, DCrestore, rst (1 => switch open)
; for the ARC-47 1C (incl. all of gen-ii) it was
;	     xfer, A/D, integ, Pol+, Pol-,    DCrestore, rst (1 => switch open)

; goes with VIDEO
INT_INIT	EQU	%1111000	; Change nearly everything
; goes with VIDEO
INT_RSTOFF	EQU	%1111011	; Stop resetting integrator
; goes with VIDEO and INT_TIM
INT_MINUS	EQU	%0001011	; Integrate reset level
; goes with VIDEO 
INT_STOP	EQU	%0010011	; Stop Integrate
; goes with VIDEO and INT_TIM
INT_PLUS	EQU	%0000011	; Integrate signal level
; goes with VIDEO and ADC_TIM
INT_SMPL	EQU	%0010011	; Stop integrate, A/D is sampling
; goes with VIDEO 
INT_DCR		EQU	%0010000	; Reset integ. and DC restore


; DEEP DEPLETION LEVELS
; These are available for use during integration & readout

; Clock voltages in volts 
RG_HI_D	EQU	+12.0	; Reset
RG_LO_D	EQU	+1.0	;
R_HI_D	EQU	+10.0	; Serials
R_LO_D	EQU	+1.3	; TWEAKED
SW_HI_D	EQU	+10.0	; Summing well, mode 1
SW_LO_D	EQU	+1.3	; TWEAKED
; SW_HI	EQU	+2.0	; Summing well, mode 2
; SW_LO	EQU	+2.0	;
SI_HI_D	EQU	+10.0	; Parallels
SI_LO_D	EQU      0.0	;
TG_HI_D	EQU	+10.0	; Transfer Gate
TG_LO_D	EQU	 0.0	;
DG_HI_D	EQU	+12.0	; Dump Gate
DG_LO_D	EQU	 0.0	;

; DC Bias voltages in volts
VOD_D	EQU	30.45	; Output Drain Left. TWEAKED
; VOD is 1 volt lower than specified because of IR drop in lopass filts.
VRD_D	EQU	17.5	; Reset Drain Left TWEAKED
;VRD     EQU     18.0    ; Reset Drain Left

VOG_D	EQU	 1.7	; output Gate, mode 1 TWEAKED
; VOG	EQU	+18.0	; Output Gate, mode 2
VDD_D	EQU	+29.5	; Dump Drain TWEAKED

; from gwaves_CCD67.  Not used in this DSP.
; these don't fit into the 3 level scheme, so comment out.
;VABG    EQU     -6.0    ; Anti-blooming gate
PWR_D    EQU     +6.0    ; Preamp power - xxx Not used, keep as placeholder


OFFSET	EQU	$2640		; this is not used

; Video offsets used to control bias levels; OFFSET0,1,2,3
; control named amplifiers C, D, B and A respectively.
; Increasing the offset by 1 count seems to decrease the bias level by
; .94 ADU as measured on a $300 count offset Aug 2016. This is not linear.
;
; It is normal procedure to adjust these levels when introducing a
; new chip from e2v to get about a 1K ADU  pedestal for every amplifier. 

; The values used in 2012 for the "Science Grade 5"
; chip with serial 'CCD231-C6-F08_SN-10382-14-01' with unknown characteristics were
;  $28B2,  $2617,  $2B3C,  $2204
; or possibly they were
;  $2CB2,  $2A17,  $2F3C,  $2640
;
; The values used between 2013 and July 2016 for the "Science Grade 1"
; chip with serial   'CCD231-C6-F08_SN-10413-07-01' were
;  $2300,  $2377,  $229C,  $2240
;
; The values used in August 2016 for the "Science Grade 5"
; chip with serial 'CCD231-C6-F08_SN-10382-14-01' subsequent to 1st balancing were
;  $2B55,  $2672,  $2D8C,  $2204

; The levels needed for a bare controller noise floor are different again-
; don't currently have these.
;

OFFSET0	EQU	$2B55	; e2v E, Peter's C, board 0, ch 0
OFFSET1	EQU	$2672	; e2v F, Peter's D, board 0, ch 1
OFFSET2	EQU	$2D8C	; e2v G, Peter's B, board 1, ch 0
OFFSET3	EQU	$2204	; e2v H, Peter's A, board 1, ch 1

;;OFFSET0	EQU	$2CB2	; e2v E, Peter's C, board 0, ch 0
;; FOR ENG grade!
;;OFFSET0	EQU	$28B2	; e2v E, Peter's C, board 0, ch 0
;; FOR SCI grade!
;;OFFSET0	EQU	$2300	; e2v E, Peter's C, board 0, ch 0
;OFFSET0	EQU	$2B55	; e2v E, Peter's C, board 0, ch 0

;;OFFSET1	EQU	$2A17	; e2v F, Peter's D, board 0, ch 1
;; FOR ENG grade!
;;OFFSET1	EQU	$2617	; e2v F, Peter's D, board 0, ch 1
;; FOR SCI grade!
;;OFFSET1	EQU	$2377	; e2v F, Peter's D, board 0, ch 1
;OFFSET1	EQU	$2672	; e2v F, Peter's D, board 0, ch 1

;;OFFSET2	EQU	$2F3C	; e2v G, Peter's B, board 1, ch 0
;; FOR ENG grade!
;;OFFSET2	EQU	$2B3C	; e2v G, Peter's B, board 1, ch 0
;; FOR SCI grade!
;;OFFSET2	EQU	$229C	; e2v G, Peter's B, board 1, ch 0
;OFFSET2	EQU	$2D8C	; e2v G, Peter's B, board 1, ch 0

;;OFFSET3	EQU	$2640	; e2v H, Peter's A, board 1, ch 1
;; FOR ENG AND SCI grade!
;OFFSET3	EQU	$2204	; e2v H, Peter's A, board 1, ch 1

; INVERTED LEVELS
; These are available for use during startup & idling
; they are the DD levels minus 9 volts

; Clock voltages in volts 
RG_HI_I	EQU	+3.0	; Reset
RG_LO_I	EQU	-8.0	;
R_HI_I	EQU	+1.0	; Serials
R_LO_I	EQU	-7.7	; TWEAKED
SW_HI_I	EQU	+1.0	; Summing well, mode 1
SW_LO_I	EQU	-7.7	; TWEAKED
; SW_HI	EQU	+2.0	; Summing well, mode 2
; SW_LO	EQU	+2.0	;
SI_HI_I	EQU	+1.0	; Parallels
SI_LO_I	EQU     -9.0	;
TG_HI_I	EQU	+1.0	; Transfer Gate
TG_LO_I	EQU	-9.0	;
DG_HI_I	EQU	+3.0	; Dump Gate
DG_LO_I	EQU	-9.0	;

; DC Bias voltages in volts
VOD_I	EQU	21.45	; Output Drain Left. TWEAKED
; VOD is 1 volt lower than specified because of IR drop in lopass filts.
VRD_I	EQU	8.5	; Reset Drain Left TWEAKED
;VRD     EQU     18.0    ; Reset Drain Left

VOG_I	EQU 	-7.3	; output Gate, mode 1 TWEAKED
; VOG	EQU	+18.0	; Output Gate, mode 2
VDD_I	EQU	+20.5	; Dump Drain TWEAKED

; from gwaves_CCD67.  Not used in this DSP.
; these don't fit into the 3 level scheme, so comment out.
;VABG    EQU     -6.0    ; Anti-blooming gate
PWR_I    EQU     +6.0    ; Preamp power - xxx Not used, keep as placeholder

; TRANSITION LEVELS
; These are available for the sole purpose of buffering voltage swings

; Clock voltages in volts 
RG_HI_T	EQU	+3.0	; Reset
RG_LO_T	EQU	0.0	;
R_HI_T	EQU	+1.0	; Serials
R_LO_T	EQU	0.0	; TWEAKED
SW_HI_T	EQU	+1.0	; Summing well, mode 1
SW_LO_T	EQU	0.0	; TWEAKED
; SW_HI	EQU	+2.0	; Summing well, mode 2
; SW_LO	EQU	+2.0	;
SI_HI_T	EQU	+1.0	; Parallels
SI_LO_T	EQU     0.0	;
TG_HI_T	EQU	+1.0	; Transfer Gate
TG_LO_T	EQU	0.0	;
DG_HI_T	EQU	+3.0	; Dump Gate
DG_LO_T	EQU	0.0	;

; DC Bias voltages in volts
VOD_T	EQU	21.45	; Output Drain Left. TWEAKED
; VOD is 1 volt lower than specified because of IR drop in lopass filts.
VRD_T	EQU	8.5	; Reset Drain Left TWEAKED
;VRD     EQU     18.0    ; Reset Drain Left

VOG_T	EQU 	0.0	; output Gate, mode 1 TWEAKED
; VOG	EQU	+18.0	; Output Gate, mode 2
VDD_T	EQU	+20.5	; Dump Drain TWEAKED

; from gwaves_CCD67.  Not used in this DSP.
; these don't fit into the 3 level scheme, so comment out.
;VABG    EQU     -6.0    ; Anti-blooming gate
PWR_T     EQU     +6.0    ; Preamp power - xxx Not used, keep as placeholder




; Define switch state bits for the lower CCD clock driver bank CLK2
; In the LMI CCD serial 3 on E/F is on a single pin and serial 3 on G/H is too.
; As it happens serial 3 on all four go up and down together so this doesn't 
; have any effect.  To save effort I've left the symbols the same as they 
; were (SEH3 now really runs serial 3 on E&F and SFG3 runs serial 3 on G&H).
; Pins 11-12, clocks 10 & 11, are not used
SEH1	EQU	1	; Serial #1 E & H registers, Pin 1 - clock 0
SEH2	EQU	2	; Serial #2 E & H registers, Pin 2 - clock 1
SEH3	EQU	4	; Serial #3 E & F registers, Pin 3 - clock 2
SFG1	EQU	8	; Serial #1 F & G registers, Pin 4 - clock 3
SFG2	EQU	$10	; Serial #2 F & G registers, Pin 5 - clock 4
SFG3	EQU	$20	; Serial #3 G & H registers, Pin 6 - clock 5
SWEH	EQU	$40	; Summing well E & H registers, Pin 7 - clock 6
SWFG	EQU	$80	; Summing well F & G registers, Pin 8 - clock 7
REH	EQU	$100	; Reset Gate E & H registers, Pin 9 - clock 8
RFG	EQU	$200	; Reset Gate F & G registers, Pin 10 - clock 9

; Define switch state bits for the upper CCD clock driver bank CLK3
; All 12 of these are used
AB1	EQU	1	; Parallel A & B, phase #1, Pin 13 - clock 12
AB2	EQU	2	; Parallel A & B, phase #2, Pin 14 - clock 13
AB3	EQU	4	; Parallel A & B, phase #3, Pin 15 - clock 14
AB4	EQU	8	; Parallel A & B, phase #4, Pin 16 - clock 15
CD1	EQU	$10	; Parallel C & D, phase #1, Pin 17 - clock 16
CD2	EQU	$20	; Parallel C & D, phase #2, Pin 18 - clock 17
CD3	EQU	$40	; Parallel C & D, phase #3, Pin 19 - clock 18
CD4	EQU	$80	; Parallel C & D, phase #4, Pin 33 - clock 19
TGA	EQU	$100	; Transfer Gate A, Pin 34 - clock 20
TGD	EQU	$200	; Transfer Gate D, Pin 35 - clock 21
DGA	EQU	$400	; Dump Gate A, Pin 36 - clock 22
DGD	EQU	$800	; Dump Gate D, Pin 37 - clock 23

;                  EH Side                                            FG Side
;  OG  SW  1  2  3  1 .... EH1  EH2  EH3  FG2  FG1  .....  1  3  2  1  SW  OG

; Transfer gate dumps into serial 1 and 2.  
; Serial 1 & 2 are high between serial clock code lumps.

; Video processor bit definition
;	     xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)

SERIAL_IDLE	; Split serial during idle
	DC	END_SERIAL_IDLE-SERIAL_IDLE-1
	DC	CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	VIDEO+INT_INIT		; Change nearly everything
	DC	CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+SFG1+0000+0000+0000
	DC	CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
	DC	CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
	DC	CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
	DC	CLK2+CDS_TIM+000+0000+SEH2+0000+0000+000+0000+SFG2+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
	DC	CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_IDLE

; The following waveforms are for binned operation.  This is for mode 1, i.e.
; using a summing well.  Mode 2 uses SW as a second OG and binning has to be
; done on the output node like in HIPO.

INITIAL_CLOCK_SPLIT      ; Both amplifiers
	DC      END_INITIAL_CLOCK_SPLIT-INITIAL_CLOCK_SPLIT-1
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
END_INITIAL_CLOCK_SPLIT

INITIAL_CLOCK_EH         ; Shift to E and H amplifiers
	DC      END_INITIAL_CLOCK_EH-INITIAL_CLOCK_EH-1
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+0000+SFG2+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+SFG1+0000+SFG3+0000
END_INITIAL_CLOCK_EH

INITIAL_CLOCK_FG ; Shift to F and G amplifiers
	DC      END_INITIAL_CLOCK_FG-INITIAL_CLOCK_FG-1
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+0000+SFG2+SFG3+SWFG
END_INITIAL_CLOCK_FG
        
SERIAL_CLOCK_SPLIT      ; Both amplifiers
	DC      END_SERIAL_CLOCK_SPLIT-SERIAL_CLOCK_SPLIT-1
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+0000+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+SFG1+0000+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
END_SERIAL_CLOCK_SPLIT

SERIAL_CLOCK_EH         ; Shift to E and H amplifiers
	DC      END_SERIAL_CLOCK_EH-SERIAL_CLOCK_EH-1
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+0000+SFG2+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+0000+SFG2+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+SFG1+0000+SFG3+0000
END_SERIAL_CLOCK_EH

SERIAL_CLOCK_FG ; Shift to F and G amplifiers
	DC      END_SERIAL_CLOCK_FG-SERIAL_CLOCK_FG-1
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+0000+SFG2+SFG3+SWFG
END_SERIAL_CLOCK_FG

DCRST_LAST
        DC      DCRST_LAST_END-DCRST_LAST-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore 
DCRST_LAST_END
        
VIDEO_PROCESS   
        DC      END_VIDEO_PROCESS-VIDEO_PROCESS-1
SXMIT_VP
        DC      $00F020                 ; A/D data to fiber; overwritten by SOS
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
CCLK_1  ; The following line is overwritten by timmisc.s
        DC      CLK2+CDS_TIM+000+0000+SEH2+0000+0000+000+0000+SFG2+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
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
	ELSE
	ORG     Y:STRT_CIR,P:ROM_DISP
	ENDIF

; This is an area to copy in the serial fast binned waveforms from high Y memory
; It is 0x28 = 40 locations long, enough to put in a binned-by-four waveform
;	     xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ	; Split serial during idle
	DC	CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
	DC	CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+SFG1+0000+0000+0000
	DC	CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
	DC	CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
	DC	CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
	DC	CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+0000+SFG2+0000+SWFG
	DC	CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+SWFG
	DC	CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+SFG1+0000+0000+SWFG
	DC	CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
	DC	CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
	DC	CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
	DC	CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+0000+SFG2+0000+SWFG
	DC	CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+SWFG
	DC	CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+SFG1+0000+0000+SWFG
	DC	CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
	DC	CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
	DC	CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
	DC	CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+0000+SFG2+0000+SWFG
	DC	CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+SWFG
	DC	CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+SFG1+0000+0000+SWFG
	DC	CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
	DC	CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
	DC	CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
SXMIT
	DC	$00F000			; Transmit A/D data to host; overwritten by SOS
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
	DC	CLK2+CDS_TIM+000+0000+SEH2+0000+0000+000+0000+SFG2+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
	DC	CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_READ


; Serial clocking waveform for skipping
	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR+$28,Y:STRT_CIR+$28		; Download address
	ELSE
	ORG     Y:STRT_CIR+$28,P:ROM_DISP+$28
	ENDIF

; There are three serial skip waveforms that must all be the same length
SERIAL_SKIP_EH
	DC	CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+0000
	DC	CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+0000+SFG2+SFG3+0000
	DC	CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+0000
	DC	CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+SFG1+0000+SFG3+0000
	DC	CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+0000
	DC	CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_SKIP_EH

	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR+$30,Y:STRT_CIR+$30		; Download address
	ELSE
	ORG     Y:STRT_CIR+$30,P:ROM_DISP+$30
	ENDIF

SERIAL_SKIP_FG
	DC	CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+0000
	DC	CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+SFG1+0000+SFG3+0000
	DC	CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+0000
	DC	CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+0000+SFG2+SFG3+0000
	DC	CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+0000
	DC	CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_SKIP_FG

	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR+$38,Y:STRT_CIR+$38		; Download address
	ELSE
	ORG     Y:STRT_CIR+$38,P:ROM_DISP+$38
	ENDIF

SERIAL_SKIP_SPLIT
	DC	CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+SFG1+0000+0000+0000
	DC	CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+SFG1+0000+SFG3+0000
	DC	CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+0000
	DC	CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+0000+SFG2+SFG3+0000
	DC	CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+0000+SFG2+0000+0000
	DC	CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_SKIP_SPLIT


; Put all the following code in SRAM.
	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:$100,Y:$100				; Download address
	ELSE
	ORG	Y:$100,P:DAC_DISP
	ENDIF

; DACS from gwaves_CCD67 dropped in here
; Initialization of clock driver and video processor DACs and switches

; for DD levels used during integration & readout
; This is for the ARC 47 4-channel video board
DACS_DD	DC	END_DACS_DD-DACS_DD-1
	DC	CLKV+$0A0080					; DAC = unbuffered mode
	DC	CLKV+$000100+@CVI((R_HI_D+Vmax)/(2*Vmax)*255)	; Pin #1, S1 EH
	DC	CLKV+$000200+@CVI((R_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$000400+@CVI((R_HI_D+Vmax)/(2*Vmax)*255)	; Pin #2, S2 EH
	DC	CLKV+$000800+@CVI((R_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$002000+@CVI((R_HI_D+Vmax)/(2*Vmax)*255)	; Pin #3, S3 EF
	DC	CLKV+$004000+@CVI((R_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$008000+@CVI((R_HI_D+Vmax)/(2*Vmax)*255)	; Pin #4, S1 FG
	DC	CLKV+$010000+@CVI((R_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$020100+@CVI((R_HI_D+Vmax)/(2*Vmax)*255)	; Pin #5, S2 FG
	DC	CLKV+$020200+@CVI((R_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$020400+@CVI((R_HI_D+Vmax)/(2*Vmax)*255)	; Pin #6, S3 GH
	DC	CLKV+$020800+@CVI((R_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$022000+@CVI((SW_HI_D+Vmax)/(2*Vmax)*255)	; Pin #7, SW EH
	DC	CLKV+$024000+@CVI((SW_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$028000+@CVI((SW_HI_D+Vmax)/(2*Vmax)*255)	; Pin #8, SW FG
	DC	CLKV+$030000+@CVI((SW_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$040100+@CVI((RG_HI_D+Vmax)/(2*Vmax)*255)	; Pin #9, RG EH outputs
	DC	CLKV+$040200+@CVI((RG_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$040400+@CVI((RG_HI_D+Vmax)/(2*Vmax)*255)	; Pin #10, RG FG outputs
	DC	CLKV+$040800+@CVI((RG_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$042000+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #11, Unused
	DC	CLKV+$044000+@CVI((ZERO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$048000+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #12, Unused
	DC	CLKV+$050000+@CVI((ZERO+Vmax)/(2*Vmax)*255)

	DC	CLKV+$060100+@CVI((SI_HI_D+Vmax)/(2*Vmax)*255)	; Pin #13, AB1
	DC	CLKV+$060200+@CVI((SI_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$060400+@CVI((SI_HI_D+Vmax)/(2*Vmax)*255)	; Pin #14, AB2
	DC	CLKV+$060800+@CVI((SI_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$062000+@CVI((SI_HI_D+Vmax)/(2*Vmax)*255)	; Pin #15, AB3
	DC	CLKV+$064000+@CVI((SI_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$068000+@CVI((SI_HI_D+Vmax)/(2*Vmax)*255)	; Pin #16, AB4
	DC	CLKV+$070000+@CVI((SI_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$080100+@CVI((SI_HI_D+Vmax)/(2*Vmax)*255)	; Pin #17, CD1
	DC	CLKV+$080200+@CVI((SI_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$080400+@CVI((SI_HI_D+Vmax)/(2*Vmax)*255)	; Pin #18, CD2
	DC	CLKV+$080800+@CVI((SI_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$082000+@CVI((SI_HI_D+Vmax)/(2*Vmax)*255)	; Pin #19, CD3
	DC	CLKV+$084000+@CVI((SI_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$088000+@CVI((SI_HI_D+Vmax)/(2*Vmax)*255)	; Pin #33, CD4
	DC	CLKV+$090000+@CVI((SI_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A0100+@CVI((TG_HI_D+Vmax)/(2*Vmax)*255)	; Pin #34, TGA
	DC	CLKV+$0A0200+@CVI((TG_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A0400+@CVI((TG_HI_D+Vmax)/(2*Vmax)*255)	; Pin #35, TGD
	DC	CLKV+$0A0800+@CVI((TG_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A2000+@CVI((DG_HI_D+Vmax)/(2*Vmax)*255)	; Pin #36, DGA
	DC	CLKV+$0A4000+@CVI((DG_LO_D+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A8000+@CVI((DG_HI_D+Vmax)/(2*Vmax)*255)	; Pin #37, DGD
	DC	CLKV+$0B0000+@CVI((DG_LO_D+Vmax)/(2*Vmax)*255)
	
; Commands for the ARC-47 video board 
	DC	VID0+$0C0000		; Normal Image data D17-D2

; Gain : $0D000g, g = 0 to %1111, Gain = 1.00 to 4.75 in steps of 0.25
; See Bob's ARC47 manual for the gain table.
; define for DD levels -only-
DAC_GNSPD
	DC	VID0+$0D000F	; This is for 4.75 gain
;	DC	VID0+$0D0000	; fix for arc-47 gen-iii default gain 1

; Integrator time constant: $0C01t0, t = 0 to %1111.
; See Bob's ARC47 manual for integration time constant table.
	DC	VID0+$0C0180	; integrator parameter for 0.5 us (integrator gain = 1.0)
	
VOD_MAX	EQU	30.45
VRD_MAX	EQU	19.90
VOG_MAX	EQU	8.70
DAC_ZERO EQU	$1FFF					; Bipolar

DAC_VOD_D	EQU	@CVI((VOD_D/VOD_MAX)*16384-1)		; Unipolar
DAC_VRD_D	EQU	@CVI((VRD_D/VRD_MAX)*16384-1)		; Unipolar
DAC_VOG_D	EQU	@CVI(((VOG_D+VOG_MAX)/VOG_MAX)*8192-1)	; Bipolar
;DAC_VABG	EQU	@CVI(((VABG+VOG_MAX)/VOG_MAX)*8192-1)	; Bipolar
DAC_VDD_D	EQU	@CVI((VDD_D/VOD_MAX)*16384-1)		; Unipolar
DAC_PWR_D	EQU	@CVI(((PWR_D+VOG_MAX)/VOG_MAX)*8192-1)	; Bipolar

; Initialize the ARC-47 DAC For DC_BIAS
	DC	VID0+DAC_ADDR+$000000		; Vod0, pin 52
	DC	VID0+DAC_RegD+DAC_VOD_D
	DC	VID0+DAC_ADDR+$000004		; Vrd0, pin 13
	DC	VID0+DAC_RegD+DAC_VRD_D	
	DC	VID0+DAC_ADDR+$000008		; Vog0, pin 29
	DC	VID0+DAC_RegD+DAC_VOG_D		
	DC	VID0+DAC_ADDR+$00000C		; NC, pin 5, NC
	DC	VID0+DAC_RegD+DAC_ZERO

	DC	VID0+DAC_ADDR+$000001		; Vod1, pin 32
	DC	VID0+DAC_RegD+DAC_VOD_D
	DC	VID0+DAC_ADDR+$000005		; Vrd1, pin 55
	DC	VID0+DAC_RegD+DAC_VRD_D	
	DC	VID0+DAC_ADDR+$000009		; Vabg, pin 8
	DC	VID0+DAC_RegD+DAC_VOG_D		
	DC	VID0+DAC_ADDR+$00000D		; NC, pin 47, NC
	DC	VID0+DAC_RegD+DAC_ZERO

	DC	VID0+DAC_ADDR+$000002		; Vod2, pin 11
	DC	VID0+DAC_RegD+DAC_VOD_D
	DC	VID0+DAC_ADDR+$000006		; Vrd2, pin 35
	DC	VID0+DAC_RegD+DAC_VRD_D	
	DC	VID0+DAC_ADDR+$00000A		; Vog2, pin 50
	DC	VID0+DAC_RegD+DAC_VOG_D		
	DC	VID0+DAC_ADDR+$00000E		; NC, pin 27, NC
	DC	VID0+DAC_RegD+DAC_ZERO
	
	DC	VID0+DAC_ADDR+$000003		; Vod3, pin 53
	DC	VID0+DAC_RegD+DAC_VOD_D
	DC	VID0+DAC_ADDR+$000007		; Vrd3, pin 14
	DC	VID0+DAC_RegD+DAC_VRD_D	
	DC	VID0+DAC_ADDR+$00000B		; Vog3, pin 30
	DC	VID0+DAC_RegD+DAC_VOG_D	
	DC	VID0+DAC_ADDR+$00000F		; NC, pin 6, NC
	DC	VID0+DAC_RegD+DAC_ZERO
		
	DC	VID0+DAC_ADDR+$000010		; Vod4, pin 33, VDD
	DC	VID0+DAC_RegD+DAC_VDD_D
	DC	VID0+DAC_ADDR+$000011		; Vrd4, pin 56, NC
	DC	VID0+DAC_RegD+DAC_PWR_D	
	DC	VID0+DAC_ADDR+$000012		; Vog4, pin 9, NC
	DC	VID0+DAC_RegD+DAC_ZERO	
	DC	VID0+DAC_ADDR+$000013		; Vrsv4,pin 48, NC
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

END_DACS_DD

; Initialization of clock driver and video processor DACs and switches

; for Inverted levels used during startup & idling
; This is for the ARC 47 4-channel video board
DACS_INV	DC	END_DACS_INV-DACS_INV-1
	DC	CLKV+$0A0080					; DAC = unbuffered mode
	DC	CLKV+$000100+@CVI((R_HI_I+Vmax)/(2*Vmax)*255)	; Pin #1, S1 EH
	DC	CLKV+$000200+@CVI((R_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$000400+@CVI((R_HI_I+Vmax)/(2*Vmax)*255)	; Pin #2, S2 EH
	DC	CLKV+$000800+@CVI((R_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$002000+@CVI((R_HI_I+Vmax)/(2*Vmax)*255)	; Pin #3, S3 EF
	DC	CLKV+$004000+@CVI((R_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$008000+@CVI((R_HI_I+Vmax)/(2*Vmax)*255)	; Pin #4, S1 FG
	DC	CLKV+$010000+@CVI((R_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$020100+@CVI((R_HI_I+Vmax)/(2*Vmax)*255)	; Pin #5, S2 FG
	DC	CLKV+$020200+@CVI((R_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$020400+@CVI((R_HI_I+Vmax)/(2*Vmax)*255)	; Pin #6, S3 GH
	DC	CLKV+$020800+@CVI((R_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$022000+@CVI((SW_HI_I+Vmax)/(2*Vmax)*255)	; Pin #7, SW EH
	DC	CLKV+$024000+@CVI((SW_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$028000+@CVI((SW_HI_I+Vmax)/(2*Vmax)*255)	; Pin #8, SW FG
	DC	CLKV+$030000+@CVI((SW_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$040100+@CVI((RG_HI_I+Vmax)/(2*Vmax)*255)	; Pin #9, RG EH outputs
	DC	CLKV+$040200+@CVI((RG_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$040400+@CVI((RG_HI_I+Vmax)/(2*Vmax)*255)	; Pin #10, RG FG outputs
	DC	CLKV+$040800+@CVI((RG_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$042000+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #11, Unused
	DC	CLKV+$044000+@CVI((ZERO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$048000+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #12, Unused
	DC	CLKV+$050000+@CVI((ZERO+Vmax)/(2*Vmax)*255)

	DC	CLKV+$060100+@CVI((SI_HI_I+Vmax)/(2*Vmax)*255)	; Pin #13, AB1
	DC	CLKV+$060200+@CVI((SI_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$060400+@CVI((SI_HI_I+Vmax)/(2*Vmax)*255)	; Pin #14, AB2
	DC	CLKV+$060800+@CVI((SI_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$062000+@CVI((SI_HI_I+Vmax)/(2*Vmax)*255)	; Pin #15, AB3
	DC	CLKV+$064000+@CVI((SI_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$068000+@CVI((SI_HI_I+Vmax)/(2*Vmax)*255)	; Pin #16, AB4
	DC	CLKV+$070000+@CVI((SI_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$080100+@CVI((SI_HI_I+Vmax)/(2*Vmax)*255)	; Pin #17, CD1
	DC	CLKV+$080200+@CVI((SI_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$080400+@CVI((SI_HI_I+Vmax)/(2*Vmax)*255)	; Pin #18, CD2
	DC	CLKV+$080800+@CVI((SI_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$082000+@CVI((SI_HI_I+Vmax)/(2*Vmax)*255)	; Pin #19, CD3
	DC	CLKV+$084000+@CVI((SI_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$088000+@CVI((SI_HI_I+Vmax)/(2*Vmax)*255)	; Pin #33, CD4
	DC	CLKV+$090000+@CVI((SI_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A0100+@CVI((TG_HI_I+Vmax)/(2*Vmax)*255)	; Pin #34, TGA
	DC	CLKV+$0A0200+@CVI((TG_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A0400+@CVI((TG_HI_I+Vmax)/(2*Vmax)*255)	; Pin #35, TGD
	DC	CLKV+$0A0800+@CVI((TG_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A2000+@CVI((DG_HI_I+Vmax)/(2*Vmax)*255)	; Pin #36, DGA
	DC	CLKV+$0A4000+@CVI((DG_LO_I+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A8000+@CVI((DG_HI_I+Vmax)/(2*Vmax)*255)	; Pin #37, DGD
	DC	CLKV+$0B0000+@CVI((DG_LO_I+Vmax)/(2*Vmax)*255)
	
; Commands for the ARC-47 video board 
	DC	VID0+$0C0000		; Normal Image data D17-D2

; Gain : $0D000g, g = 0 to %1111, Gain = 1.00 to 4.75 in steps of 0.25
; See Bob's ARC47 manual for the gain table.
; the label is not defined here- the setgain command will not touch
;DAC_GNSPD
	DC	VID0+$0D000F	; This is for 4.75 gain
;	DC	VID0+$0D0000	; fix for arc-47 gen-iii default gain 1

; Integrator time constant: $0C01t0, t = 0 to %1111.
; See Bob's ARC47 manual for integration time constant table.
	DC	VID0+$0C0180	; integrator parameter for 0.5 us (integrator gain = 1.0)
	
;VOD_MAX	EQU	30.45
;VRD_MAX	EQU	19.90
;VOG_MAX	EQU	8.70
DAC_VOD_I	EQU	@CVI((VOD_I/VOD_MAX)*16384-1)		; Unipolar
DAC_VRD_I	EQU	@CVI((VRD_I/VRD_MAX)*16384-1)		; Unipolar
DAC_VOG_I	EQU	@CVI(((VOG_I+VOG_MAX)/VOG_MAX)*8192-1)	; Bipolar
;DAC_VABG	EQU	@CVI(((VABG+VOG_MAX)/VOG_MAX)*8192-1)	; Bipolar
DAC_VDD_I	EQU	@CVI((VDD_I/VOD_MAX)*16384-1)		; Unipolar
DAC_PWR_I	EQU	@CVI(((PWR_I+VOG_MAX)/VOG_MAX)*8192-1)	; Bipolar
;DAC_ZERO EQU	$1FFF					; Bipolar

; Initialize the ARC-47 DAC For DC_BIAS
	DC	VID0+DAC_ADDR+$000000		; Vod0, pin 52
	DC	VID0+DAC_RegD+DAC_VOD_I
	DC	VID0+DAC_ADDR+$000004		; Vrd0, pin 13
	DC	VID0+DAC_RegD+DAC_VRD_I	
	DC	VID0+DAC_ADDR+$000008		; Vog0, pin 29
	DC	VID0+DAC_RegD+DAC_VOG_I		
	DC	VID0+DAC_ADDR+$00000C		; NC, pin 5, NC
	DC	VID0+DAC_RegD+DAC_ZERO

	DC	VID0+DAC_ADDR+$000001		; Vod1, pin 32
	DC	VID0+DAC_RegD+DAC_VOD_I
	DC	VID0+DAC_ADDR+$000005		; Vrd1, pin 55
	DC	VID0+DAC_RegD+DAC_VRD_I	
	DC	VID0+DAC_ADDR+$000009		; Vabg, pin 8
	DC	VID0+DAC_RegD+DAC_VOG_I		
	DC	VID0+DAC_ADDR+$00000D		; NC, pin 47, NC
	DC	VID0+DAC_RegD+DAC_ZERO

	DC	VID0+DAC_ADDR+$000002		; Vod2, pin 11
	DC	VID0+DAC_RegD+DAC_VOD_I
	DC	VID0+DAC_ADDR+$000006		; Vrd2, pin 35
	DC	VID0+DAC_RegD+DAC_VRD_I	
	DC	VID0+DAC_ADDR+$00000A		; Vog2, pin 50
	DC	VID0+DAC_RegD+DAC_VOG_I		
	DC	VID0+DAC_ADDR+$00000E		; NC, pin 27, NC
	DC	VID0+DAC_RegD+DAC_ZERO
	
	DC	VID0+DAC_ADDR+$000003		; Vod3, pin 53
	DC	VID0+DAC_RegD+DAC_VOD_I
	DC	VID0+DAC_ADDR+$000007		; Vrd3, pin 14
	DC	VID0+DAC_RegD+DAC_VRD_I	
	DC	VID0+DAC_ADDR+$00000B		; Vog3, pin 30
	DC	VID0+DAC_RegD+DAC_VOG_I	
	DC	VID0+DAC_ADDR+$00000F		; NC, pin 6, NC
	DC	VID0+DAC_RegD+DAC_ZERO
		
	DC	VID0+DAC_ADDR+$000010		; Vod4, pin 33, VDD
	DC	VID0+DAC_RegD+DAC_VDD_I
	DC	VID0+DAC_ADDR+$000011		; Vrd4, pin 56, NC
	DC	VID0+DAC_RegD+DAC_PWR_I	
	DC	VID0+DAC_ADDR+$000012		; Vog4, pin 9, NC
	DC	VID0+DAC_RegD+DAC_ZERO	
	DC	VID0+DAC_ADDR+$000013		; Vrsv4,pin 48, NC
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

END_DACS_INV


; Initialization of clock driver and video processor DACs and switches

; for Transition levels used moving to or from the DD levels
; This is for the ARC 47 4-channel video board
DACS_TRANS	DC	END_DACS_TRANS-DACS_TRANS-1
	DC	CLKV+$0A0080					; DAC = unbuffered mode
	DC	CLKV+$000100+@CVI((R_HI_T+Vmax)/(2*Vmax)*255)	; Pin #1, S1 EH
	DC	CLKV+$000200+@CVI((R_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$000400+@CVI((R_HI_T+Vmax)/(2*Vmax)*255)	; Pin #2, S2 EH
	DC	CLKV+$000800+@CVI((R_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$002000+@CVI((R_HI_T+Vmax)/(2*Vmax)*255)	; Pin #3, S3 EF
	DC	CLKV+$004000+@CVI((R_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$008000+@CVI((R_HI_T+Vmax)/(2*Vmax)*255)	; Pin #4, S1 FG
	DC	CLKV+$010000+@CVI((R_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$020100+@CVI((R_HI_T+Vmax)/(2*Vmax)*255)	; Pin #5, S2 FG
	DC	CLKV+$020200+@CVI((R_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$020400+@CVI((R_HI_T+Vmax)/(2*Vmax)*255)	; Pin #6, S3 GH
	DC	CLKV+$020800+@CVI((R_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$022000+@CVI((SW_HI_T+Vmax)/(2*Vmax)*255)	; Pin #7, SW EH
	DC	CLKV+$024000+@CVI((SW_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$028000+@CVI((SW_HI_T+Vmax)/(2*Vmax)*255)	; Pin #8, SW FG
	DC	CLKV+$030000+@CVI((SW_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$040100+@CVI((RG_HI_I+Vmax)/(2*Vmax)*255)	; Pin #9, RG EH outputs
	DC	CLKV+$040200+@CVI((RG_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$040400+@CVI((RG_HI_T+Vmax)/(2*Vmax)*255)	; Pin #10, RG FG outputs
	DC	CLKV+$040800+@CVI((RG_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$042000+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #11, Unused
	DC	CLKV+$044000+@CVI((ZERO+Vmax)/(2*Vmax)*255)
	DC	CLKV+$048000+@CVI((ZERO+Vmax)/(2*Vmax)*255)	; Pin #12, Unused
	DC	CLKV+$050000+@CVI((ZERO+Vmax)/(2*Vmax)*255)

	DC	CLKV+$060100+@CVI((SI_HI_T+Vmax)/(2*Vmax)*255)	; Pin #13, AB1
	DC	CLKV+$060200+@CVI((SI_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$060400+@CVI((SI_HI_T+Vmax)/(2*Vmax)*255)	; Pin #14, AB2
	DC	CLKV+$060800+@CVI((SI_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$062000+@CVI((SI_HI_T+Vmax)/(2*Vmax)*255)	; Pin #15, AB3
	DC	CLKV+$064000+@CVI((SI_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$068000+@CVI((SI_HI_T+Vmax)/(2*Vmax)*255)	; Pin #16, AB4
	DC	CLKV+$070000+@CVI((SI_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$080100+@CVI((SI_HI_T+Vmax)/(2*Vmax)*255)	; Pin #17, CD1
	DC	CLKV+$080200+@CVI((SI_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$080400+@CVI((SI_HI_T+Vmax)/(2*Vmax)*255)	; Pin #18, CD2
	DC	CLKV+$080800+@CVI((SI_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$082000+@CVI((SI_HI_T+Vmax)/(2*Vmax)*255)	; Pin #19, CD3
	DC	CLKV+$084000+@CVI((SI_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$088000+@CVI((SI_HI_T+Vmax)/(2*Vmax)*255)	; Pin #33, CD4
	DC	CLKV+$090000+@CVI((SI_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A0100+@CVI((TG_HI_T+Vmax)/(2*Vmax)*255)	; Pin #34, TGA
	DC	CLKV+$0A0200+@CVI((TG_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A0400+@CVI((TG_HI_T+Vmax)/(2*Vmax)*255)	; Pin #35, TGD
	DC	CLKV+$0A0800+@CVI((TG_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A2000+@CVI((DG_HI_T+Vmax)/(2*Vmax)*255)	; Pin #36, DGA
	DC	CLKV+$0A4000+@CVI((DG_LO_T+Vmax)/(2*Vmax)*255)
	DC	CLKV+$0A8000+@CVI((DG_HI_T+Vmax)/(2*Vmax)*255)	; Pin #37, DGD
	DC	CLKV+$0B0000+@CVI((DG_LO_T+Vmax)/(2*Vmax)*255)
	
; Commands for the ARC-47 video board 
	DC	VID0+$0C0000		; Normal Image data D17-D2

; Gain : $0D000g, g = 0 to %1111, Gain = 1.00 to 4.75 in steps of 0.25
; See Bob's ARC47 manual for the gain table.
; the label is not defined here- the setgain command will not touch
;DAC_GNSPD
	DC	VID0+$0D000F	; This is for 4.75 gain
;	DC	VID0+$0D0000	; fix for arc-47 gen-iii default gain 1

; Integrator time constant: $0C01t0, t = 0 to %1111.
; See Bob's ARC47 manual for integration time constant table.
	DC	VID0+$0C0180	; integrator parameter for 0.5 us (integrator gain = 1.0)
	
;VOD_MAX	EQU	30.45
;VRD_MAX	EQU	19.90
;VOG_MAX	EQU	8.70
DAC_VOD_T	EQU	@CVI((VOD_T/VOD_MAX)*16384-1)		; Unipolar
DAC_VRD_T	EQU	@CVI((VRD_T/VRD_MAX)*16384-1)		; Unipolar
DAC_VOG_T	EQU	@CVI(((VOG_T+VOG_MAX)/VOG_MAX)*8192-1)	; Bipolar
;DAC_VABG	EQU	@CVI(((VABG+VOG_MAX)/VOG_MAX)*8192-1)	; Bipolar
DAC_VDD_T	EQU	@CVI((VDD_T/VOD_MAX)*16384-1)		; Unipolar
DAC_PWR_T	EQU	@CVI(((PWR_T+VOG_MAX)/VOG_MAX)*8192-1)	; Bipolar
;DAC_ZERO EQU	$1FFF					; Bipolar

; Initialize the ARC-47 DAC For DC_BIAS
	DC	VID0+DAC_ADDR+$000000		; Vod0, pin 52
	DC	VID0+DAC_RegD+DAC_VOD_T
	DC	VID0+DAC_ADDR+$000004		; Vrd0, pin 13
	DC	VID0+DAC_RegD+DAC_VRD_T	
	DC	VID0+DAC_ADDR+$000008		; Vog0, pin 29
	DC	VID0+DAC_RegD+DAC_VOG_T		
	DC	VID0+DAC_ADDR+$00000C		; NC, pin 5, NC
	DC	VID0+DAC_RegD+DAC_ZERO

	DC	VID0+DAC_ADDR+$000001		; Vod1, pin 32
	DC	VID0+DAC_RegD+DAC_VOD_T
	DC	VID0+DAC_ADDR+$000005		; Vrd1, pin 55
	DC	VID0+DAC_RegD+DAC_VRD_T	
	DC	VID0+DAC_ADDR+$000009		; Vabg, pin 8
	DC	VID0+DAC_RegD+DAC_VOG_T		
	DC	VID0+DAC_ADDR+$00000D		; NC, pin 47, NC
	DC	VID0+DAC_RegD+DAC_ZERO

	DC	VID0+DAC_ADDR+$000002		; Vod2, pin 11
	DC	VID0+DAC_RegD+DAC_VOD_T
	DC	VID0+DAC_ADDR+$000006		; Vrd2, pin 35
	DC	VID0+DAC_RegD+DAC_VRD_T	
	DC	VID0+DAC_ADDR+$00000A		; Vog2, pin 50
	DC	VID0+DAC_RegD+DAC_VOG_T		
	DC	VID0+DAC_ADDR+$00000E		; NC, pin 27, NC
	DC	VID0+DAC_RegD+DAC_ZERO
	
	DC	VID0+DAC_ADDR+$000003		; Vod3, pin 53
	DC	VID0+DAC_RegD+DAC_VOD_T
	DC	VID0+DAC_ADDR+$000007		; Vrd3, pin 14
	DC	VID0+DAC_RegD+DAC_VRD_T	
	DC	VID0+DAC_ADDR+$00000B		; Vog3, pin 30
	DC	VID0+DAC_RegD+DAC_VOG_T	
	DC	VID0+DAC_ADDR+$00000F		; NC, pin 6, NC
	DC	VID0+DAC_RegD+DAC_ZERO
		
	DC	VID0+DAC_ADDR+$000010		; Vod4, pin 33, VDD
	DC	VID0+DAC_RegD+DAC_VDD_T
	DC	VID0+DAC_ADDR+$000011		; Vrd4, pin 56, NC
	DC	VID0+DAC_RegD+DAC_PWR_T	
	DC	VID0+DAC_ADDR+$000012		; Vog4, pin 9, NC
	DC	VID0+DAC_RegD+DAC_ZERO	
	DC	VID0+DAC_ADDR+$000013		; Vrsv4,pin 48, NC
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

END_DACS_TRANS


;  ***  Definitions for Y: memory waveform tables  *****
; Put the parallel clock waveforms in slow external Y memory since there isn't 
; enough room in the fast memory for everything we need.  The parallels are
; way slow anyway so the slowness of the access can be tweaked with SI_DELAY.
; Clock whole CCD up toward the GH serial register.  Serial phases 1 & 2 high.
; CD goes 2-3-4-1, AB goes 3-2-1-4
; Parallel phases 2 & 3 high during integration.

; Serial clock convention:    REH SEH1 SEH2 SEH3 SWEH RFG SFG1 SFG2 SFG3 SWFG
; Parallel clock convention:  AB1 AB2 AB3 AB4 TGA DGA CD1 CD2 CD3 CD4 TGD DGD

; ADD DC RESTORE based on gwaves!
ABCD_UP
	DC	END_ABCD_UP-ABCD_UP-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore 
	DC	CLK2+SI_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	CLK3+SI_DELAY+AB1+AB2+AB3+000+000+000+000+CD2+CD3+CD4+000+000
	DC	CLK3+SI_DELAY+AB1+AB2+000+000+000+000+000+000+CD3+CD4+000+000
	DC	CLK3+SI_DELAY+AB1+AB2+000+AB4+000+000+CD1+000+CD3+CD4+TGD+000
	DC	CLK3+SI_DELAY+AB1+000+000+AB4+000+000+CD1+000+000+CD4+TGD+000
	DC	CLK3+SI_DELAY+AB1+000+AB3+AB4+000+000+CD1+CD2+000+CD4+TGD+000
	DC	CLK3+SI_DELAY+000+000+AB3+AB4+000+000+CD1+CD2+000+000+TGD+000
	DC	CLK3+SI_DELAY+000+AB2+AB3+AB4+000+000+CD1+CD2+CD3+000+TGD+000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+000+000+000
END_ABCD_UP

; Clock whole CCD down toward the EF serial register.  Serial phases 1 & 2 high.
; AB goes 2-3-4-1, CD goes 3-2-1-4
; Parallel phases 2 & 3 high during integration.
; ADD DC RESTORE based on gwaves!
ABCD_DOWN
	DC	END_ABCD_DOWN-ABCD_DOWN-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore 
	DC	CLK2+SI_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	CLK3+SI_DELAY+000+AB2+AB3+AB4+TGA+000+CD1+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+000+000+AB3+AB4+TGA+000+CD1+CD2+000+000+000+000
	DC	CLK3+SI_DELAY+AB1+000+AB3+AB4+TGA+000+CD1+CD2+000+CD4+000+000
	DC	CLK3+SI_DELAY+AB1+000+000+AB4+TGA+000+CD1+000+000+CD4+000+000
	DC	CLK3+SI_DELAY+AB1+AB2+000+AB4+TGA+000+CD1+000+CD3+CD4+000+000
	DC	CLK3+SI_DELAY+AB1+AB2+000+000+000+000+000+000+CD3+CD4+000+000
	DC	CLK3+SI_DELAY+AB1+AB2+AB3+000+000+000+000+CD2+CD3+CD4+000+000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+000+000+000
END_ABCD_DOWN

; Clock whole CCD split.  Serial phases 1 & 2 high.
; ABCD all go 2-3-4-1
; Parallel phases 2 & 3 high during integration.
; ADD DC RESTORE based on gwaves!
ABCD_SPLIT
	DC	END_ABCD_SPLIT-ABCD_SPLIT-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore 
	DC	CLK2+SI_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	CLK3+SI_DELAY+000+AB2+AB3+AB4+TGA+000+000+CD2+CD3+CD4+000+000
	DC	CLK3+SI_DELAY+000+000+AB3+AB4+TGA+000+000+000+CD3+CD4+000+000
	DC	CLK3+SI_DELAY+AB1+000+AB3+AB4+TGA+000+CD1+000+CD3+CD4+TGD+000
	DC	CLK3+SI_DELAY+AB1+000+000+AB4+TGA+000+CD1+000+000+CD4+TGD+000
	DC	CLK3+SI_DELAY+AB1+AB2+000+AB4+TGA+000+CD1+CD2+000+CD4+TGD+000
	DC	CLK3+SI_DELAY+AB1+AB2+000+000+000+000+CD1+CD2+000+000+TGD+000
	DC	CLK3+SI_DELAY+AB1+AB2+AB3+000+000+000+CD1+CD2+CD3+000+TGD+000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+000+000+000
END_ABCD_SPLIT

; Clear whole CCD up toward the GH serial register.  Serial phases 1 & 2 high.
; CD goes 2-3-4-1, AB goes 3-2-1-4
; Parallel phases 2 & 3 high during integration.
; ADD DC RESTORE based on gwaves!
ABCD_CLEAR_UP
	DC	END_ABCD_CLEAR_UP-ABCD_CLEAR_UP-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore 
	DC	CLK2+SI_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	CLK3+SI_DELAY+AB1+AB2+AB3+000+000+000+000+CD2+CD3+CD4+000+DGD
	DC	CLK3+SI_DELAY+AB1+AB2+000+000+000+000+000+000+CD3+CD4+000+DGD
	DC	CLK3+SI_DELAY+AB1+AB2+000+AB4+000+000+CD1+000+CD3+CD4+TGD+DGD
	DC	CLK3+SI_DELAY+AB1+000+000+AB4+000+000+CD1+000+000+CD4+TGD+DGD
	DC	CLK3+SI_DELAY+AB1+000+AB3+AB4+000+000+CD1+CD2+000+CD4+TGD+DGD
	DC	CLK3+SI_DELAY+000+000+AB3+AB4+000+000+CD1+CD2+000+000+TGD+DGD
	DC	CLK3+SI_DELAY+000+AB2+AB3+AB4+000+000+CD1+CD2+CD3+000+TGD+DGD
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+000+000+DGD
	DC	CLK2+DG_DELAY+REH+0000+0000+0000+0000+RFG+0000+0000+0000+0000
	DC	CLK3+DG_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+000+000+000
	DC	CLK2+DG_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
END_ABCD_CLEAR_UP

; Clear whole CCD down toward the EF serial register.  Serial phases 1 & 2 high.
; AB goes 2-3-4-1, CD goes 3-2-1-4
; Parallel phases 2 & 3 high during integration.
; ADD DC RESTORE based on gwaves!
ABCD_CLEAR_DOWN
	DC	END_ABCD_CLEAR_DOWN-ABCD_CLEAR_DOWN-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore 
	DC	CLK2+SI_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	CLK3+SI_DELAY+000+AB2+AB3+AB4+TGA+DGA+CD1+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+000+000+AB3+AB4+TGA+DGA+CD1+CD2+000+000+000+000
	DC	CLK3+SI_DELAY+AB1+000+AB3+AB4+TGA+DGA+CD1+CD2+000+CD4+000+000
	DC	CLK3+SI_DELAY+AB1+000+000+AB4+TGA+DGA+CD1+000+000+CD4+000+000
	DC	CLK3+SI_DELAY+AB1+AB2+000+AB4+TGA+DGA+CD1+000+CD3+CD4+000+000
	DC	CLK3+SI_DELAY+AB1+AB2+000+000+000+DGA+000+000+CD3+CD4+000+000
	DC	CLK3+SI_DELAY+AB1+AB2+AB3+000+000+DGA+000+CD2+CD3+CD4+000+000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+DGA+000+CD2+CD3+000+000+000
	DC	CLK2+DG_DELAY+REH+0000+0000+0000+0000+RFG+0000+0000+0000+0000
	DC	CLK3+DG_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+000+000+000
	DC	CLK2+DG_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
END_ABCD_CLEAR_DOWN

; Clear whole CCD split.  Serial phases 1 & 2 high.
; ABCD all go 2-3-4-1
; Parallel phases 2 & 3 high during integration.
; ADD DC RESTORE based on gwaves!
ABCD_CLEAR_SPLIT
	DC	END_ABCD_CLEAR_SPLIT-ABCD_CLEAR_SPLIT-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore 
	DC	CLK2+SI_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	CLK3+SI_DELAY+000+AB2+AB3+AB4+TGA+DGA+000+CD2+CD3+CD4+000+DGD
	DC	CLK3+SI_DELAY+000+000+AB3+AB4+TGA+DGA+000+000+CD3+CD4+000+DGD
	DC	CLK3+SI_DELAY+AB1+000+AB3+AB4+TGA+DGA+CD1+000+CD3+CD4+TGD+DGD
	DC	CLK3+SI_DELAY+AB1+000+000+AB4+TGA+DGA+CD1+000+000+CD4+TGD+DGD
	DC	CLK3+SI_DELAY+AB1+AB2+000+AB4+TGA+DGA+CD1+CD2+000+CD4+TGD+DGD
	DC	CLK3+SI_DELAY+AB1+AB2+000+000+000+DGA+CD1+CD2+000+000+TGD+DGD
	DC	CLK3+SI_DELAY+AB1+AB2+AB3+000+000+DGA+CD1+CD2+CD3+000+TGD+DGD
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+DGA+000+CD2+CD3+000+000+DGD
	DC	CLK2+DG_DELAY+REH+0000+0000+0000+0000+RFG+0000+0000+0000+0000
	DC	CLK3+DG_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+000+000+000
	DC	CLK2+DG_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
END_ABCD_CLEAR_SPLIT

; Clock CD section up toward the GH serial register; AB static.  Serial phases 1 & 2 high.
; CD goes 2-3-4-1
; Parallel phases 2 & 3 high during integration.
; ADD DC RESTORE based on gwaves!
CD_UP
	DC	END_CD_UP-CD_UP-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore 
	DC	CLK2+SI_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+CD4+000+000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+000+000+CD3+CD4+000+000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+CD1+000+CD3+CD4+TGD+000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+CD1+000+000+CD4+TGD+000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+CD1+CD2+000+CD4+TGD+000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+CD1+CD2+000+000+TGD+000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+CD1+CD2+CD3+000+TGD+000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+000+000+000
END_CD_UP

; Clock AB section down toward the EF serial register; CD static.  Serial phases 1 & 2 high.
; AB goes 2-3-4-1
; Parallel phases 2 & 3 high during integration.
; ADD DC RESTORE based on gwaves!
AB_DOWN
	DC	END_AB_DOWN-AB_DOWN-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore 
	DC	CLK2+SI_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	CLK3+SI_DELAY+000+AB2+AB3+AB4+TGA+000+000+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+000+000+AB3+AB4+TGA+000+000+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+AB1+000+AB3+AB4+TGA+000+000+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+AB1+000+000+AB4+TGA+000+000+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+AB1+AB2+000+AB4+TGA+000+000+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+AB1+AB2+000+000+000+000+000+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+AB1+AB2+AB3+000+000+000+000+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+000+000+000
END_AB_DOWN

; Clear CD section up toward the GH serial register; AB static.  Serial phases 1 & 2 high.
; CD goes 2-3-4-1
; Parallel phases 2 & 3 high during integration.
; ADD DC RESTORE based on gwaves!
CD_CLEAR_UP
	DC	END_CD_CLEAR_UP-CD_CLEAR_UP-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore 
	DC	CLK2+SI_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+CD4+000+DGD
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+000+000+CD3+CD4+000+DGD
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+CD1+000+CD3+CD4+TGD+DGD
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+CD1+000+000+CD4+TGD+DGD
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+CD1+CD2+000+CD4+TGD+DGD
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+CD1+CD2+000+000+TGD+DGD
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+CD1+CD2+CD3+000+TGD+DGD
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+000+000+DGD
	DC	CLK2+DG_DELAY+REH+0000+0000+0000+0000+RFG+0000+0000+0000+0000
	DC	CLK3+DG_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+000+000+000
	DC	CLK2+DG_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
END_CD_CLEAR_UP

; Clear AB section down toward the EF serial register; CD static.  Serial phases 1 & 2 high.
; AB goes 2-3-4-1
; Parallel phases 2 & 3 high during integration.
; ADD DC RESTORE based on gwaves!
AB_CLEAR_DOWN
	DC	END_AB_CLEAR_DOWN-AB_CLEAR_DOWN-1
	DC	VIDEO+INT_DCR		; Reset integ. and DC restore 
	DC	CLK2+SI_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	CLK3+SI_DELAY+000+AB2+AB3+AB4+TGA+DGA+000+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+000+000+AB3+AB4+TGA+DGA+000+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+AB1+000+AB3+AB4+TGA+DGA+000+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+AB1+000+000+AB4+TGA+DGA+000+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+AB1+AB2+000+AB4+TGA+DGA+000+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+AB1+AB2+000+000+000+DGA+000+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+AB1+AB2+AB3+000+000+DGA+000+CD2+CD3+000+000+000
	DC	CLK3+SI_DELAY+000+AB2+AB3+000+000+DGA+000+CD2+CD3+000+000+000
	DC	CLK2+DG_DELAY+REH+0000+0000+0000+0000+RFG+0000+0000+0000+0000
	DC	CLK3+DG_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+000+000+000
	DC	CLK2+DG_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
END_AB_CLEAR_DOWN

; Dump both the EF and GH serial registers using DGA and DGD
DUMP_SERIAL
	DC	END_DUMP_SERIAL-DUMP_SERIAL-1
	DC	CLK2+DG_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
	DC	CLK3+DG_DELAY+000+AB2+AB3+000+000+DGA+000+CD2+CD3+000+000+DGD
	DC	CLK2+DG_DELAY+REH+0000+0000+0000+0000+RFG+0000+0000+0000+0000
	DC	CLK3+DG_DELAY+000+AB2+AB3+000+000+000+000+CD2+CD3+000+000+000
	DC	CLK2+DG_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
END_DUMP_SERIAL




; Parallel waveforms done.  Move on to the layered serial ones.

;	These are the 12 fast serial read waveforms for left, right, 
;	and split reads for serial binning factors from 1 to 4.

;	Unbinned waveforms
;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_EH_1
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+0000+SFG2+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+SFG1+0000+SFG3+0000
SXMIT_EH_1
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
        DC      CLK2+CDS_TIM+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_READ_EH_1

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_FG_1
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+0000+SFG2+SFG3+SWFG
SXMIT_FG_1
	DC	$00F021			; Transmit A/D data to host
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
        DC      CLK2+CDS_TIM+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_READ_FG_1

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_SPLIT_1
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
SXMIT_SPLIT_1
	DC	$00F020			; Transmit A/D data to host
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
        DC      CLK2+CDS_TIM+000+0000+SEH2+0000+0000+000+0000+SFG2+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_READ_SPLIT_1

;	Bin by 2 waveforms
;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_EH_2
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+0000
	DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+0000+SFG2+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+SFG1+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+0000+SFG2+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+0000+SFG2+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+SFG1+0000+SFG3+0000
SXMIT_EH_2
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
        DC      CLK2+CDS_TIM+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_READ_EH_2

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_FG_2
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+0000+SFG2+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+0000+SFG2+SFG3+SWFG
SXMIT_FG_2
	DC	$00F021			; Transmit A/D data to host
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
        DC      CLK2+CDS_TIM+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_READ_FG_2

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_SPLIT_2
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+0000+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+SFG1+0000+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
SXMIT_SPLIT_2
	DC	$00F020			; Transmit A/D data to host
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
        DC      CLK2+CDS_TIM+000+0000+SEH2+0000+0000+000+0000+SFG2+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_READ_SPLIT_2

;	Bin by 3 waveforms
;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_EH_3
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+0000
	DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+0000+SFG2+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+SFG1+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+0000+SFG2+0000+0000
	DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+0000+SFG2+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+SFG1+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+0000+SFG2+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+0000+SFG2+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+SFG1+0000+SFG3+0000
SXMIT_EH_3
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
        DC      CLK2+CDS_TIM+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_READ_EH_3

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_FG_3
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+0000+SFG2+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+0000+SFG2+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+0000+SFG2+SFG3+SWFG
SXMIT_FG_3
	DC	$00F021			; Transmit A/D data to host
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
        DC      CLK2+CDS_TIM+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_READ_FG_3

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_SPLIT_3
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+0000+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+SFG1+0000+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+0000+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+SFG1+0000+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
SXMIT_SPLIT_3
	DC	$00F020			; Transmit A/D data to host
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
        DC      CLK2+CDS_TIM+000+0000+SEH2+0000+0000+000+0000+SFG2+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_READ_SPLIT_3

;	Bin by 4 waveforms
;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_EH_4
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+0000
	DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+0000+SFG2+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+SFG1+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+0000+SFG2+0000+0000
	DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+0000+SFG2+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+SFG1+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+0000+SFG2+0000+0000
	DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+0000+SFG2+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+SFG1+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+0000+SFG2+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+0000+SFG2+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+SFG1+0000+SFG3+0000
SXMIT_EH_4
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
        DC      CLK2+CDS_TIM+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_READ_EH_4

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_FG_4
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+0000+SFG2+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+0000+SFG2+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+0000+SFG2+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+0000+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+0000+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+0000+000+0000+SFG2+SFG3+SWFG
SXMIT_FG_4
	DC	$00F021			; Transmit A/D data to host
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
        DC      CLK2+CDS_TIM+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_READ_FG_4

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_SPLIT_4
        DC      CLK2+R_DELAY+REH+SEH1+SEH2+0000+0000+RFG+SFG1+SFG2+0000+0000
        DC      VIDEO+INT_INIT		; Change nearly everything
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+0000+000+SFG1+0000+0000+0000
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+0000+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+SFG1+0000+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+0000+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+SFG1+0000+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+0000+SWEH+000+0000+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+SWEH+000+SFG1+SFG2+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+0000+SWEH+000+SFG1+0000+0000+SWFG
        DC      CLK2+R_DELAY+000+SEH1+0000+SEH3+SWEH+000+SFG1+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+0000+SEH3+SWEH+000+0000+0000+SFG3+SWFG
        DC      CLK2+R_DELAY+000+0000+SEH2+SEH3+SWEH+000+0000+SFG2+SFG3+SWFG
SXMIT_SPLIT_4
	DC	$00F020			; Transmit A/D data to host
	DC	VIDEO+INT_RSTOFF	; Stop resetting integrator
	DC	VIDEO+INT_TIM+INT_MINUS	; Integrate reset level
	DC	VIDEO+INT_STOP		; Stop Integrate
        DC      CLK2+CDS_TIM+000+0000+SEH2+0000+0000+000+0000+SFG2+0000+0000
	DC	VIDEO+INT_TIM+INT_PLUS	; Integrate signal level
	DC	VIDEO+ADC_TIM+INT_SMPL	; Stop integrate, A/D is sampling
        DC      CLK2+R_DELAY+000+SEH1+SEH2+0000+0000+000+SFG1+SFG2+0000+0000
END_SERIAL_READ_SPLIT_4
