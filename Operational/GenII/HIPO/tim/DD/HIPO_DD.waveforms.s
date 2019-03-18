; Waveform tables and definitions for the e2v DD 1K sq. frame 
; transfer CCD for HIPO.
; 

; CCD clock voltage definitions
VIDEO		EQU	$000000	; Video processor board select = 0
CLK2		EQU	$002000	; Clock driver board select = 2
CLK3		EQU	$003000	; Clock driver board select = 3 
CLK_ZERO 	EQU	$000800	; Zero volts on clock driver line
BIAS_ZERO	EQU	$000800 ;  

; Select INT_TIM by value of INTTIM_SETTING macro defined in Makefile or
; environment. If one of the values indicated is not set, INT_TIM will be
; undefined and the assemble will fail.
; see the Confluence page for gwaves timing board port, 
; at the end of dated entry for July 1 2010
; http://jumar.lowell.edu/confluence/display/GWAVES/Notes+On+Port+of++Timing+Board+DSP+to+Gen-iii+GWAVES+CCD
;
; Please keep the tooltip commentn remarks as and where they are, 
; right before the EQU

	IF      @SCP("INTTIM_SETTING","04")
; 0.85 us/px - use gain 4.75, experimental
; <tooltip comment1> Very fast, noisy, full well OK
INT_TIM		EQU	$040000	
	ENDIF
	IF      @SCP("INTTIM_SETTING","08")
; 1.0 us/px - use gain 4.75, doesn't clip - use gain 9.5, clips @ PRAM
; <tooltip comment1> Fast, full well OK
INT_TIM		EQU	$080000	
	ENDIF
	IF      @SCP("INTTIM_SETTING","15")
; 1.5 us/px - use gain 9.5, clips @ ADC
; <tooltip comment1> Fast, noise < 6e, clips at ADC
INT_TIM		EQU	$150000	
	ENDIF
	IF      @SCP("INTTIM_SETTING","1D")
; 1.8 us/px - use gain 4.75, best overall
; <tooltip comment1> Covers full dynamic range of CCD
INT_TIM		EQU	$1D0000	
	ENDIF
	IF      @SCP("INTTIM_SETTING","47")
; 3.5 us/px - use gain 2, slower & quieter
; <tooltip comment1> Covers full dynamic range of CCD
INT_TIM		EQU	$470000	
	ENDIF
	IF      @SCP("INTTIM_SETTING","6D")
; 5.0 us/px - use gain 2 or 4.75, clips @ ADC
; <tooltip comment1> Slow, very low noise, clips at ADC
INT_TIM		EQU	$6D0000	
	ENDIF
	IF      @SCP("INTTIM_SETTING","92")
; 6.5 us/px - use gain 1, slower & quieter
; <tooltip comment1> Covers full dynamic range of CCD
INT_TIM		EQU	$920000	
	ENDIF
;ADC_TIM		EQU	$0C0000	; Slow ADC TIME
; <tooltip comment1> Not a standard DSP
ADC_TIM		EQU	$000000 ; Fast ADC TIME

; Delay numbers in clocking
; Select SI_DELAY by value of SIDELAY_SETTING macro defined in Makefile or
; environment. If one of the values indicated is not set, SI_DELAY will be
; undefined and the assemble will fail.
; see the Confluence page for gwaves timing board port, 
; at the end of dated entry for July 1 2010
; http://jumar.lowell.edu/confluence/display/GWAVES/Notes+On+Port+of++Timing+Board+DSP+to+Gen-iii+GWAVES+CCD
; Please keep the tooltip commentn remarks as and where they are, 
; right before the EQU

	IF      @SCP("SIDELAY_SETTING","82")
; Fast Storage/Image Delay
; <tooltip comment2> Very low light and moderately unflattenable
SI_DELAY	EQU	$820000 
	ENDIF
	IF      @SCP("SIDELAY_SETTING","84")
; Fast Storage/Image Delay
; <tooltip comment2> Very low light and moderately unflattenable
SI_DELAY	EQU	$840000 
	ENDIF
	IF      @SCP("SIDELAY_SETTING","85")
; Fast Storage/Image Delay
; <tooltip comment2> Very low light and moderately unflattenable
SI_DELAY	EQU	$850000 
	ENDIF
	IF      @SCP("SIDELAY_SETTING","86")
; Fast Storage/Image Delay
; <tooltip comment2> Very low light and moderately unflattenable
SI_DELAY	EQU	$860000 
	ENDIF
	IF      @SCP("SIDELAY_SETTING","89")
; 
; <tooltip comment2> OK for moderate flats
SI_DELAY	EQU	$890000 
	ENDIF
	IF      @SCP("SIDELAY_SETTING","8B")
; 
; <tooltip comment2> OK for full well spots but not flats
SI_DELAY	EQU	$8B0000 
	ENDIF
	IF      @SCP("SIDELAY_SETTING","8C")
; 
; <tooltip comment2> OK for full well flats
SI_DELAY	EQU	$8C0000 
	ENDIF
	IF      @SCP("SIDELAY_SETTING","C0")
; Started with 0x36 Parallel clock delay
; <tooltip comment2> Not a standard DSP
SI_DELAY	EQU	$C00000 
	ENDIF

; Select R_DELAY by value of RDELAY_SETTING macro defined in Makefile or
; environment. If one of the values indicated is not set, R_DELAY will be
; undefined and the assemble will fail.
; see the Confluence page for gwaves timing board port, 
; at the end of dated entry for July 1 2010
; http://jumar.lowell.edu/confluence/display/GWAVES/Notes+On+Port+of++Timing+Board+DSP+to+Gen-iii+GWAVES+CCD

	IF      @SCP("RDELAY_SETTING","00")
; Fast serial register transfer delay
R_DELAY		EQU	$000000	
	ENDIF
	IF      @SCP("RDELAY_SETTING","08")
; Serial register transfer delay
R_DELAY		EQU	$080000	
	ENDIF

SKIP_DELAY 	EQU	$000000	; Serial register skipping delay

; DEEP DEPLETION LEVELS
; These are available for use during integration & readout
; FIX!!- Old New Data Sheet remarks are from ccd47.
; Clock voltages in volts 			Old 	New	Data Sheet
RG_HI_D	EQU	+9.0	; Reset			 1.5	 3.0	 4
RG_LO_D	EQU	-3.0	;  			-3.0	-9.0	-8
R_HI_D	EQU	+8.0	; Serials 		 4.65	 4.5	 2
R_LO_D	EQU	-2.0	; 			-6.6	-6.5	-8
SI_HI_D	EQU	+9.0	; Parallels 		 3.7	 4.0	 4
SI_LO_D	EQU     -3.0	; 			-6.9	-7.0	-8
DG_HI_D	EQU	+9.0	; Dump Gate  
DG_LO_D	EQU	-3.0	;					-8

; FIX!!- Old New Data Sheet remarks are from ccd47.
; DC Bias voltages in volts			Old	New	Data Sheet
VODL_D	EQU	27.0	; Output Drain Left	25.1	24	21
VODR_D	EQU	27.0	; Output Drain Right	25.1	24
VRDL_D	EQU	15.00	; Reset Drain Left	12.2	11	10
VRDR_D	EQU	15.00	; Reset Drain Right			
VOG_D	EQU	0.0 	; Output Gate		-1.2	-3	-5
VABG_D	EQU	-3.0	; Anti-blooming gate	-5.0	-5	-8

; We have these for DD levels only since that's the only imaging level
; these give 5k for the pedestal
;OFFSET	EQU	$700		
;OFFSET0	EQU	$700	; Left Side Of Frame
;OFFSET1	EQU	$6EF	; Right Side Of Frame  

; these give 1k for the pedestal
OFFSET	EQU	$A98		
OFFSET0	EQU	$A98	; Left Side Of Frame
OFFSET1	EQU	$A87	; Right Side Of Frame  

; INVERTED LEVELS
; These are available for use during startup & idling
; FIX!!- Old New Data Sheet remarks are from ccd47.
; Clock voltages in volts 			Old 	New	Data Sheet
RG_HI_I	EQU	+2.5	; Reset			 1.5	 3.0	 4
RG_LO_I	EQU	-9.5	;  			-3.0	-9.0	-8
R_HI_I	EQU	+1.5	; Serials 		 4.65	 4.5	 2
R_LO_I	EQU	-8.5	; 			-6.6	-6.5	-8
SI_HI_I	EQU	+2.5	; Parallels 		 3.7	 4.0	 4
SI_LO_I	EQU     -9.5	; 			-6.9	-7.0	-8
DG_HI_I	EQU	+2.5	; Dump Gate  
DG_LO_I	EQU	-9.5	;					-8

; FIX!!- Old New Data Sheet remarks are from ccd47.
; DC Bias voltages in volts			Old	New	Data Sheet
VODL_I	EQU	20.5	; Output Drain Left	25.1	24	21
VODR_I	EQU	20.5	; Output Drain Right	25.1	24
VRDL_I	EQU	9.00	; Reset Drain Left	12.2	11	10
VRDR_I	EQU	9.00	; Reset Drain Right			
VOG_I	EQU	-6.5 	; Output Gate		-1.2	-3	-5
VABG_I	EQU	-9.5	; Anti-blooming gate	-5.0	-5	-8

; TRANSITION LEVELS
; These are available for the sole purpose of buffering voltage swings
; FIX!!- Old New Data Sheet remarks are from ccd47.
; Clock voltages in volts 			Old 	New	Data Sheet
RG_HI_T	EQU	+2.5	; Reset			 1.5	 3.0	 4
RG_LO_T	EQU	-3.0	;  			-3.0	-9.0	-8
R_HI_T	EQU	+1.5	; Serials 		 4.65	 4.5	 2
R_LO_T	EQU	-2.0	; 			-6.6	-6.5	-8
SI_HI_T	EQU	+2.5	; Parallels 		 3.7	 4.0	 4
SI_LO_T	EQU     -3.0	; 			-6.9	-7.0	-8
DG_HI_T	EQU	+2.5	; Dump Gate  
DG_LO_T	EQU	-3.0	;					-8

; FIX!!- Old New Data Sheet remarks are from ccd47.
; DC Bias voltages in volts			Old	New	Data Sheet
VODL_T	EQU	20.5	; Output Drain Left	25.1	24	21
VODR_T	EQU	20.5	; Output Drain Right	25.1	24
VRDL_T	EQU	9.00	; Reset Drain Left	12.2	11	10
VRDR_T	EQU	9.00	; Reset Drain Right			
VOG_T	EQU	0.0 	; Output Gate		-1.2	-3	-5
VABG_T	EQU	-3.0	; Anti-blooming gate	-5.0	-5	-8

; Define switch state bits for the lower CCD clock driver bank CLK2
H1L	EQU	1	; Serial #1 Left, Pin 1 - clock 0
H2L	EQU	2	; Serial #2 Left, Pin 2 - clock 1
H3L	EQU	4	; Serial #3 Left, Pin 3 - clock 2
H1R	EQU	8	; Serial #1 Right, Pin 4 - clock 3
H2R	EQU	$10	; Serial #2 Right, Pin 5 - clock 4
H3R	EQU	$20	; Serial #2 Right, Pin 6 - clock 5
RGL	EQU	$100	; Reset Gate Left, Pin 9 - clock 8
RGR	EQU	$200	; Reset Gate Right, Pin 10 - clock 9
	
; Pins 9-12 are not used

; Define switch state bits for the upper CCD clock driver bank CLK3
I1	EQU	1	; Image, phase #1, Pin 13 - clock 12
I2	EQU	2	; Image, phase #2, Pin 14 - clock 13
I3	EQU	4	; Image, phase #3, Pin 15 - clock 14
S1	EQU	8	; Storage, phase #1, Pin 16 - clock 15
S2	EQU	$10	; Storage, phase #2, Pin 17 - clock 16
S3	EQU	$20	; Storage, phase #3, Pin 18 - clock 17
DG	EQU	$100	; Dump Gate, Pin 34 - clock 20

;  ***  Definitions for Y: memory waveform tables  *****
; Clock only the Storage clocks : S1->S2->S3
S_PARALLEL
	DC	END_S_PARALLEL-S_PARALLEL-2
        DC      VIDEO+%0011000          ; Reset integ. and DC restore
	DC	CLK2+00000000+RGL+RGR+H1L+H1R+H2L+H2R+000+000
;	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00	; Probably not needed
	DC	CLK3+SI_DELAY+I1+00+00+S1+S2+00
	DC	CLK3+SI_DELAY+I1+00+00+00+S2+00
	DC	CLK3+SI_DELAY+I1+00+00+00+S2+S3
	DC	CLK3+SI_DELAY+I1+00+00+00+00+S3
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+S3
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00
END_S_PARALLEL

; Reverse clock only the Storage clocks : S1->S3->S2->S1
; Use in pipelined occultation mode
R_S_PARALLEL
	DC	END_R_S_PARALLEL-R_S_PARALLEL-2
	DC	CLK2+00000000+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+S3
	DC	CLK3+SI_DELAY+I1+00+00+00+00+S3
	DC	CLK3+SI_DELAY+I1+00+00+00+S2+S3
	DC	CLK3+SI_DELAY+I1+00+00+00+S2+00
	DC	CLK3+SI_DELAY+I1+00+00+S1+S2+00
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00
END_R_S_PARALLEL

; Clock only the Storage clocks : S1->S2->S3 with DG
S_CLEAR
	DC	END_S_CLEAR-S_CLEAR-2
        DC      VIDEO+%0011000          ; Reset integ. and DC restore
	DC	CLK2+00000000+RGL+RGR+H1L+H1R+H2L+H2R+000+000
;	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00	; Probably not needed
	DC	CLK3+SI_DELAY+I1+00+00+S1+S2+00+DG
	DC	CLK3+SI_DELAY+I1+00+00+00+S2+00+DG
	DC	CLK3+SI_DELAY+I1+00+00+00+S2+S3+DG
	DC	CLK3+SI_DELAY+I1+00+00+00+00+S3+DG
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+S3+DG
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00+DG
END_S_CLEAR	
; 2 microsecond delay before readout starts may be needed here
;	DC	CLK3+$600000+I1+00+00+S1+00+0000

; Clock both the Storage and Image clocks : I1->I2->I3 and S1->S2->S3
IS_PARALLEL
	DC	END_IS_PARALLEL-IS_PARALLEL-2
        DC      VIDEO+%0011000          ; Reset integ. and DC restore
	DC	CLK2+00000000+RGL+RGR+H1L+H1R+H2L+H2R+000+000
;	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00	; Probably not needed
	DC	CLK3+SI_DELAY+I1+I2+00+S1+S2+00
	DC	CLK3+SI_DELAY+00+I2+00+00+S2+00
	DC	CLK3+SI_DELAY+00+I2+I3+00+S2+S3
	DC	CLK3+SI_DELAY+00+00+I3+00+00+S3
	DC	CLK3+SI_DELAY+I1+00+I3+S1+00+S3
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00
END_IS_PARALLEL

; Clock both the Storage and Image clocks : I1->I2->I3 and S1->S2->S3
IS_CLEAR
	DC	IS_CLEAR_END-IS_CLEAR-2
        DC      VIDEO+%0011000          ; Reset integ. and DC restore
	DC	CLK2+00000000+RGL+RGR+H1L+H1R+H2L+H2R+000+000
;	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00+00 ; Probably not needed
	DC	CLK3+SI_DELAY+I1+I2+00+S1+S2+00+DG
	DC	CLK3+SI_DELAY+00+I2+00+00+S2+00+DG
	DC	CLK3+SI_DELAY+00+I2+I3+00+S2+S3+DG
 	DC	CLK3+SI_DELAY+00+00+I3+00+00+S3+DG
 	DC	CLK3+SI_DELAY+I1+00+I3+S1+00+S3+DG
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00+DG
IS_CLEAR_END

DUMP_SERIAL
	DC	END_DUMP_SERIAL-DUMP_SERIAL-2
	DC	CLK2+SI_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00+DG
	DC	CLK2+SI_DELAY+RGL+RGR+000+000+000+000+000+000
	DC	CLK3+SI_DELAY+I1+00+00+S1+00+00+00
	DC	CLK2+SI_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
END_DUMP_SERIAL
	COMMENT	*
; Michigan AIMO clocking - this is vestigial and commented out
PARALLEL DC	PARALLEL_CLEAR-PARALLEL-2
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
	DC	END_SERIAL_IDLE-SERIAL_IDLE-2
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
	DC	CLK2+$030000+000+000+000+H1R+H2L+000+000+000
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
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

INITIAL_CLOCK_SPLIT                ; Both amplifiers
	DC      END_INITIAL_CLOCK_SPLIT-INITIAL_CLOCK_SPLIT-2
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	$00F020			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
END_INITIAL_CLOCK_SPLIT

INITIAL_CLOCK_RIGHT         ; Serial right, Swap S1L and S2L
	DC      END_INITIAL_CLOCK_RIGHT-INITIAL_CLOCK_RIGHT-2
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	$00F021			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
END_INITIAL_CLOCK_RIGHT

INITIAL_CLOCK_LEFT ; Serial left, Swap S1R and S2R
	DC      END_INITIAL_CLOCK_LEFT-INITIAL_CLOCK_LEFT-2
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
END_INITIAL_CLOCK_LEFT
        
SERIAL_CLOCK_SPLIT                ; Both amplifiers
	DC      END_SERIAL_CLOCK_SPLIT-SERIAL_CLOCK_SPLIT-2
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
END_SERIAL_CLOCK_SPLIT

SERIAL_CLOCK_RIGHT         ; Serial right, Swap S1L and S2L
	DC      END_SERIAL_CLOCK_RIGHT-SERIAL_CLOCK_RIGHT-2
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
END_SERIAL_CLOCK_RIGHT

SERIAL_CLOCK_LEFT ; Serial left, Swap S1R and S2R
	DC      END_SERIAL_CLOCK_LEFT-SERIAL_CLOCK_LEFT-2
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
END_SERIAL_CLOCK_LEFT
        
; need two if you want to call CLOCK
DCRST_LAST
	DC	 DCRST_LAST_END-DCRST_LAST-2
        DC      VIDEO+%0011000          ; Reset integ. and DC restore
        DC      VIDEO+%0011000          ; Reset integ. and DC restore
DCRST_LAST_END

VIDEO_PROCESS   
        DC      END_VIDEO_PROCESS-VIDEO_PROCESS-2
CCLK_1  ; The following line is overwritten by timmisc.s
	DC	CLK2+$030000+000+000+H1L+H1R+000+000+000+000
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
CCLK_2  ; The following line is overwritten by timmisc.s, but is correct as is.
; Actually it shouldn't be needed so comment it out.
;	DC      CLK2+S_DLY+S1R+S2R+000+S1L+S2L+000+000+000+000+000
END_VIDEO_PROCESS

; Starting Y: address of circular waveforms for no-overhead access
STRT_CIR EQU	$C0
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

; This is an area to copy in the serial fast binned waveforms from high Y memory
; It is 0x28 = 40 locations long, enough to put in a binned-by-five waveform
;	     xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+000+000+H2L+H2R+H3L+H3R
SXMIT
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
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
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+ADC_TIM+%0011011	; Stop integrate, A/D is sampling
END_SERIAL

; Serial clocking waveform for skipping
	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR+$28,Y:STRT_CIR+$28		; Download address
	ELSE
	ORG     Y:STRT_CIR+$28,P:ROM_DISP+$28
	ENDIF

; There are three serial skip waveforms that must all be the same length
SERIAL_SKIP_LEFT
;	DC	END_SERIAL_SKIP_LEFT-SERIAL_SKIP_LEFT-2
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
END_SERIAL_SKIP_LEFT

	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR+$30,Y:STRT_CIR+$30		; Download address
	ELSE
	ORG     Y:STRT_CIR+$30,P:ROM_DISP+$30
	ENDIF

SERIAL_SKIP_RIGHT
;	DC	END_SERIAL_SKIP_RIGHT-SERIAL_SKIP_RIGHT-2
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
END_SERIAL_SKIP_RIGHT

	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:STRT_CIR+$38,Y:STRT_CIR+$38		; Download address
	ELSE
	ORG     Y:STRT_CIR+$38,P:ROM_DISP+$38
	ENDIF

SERIAL_SKIP_SPLIT
;	DC	END_SERIAL_SKIP_SPLIT-SERIAL_SKIP_SPLIT-2
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
END_SERIAL_SKIP_SPLIT

; Put all the following code in SRAM.
	IF	@SCP("DOWNLOAD","HOST")
	ORG	Y:$100,Y:$100				; Download address
	ELSE
	ORG	Y:$100,P:DAC_DISP
	ENDIF

; Initialization of clock driver and video processor DACs and switches
; for DD levels used during integration & readout
DACS_DD	DC	END_DACS_DD-DACS_DD-1
	DC	(CLK2<<8)+(0<<14)+@CVI((R_HI_D+10.0)/20.0*4095)		; S1 Left High, pin 1
	DC	(CLK2<<8)+(1<<14)+@CVI((R_LO_D+10.0)/20.0*4095)		; S1 Left Low
	DC	(CLK2<<8)+(2<<14)+@CVI((R_HI_D+10.0)/20.0*4095)		; S2 Left Right High, pin 2
	DC	(CLK2<<8)+(3<<14)+@CVI((R_LO_D+10.0)/20.0*4095)		; S2 Left Low
	DC	(CLK2<<8)+(4<<14)+@CVI((R_HI_D+10.0)/20.0*4095)		; S3 Left High, pin 3
	DC	(CLK2<<8)+(5<<14)+@CVI((R_LO_D+10.0)/20.0*4095)		; S3 Left Low
	DC	(CLK2<<8)+(6<<14)+@CVI((R_HI_D+10.0)/20.0*4095)		; S1 Right High, pin 4
	DC	(CLK2<<8)+(7<<14)+@CVI((R_LO_D+10.0)/20.0*4095)		; S1 Right Low
	DC	(CLK2<<8)+(8<<14)+@CVI((R_HI_D+10.0)/20.0*4095)		; S2 Right High, pin 5
	DC	(CLK2<<8)+(9<<14)+@CVI((R_LO_D+10.0)/20.0*4095)		; S2 Right Low
	DC	(CLK2<<8)+(10<<14)+@CVI((R_HI_D+10.0)/20.0*4095)		; S3 Right High, pin 6
	DC	(CLK2<<8)+(11<<14)+@CVI((R_LO_D+10.0)/20.0*4095)		; S3 Right Low
	DC	(CLK2<<8)+(12<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused High, pin 7
	DC	(CLK2<<8)+(13<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused Low
	DC	(CLK2<<8)+(14<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused High, pin 8
	DC	(CLK2<<8)+(15<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused Low
	DC	(CLK2<<8)+(16<<14)+@CVI((RG_HI_D+10.0)/20.0*4095) 	; RG Left High, pin 9
	DC	(CLK2<<8)+(17<<14)+@CVI((RG_LO_D+10.0)/20.0*4095) 	; RG Left Low
	DC	(CLK2<<8)+(18<<14)+@CVI((RG_HI_D+10.0)/20.0*4095) 	; RG Right High, pin 10
	DC	(CLK2<<8)+(19<<14)+@CVI((RG_LO_D+10.0)/20.0*4095) 	; RG Rightd Low
	DC	(CLK2<<8)+(20<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 11
	DC	(CLK2<<8)+(21<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(22<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 12
	DC	(CLK2<<8)+(23<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(24<<14)+@CVI((SI_HI_D+10.0)/20.0*4095)	; I1 High, pin 13
	DC	(CLK2<<8)+(25<<14)+@CVI((SI_LO_D+10.0)/20.0*4095)		; I1 Low
	DC	(CLK2<<8)+(26<<14)+@CVI((SI_HI_D+10.0)/20.0*4095)		; I2 High, pin 14
	DC	(CLK2<<8)+(27<<14)+@CVI((SI_LO_D+10.0)/20.0*4095)		; I2 Low
	DC	(CLK2<<8)+(28<<14)+@CVI((SI_HI_D+10.0)/20.0*4095)		; I3 High, pin 15
	DC	(CLK2<<8)+(29<<14)+@CVI((SI_LO_D+10.0)/20.0*4095)		; I3 Low
	DC	(CLK2<<8)+(30<<14)+@CVI((SI_HI_D+10.0)/20.0*4095) 	; S1 High, pin 16
	DC	(CLK2<<8)+(31<<14)+@CVI((SI_LO_D+10.0)/20.0*4095) 	; S1 Low
	DC	(CLK2<<8)+(32<<14)+@CVI((SI_HI_D+10.0)/20.0*4095)		; S2 High, pin 17
	DC	(CLK2<<8)+(33<<14)+@CVI((SI_LO_D+10.0)/20.0*4095)		; S2 Low
	DC	(CLK2<<8)+(34<<14)+@CVI((SI_HI_D+10.0)/20.0*4095)		; S3 High, pin 18
	DC	(CLK2<<8)+(35<<14)+@CVI((SI_LO_D+10.0)/20.0*4095)		; S3 Low
	DC	(CLK2<<8)+(36<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused High, pin 19
	DC	(CLK2<<8)+(37<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused Low
	DC	(CLK2<<8)+(38<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 33
	DC	(CLK2<<8)+(39<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(40<<14)+@CVI((DG_HI_D+10.0)/20.0*4095) 	; DG High, pin 34
	DC	(CLK2<<8)+(41<<14)+@CVI((DG_LO_D+10.0)/20.0*4095) 	; DG Low
	DC	(CLK2<<8)+(42<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 35
	DC	(CLK2<<8)+(43<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(44<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 36
	DC	(CLK2<<8)+(45<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(46<<14)+@CVI((VABG_D+10.0)/20.0*4095)		; Anti-Blooming Gate High, pin 37
	DC	(CLK2<<8)+(47<<14)+@CVI((VABG_D+10.0)/20.0*4095)		; Anti-Blooming Gate Low

; Set gain and integrator speed
	DC	$0c3fdd			; Gain, speed

;	DC	$0c3f77			; Gain x1, fast integ speed, board #0
;	DC	$0c3fbb			; Gain x2, fast integ speed, board #0
;	DC	$0c3fdd			; Gain x4.75, fast integ speed, board #0
;	DC	$0c3fee			; Gain x9.50, fast integ speed, board #0
;	DC	$0c3cee			; Gain x9.50, slow integ speed, board #0

; Input offset voltages for DC coupling. Target is U4#6 = 24 volts
	DC	$0c0800			; Input offset, ch. A
	DC	$0c8800			; Input offset, ch. B

; Output offset voltages
	DC	$0c4000+OFFSET0 	; Output video offset, ch. A
	DC	$0cc000+OFFSET1		; Output video offset, ch. B

; Output and reset drain DC bias voltages
	DC	$0d0000+@CVI((VODL_D-7.50)/22.5*4095)	; VODL pin #1
	DC	$0d4000+@CVI((VODR_D-7.50)/22.5*4095)	; VODR pin #2
	DC	$0d8000+@CVI((VRDL_D-5.00)/15.0*4095)	; VRDL pin #3
	DC	$0dc000+@CVI((VRDR_D-5.00)/15.0*4095)	; VRDR pin #4


; Output and anti-blooming gates
	DC	$0f0000+BIAS_ZERO			; Unused pin #9
	DC	$0f4000+BIAS_ZERO			; Unused pin #10
	DC	$0f8000+@CVI((VOG_D+10.0)/20.0*4095)	; Unused pin #11
	DC	$0fc000+@CVI((VABG_D+10.0)/20.0*4095)			; Unused pin #12
END_DACS_DD


; Initialization of clock driver and video processor DACs and switches
; for Inverted levels used during startup & idling
DACS_INV	DC	END_DACS_INV-DACS_INV-1
	DC	(CLK2<<8)+(0<<14)+@CVI((R_HI_I+10.0)/20.0*4095)		; S1 Left High, pin 1
	DC	(CLK2<<8)+(1<<14)+@CVI((R_LO_I+10.0)/20.0*4095)		; S1 Left Low
	DC	(CLK2<<8)+(2<<14)+@CVI((R_HI_I+10.0)/20.0*4095)		; S2 Left Right High, pin 2
	DC	(CLK2<<8)+(3<<14)+@CVI((R_LO_I+10.0)/20.0*4095)		; S2 Left Low
	DC	(CLK2<<8)+(4<<14)+@CVI((R_HI_I+10.0)/20.0*4095)		; S3 Left High, pin 3
	DC	(CLK2<<8)+(5<<14)+@CVI((R_LO_I+10.0)/20.0*4095)		; S3 Left Low
	DC	(CLK2<<8)+(6<<14)+@CVI((R_HI_I+10.0)/20.0*4095)		; S1 Right High, pin 4
	DC	(CLK2<<8)+(7<<14)+@CVI((R_LO_I+10.0)/20.0*4095)		; S1 Right Low
	DC	(CLK2<<8)+(8<<14)+@CVI((R_HI_I+10.0)/20.0*4095)		; S2 Right High, pin 5
	DC	(CLK2<<8)+(9<<14)+@CVI((R_LO_I+10.0)/20.0*4095)		; S2 Right Low
	DC	(CLK2<<8)+(10<<14)+@CVI((R_HI_I+10.0)/20.0*4095)		; S3 Right High, pin 6
	DC	(CLK2<<8)+(11<<14)+@CVI((R_LO_I+10.0)/20.0*4095)		; S3 Right Low
	DC	(CLK2<<8)+(12<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused High, pin 7
	DC	(CLK2<<8)+(13<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused Low
	DC	(CLK2<<8)+(14<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused High, pin 8
	DC	(CLK2<<8)+(15<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused Low
	DC	(CLK2<<8)+(16<<14)+@CVI((RG_HI_I+10.0)/20.0*4095) 	; RG Left High, pin 9
	DC	(CLK2<<8)+(17<<14)+@CVI((RG_LO_I+10.0)/20.0*4095) 	; RG Left Low
	DC	(CLK2<<8)+(18<<14)+@CVI((RG_HI_I+10.0)/20.0*4095) 	; RG Right High, pin 10
	DC	(CLK2<<8)+(19<<14)+@CVI((RG_LO_I+10.0)/20.0*4095) 	; RG Rightd Low
	DC	(CLK2<<8)+(20<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 11
	DC	(CLK2<<8)+(21<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(22<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 12
	DC	(CLK2<<8)+(23<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(24<<14)+@CVI((SI_HI_I+10.0)/20.0*4095)	; I1 High, pin 13
	DC	(CLK2<<8)+(25<<14)+@CVI((SI_LO_I+10.0)/20.0*4095)		; I1 Low
	DC	(CLK2<<8)+(26<<14)+@CVI((SI_HI_I+10.0)/20.0*4095)		; I2 High, pin 14
	DC	(CLK2<<8)+(27<<14)+@CVI((SI_LO_I+10.0)/20.0*4095)		; I2 Low
	DC	(CLK2<<8)+(28<<14)+@CVI((SI_HI_I+10.0)/20.0*4095)		; I3 High, pin 15
	DC	(CLK2<<8)+(29<<14)+@CVI((SI_LO_I+10.0)/20.0*4095)		; I3 Low
	DC	(CLK2<<8)+(30<<14)+@CVI((SI_HI_I+10.0)/20.0*4095) 	; S1 High, pin 16
	DC	(CLK2<<8)+(31<<14)+@CVI((SI_LO_I+10.0)/20.0*4095) 	; S1 Low
	DC	(CLK2<<8)+(32<<14)+@CVI((SI_HI_I+10.0)/20.0*4095)		; S2 High, pin 17
	DC	(CLK2<<8)+(33<<14)+@CVI((SI_LO_I+10.0)/20.0*4095)		; S2 Low
	DC	(CLK2<<8)+(34<<14)+@CVI((SI_HI_I+10.0)/20.0*4095)		; S3 High, pin 18
	DC	(CLK2<<8)+(35<<14)+@CVI((SI_LO_I+10.0)/20.0*4095)		; S3 Low
	DC	(CLK2<<8)+(36<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused High, pin 19
	DC	(CLK2<<8)+(37<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused Low
	DC	(CLK2<<8)+(38<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 33
	DC	(CLK2<<8)+(39<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(40<<14)+@CVI((DG_HI_I+10.0)/20.0*4095) 	; DG High, pin 34
	DC	(CLK2<<8)+(41<<14)+@CVI((DG_LO_I+10.0)/20.0*4095) 	; DG Low
	DC	(CLK2<<8)+(42<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 35
	DC	(CLK2<<8)+(43<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(44<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 36
	DC	(CLK2<<8)+(45<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(46<<14)+@CVI((VABG_I+10.0)/20.0*4095)		; Anti-Blooming Gate High, pin 37
	DC	(CLK2<<8)+(47<<14)+@CVI((VABG_I+10.0)/20.0*4095)		; Anti-Blooming Gate Low

; Set gain and integrator speed
	DC	$0c3fdd			; Gain, speed

;	DC	$0c3f77			; Gain x1, fast integ speed, board #0
;	DC	$0c3fbb			; Gain x2, fast integ speed, board #0
;	DC	$0c3fdd			; Gain x4.75, fast integ speed, board #0
;	DC	$0c3fee			; Gain x9.50, fast integ speed, board #0
;	DC	$0c3cee			; Gain x9.50, slow integ speed, board #0

; Input offset voltages for DC coupling. Target is U4#6 = 24 volts
	DC	$0c0800			; Input offset, ch. A
	DC	$0c8800			; Input offset, ch. B

; Output offset voltages
	DC	$0c4000+OFFSET0 	; Output video offset, ch. A
	DC	$0cc000+OFFSET1		; Output video offset, ch. B

; Output and reset drain DC bias voltages
	DC	$0d0000+@CVI((VODL_I-7.50)/22.5*4095)	; VODL pin #1
	DC	$0d4000+@CVI((VODR_I-7.50)/22.5*4095)	; VODR pin #2
	DC	$0d8000+@CVI((VRDL_I-5.00)/15.0*4095)	; VRDL pin #3
	DC	$0dc000+@CVI((VRDR_I-5.00)/15.0*4095)	; VRDR pin #4


; Output and anti-blooming gates
	DC	$0f0000+BIAS_ZERO			; Unused pin #9
	DC	$0f4000+BIAS_ZERO			; Unused pin #10
	DC	$0f8000+@CVI((VOG_I+10.0)/20.0*4095)	; Unused pin #11
	DC	$0fc000+@CVI((VABG_I+10.0)/20.0*4095)			; Unused pin #12
END_DACS_INV


; Initialization of clock driver and video processor DACs and switches
; for Transitions levels used moving to or from the DD levels
DACS_TRANS	DC	END_DACS_TRANS-DACS_TRANS-1
	DC	(CLK2<<8)+(0<<14)+@CVI((R_HI_T+10.0)/20.0*4095)		; S1 Left High, pin 1
	DC	(CLK2<<8)+(1<<14)+@CVI((R_LO_T+10.0)/20.0*4095)		; S1 Left Low
	DC	(CLK2<<8)+(2<<14)+@CVI((R_HI_T+10.0)/20.0*4095)		; S2 Left Right High, pin 2
	DC	(CLK2<<8)+(3<<14)+@CVI((R_LO_T+10.0)/20.0*4095)		; S2 Left Low
	DC	(CLK2<<8)+(4<<14)+@CVI((R_HI_T+10.0)/20.0*4095)		; S3 Left High, pin 3
	DC	(CLK2<<8)+(5<<14)+@CVI((R_LO_T+10.0)/20.0*4095)		; S3 Left Low
	DC	(CLK2<<8)+(6<<14)+@CVI((R_HI_T+10.0)/20.0*4095)		; S1 Right High, pin 4
	DC	(CLK2<<8)+(7<<14)+@CVI((R_LO_T+10.0)/20.0*4095)		; S1 Right Low
	DC	(CLK2<<8)+(8<<14)+@CVI((R_HI_T+10.0)/20.0*4095)		; S2 Right High, pin 5
	DC	(CLK2<<8)+(9<<14)+@CVI((R_LO_T+10.0)/20.0*4095)		; S2 Right Low
	DC	(CLK2<<8)+(10<<14)+@CVI((R_HI_T+10.0)/20.0*4095)		; S3 Right High, pin 6
	DC	(CLK2<<8)+(11<<14)+@CVI((R_LO_T+10.0)/20.0*4095)		; S3 Right Low
	DC	(CLK2<<8)+(12<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused High, pin 7
	DC	(CLK2<<8)+(13<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused Low
	DC	(CLK2<<8)+(14<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused High, pin 8
	DC	(CLK2<<8)+(15<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused Low
	DC	(CLK2<<8)+(16<<14)+@CVI((RG_HI_T+10.0)/20.0*4095) 	; RG Left High, pin 9
	DC	(CLK2<<8)+(17<<14)+@CVI((RG_LO_T+10.0)/20.0*4095) 	; RG Left Low
	DC	(CLK2<<8)+(18<<14)+@CVI((RG_HI_T+10.0)/20.0*4095) 	; RG Right High, pin 10
	DC	(CLK2<<8)+(19<<14)+@CVI((RG_LO_T+10.0)/20.0*4095) 	; RG Rightd Low
	DC	(CLK2<<8)+(20<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 11
	DC	(CLK2<<8)+(21<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(22<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 12
	DC	(CLK2<<8)+(23<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(24<<14)+@CVI((SI_HI_T+10.0)/20.0*4095)	; I1 High, pin 13
	DC	(CLK2<<8)+(25<<14)+@CVI((SI_LO_T+10.0)/20.0*4095)		; I1 Low
	DC	(CLK2<<8)+(26<<14)+@CVI((SI_HI_T+10.0)/20.0*4095)		; I2 High, pin 14
	DC	(CLK2<<8)+(27<<14)+@CVI((SI_LO_T+10.0)/20.0*4095)		; I2 Low
	DC	(CLK2<<8)+(28<<14)+@CVI((SI_HI_T+10.0)/20.0*4095)		; I3 High, pin 15
	DC	(CLK2<<8)+(29<<14)+@CVI((SI_LO_T+10.0)/20.0*4095)		; I3 Low
	DC	(CLK2<<8)+(30<<14)+@CVI((SI_HI_T+10.0)/20.0*4095) 	; S1 High, pin 16
	DC	(CLK2<<8)+(31<<14)+@CVI((SI_LO_T+10.0)/20.0*4095) 	; S1 Low
	DC	(CLK2<<8)+(32<<14)+@CVI((SI_HI_T+10.0)/20.0*4095)		; S2 High, pin 17
	DC	(CLK2<<8)+(33<<14)+@CVI((SI_LO_T+10.0)/20.0*4095)		; S2 Low
	DC	(CLK2<<8)+(34<<14)+@CVI((SI_HI_T+10.0)/20.0*4095)		; S3 High, pin 18
	DC	(CLK2<<8)+(35<<14)+@CVI((SI_LO_T+10.0)/20.0*4095)		; S3 Low
	DC	(CLK2<<8)+(36<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused High, pin 19
	DC	(CLK2<<8)+(37<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095)	; Unused Low
	DC	(CLK2<<8)+(38<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 33
	DC	(CLK2<<8)+(39<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(40<<14)+@CVI((DG_HI_T+10.0)/20.0*4095) 	; DG High, pin 34
	DC	(CLK2<<8)+(41<<14)+@CVI((DG_LO_T+10.0)/20.0*4095) 	; DG Low
	DC	(CLK2<<8)+(42<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 35
	DC	(CLK2<<8)+(43<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(44<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused High, pin 36
	DC	(CLK2<<8)+(45<<14)+@CVI((CLK_ZERO+10.0)/20.0*4095) 	; Unused Low
	DC	(CLK2<<8)+(46<<14)+@CVI((VABG_T+10.0)/20.0*4095)		; Anti-Blooming Gate High, pin 37
	DC	(CLK2<<8)+(47<<14)+@CVI((VABG_T+10.0)/20.0*4095)		; Anti-Blooming Gate Low

; Set gain and integrator speed
	DC	$0c3fdd			; Gain, speed

;	DC	$0c3f77			; Gain x1, fast integ speed, board #0
;	DC	$0c3fbb			; Gain x2, fast integ speed, board #0
;	DC	$0c3fdd			; Gain x4.75, fast integ speed, board #0
;	DC	$0c3fee			; Gain x9.50, fast integ speed, board #0
;	DC	$0c3cee			; Gain x9.50, slow integ speed, board #0

; Input offset voltages for DC coupling. Target is U4#6 = 24 volts
	DC	$0c0800			; Input offset, ch. A
	DC	$0c8800			; Input offset, ch. B

; Output offset voltages
	DC	$0c4000+OFFSET0 	; Output video offset, ch. A
	DC	$0cc000+OFFSET1		; Output video offset, ch. B

; Output and reset drain DC bias voltages
	DC	$0d0000+@CVI((VODL_T-7.50)/22.5*4095)	; VODL pin #1
	DC	$0d4000+@CVI((VODR_T-7.50)/22.5*4095)	; VODR pin #2
	DC	$0d8000+@CVI((VRDL_T-5.00)/15.0*4095)	; VRDL pin #3
	DC	$0dc000+@CVI((VRDR_T-5.00)/15.0*4095)	; VRDR pin #4


; Output and anti-blooming gates
	DC	$0f0000+BIAS_ZERO			; Unused pin #9
	DC	$0f4000+BIAS_ZERO			; Unused pin #10
	DC	$0f8000+@CVI((VOG_T+10.0)/20.0*4095)	; Unused pin #11
	DC	$0fc000+@CVI((VABG_T+10.0)/20.0*4095)			; Unused pin #12
END_DACS_TRANS

;	These are the 15 fast serial read waveforms for left, right, 
;	and split reads for serial binning factors from 1 to 5.

;	Unbinned waveforms
;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_LEFT_1
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+000+000+H2L+H2R+H3L+H3R
SXMIT_LEFT_1
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
	DC	CLK2+$030000+000+000+000+000+H2L+H2R+000+000
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+ADC_TIM+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_LEFT_1

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_RIGHT_1
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+H1L+H1R+000+000+H3L+H3R
SXMIT_RIGHT_1
	DC	$00F021			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
	DC	CLK2+$030000+000+000+H1L+H1R+000+000+000+000
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_RIGHT_1

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_SPLIT_1
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
SXMIT_SPLIT_1
	DC	$00F020			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
	DC	CLK2+$030000+000+000+000+H1R+H2L+000+000+000
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_SPLIT_1

; Bin by 2 waveforms
;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_LEFT_2
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+000+000+H2L+H2R+H3L+H3R
SXMIT_LEFT_2
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+$030000+000+000+000+000+H2L+H2R+000+000
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+ADC_TIM+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_LEFT_2

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_RIGHT_2
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+H1L+H1R+000+000+H3L+H3R
SXMIT_RIGHT_2
	DC	$00F021			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+$030000+000+000+H1L+H1R+000+000+000+000
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_RIGHT_2

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_SPLIT_2
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
SXMIT_SPLIT_2
	DC	$00F020			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
	DC	CLK2+$030000+000+000+000+H1R+H2L+000+000+000
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_SPLIT_2


;	Binned by 3 waveforms
;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_LEFT_3
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+000+000+H2L+H2R+H3L+H3R
SXMIT_LEFT_3
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
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
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+ADC_TIM+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_LEFT_3

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_RIGHT_3
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+H1L+H1R+000+000+H3L+H3R
SXMIT_RIGHT_3
	DC	$00F021			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
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
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_RIGHT_3

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_SPLIT_3
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
SXMIT_SPLIT_3
	DC	$00F020			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
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
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_SPLIT_3

;	Binned by 4 waveforms
;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_LEFT_4
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+000+000+H2L+H2R+H3L+H3R
SXMIT_LEFT_4
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
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
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+ADC_TIM+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_LEFT_4

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_RIGHT_4
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+H1L+H1R+000+000+H3L+H3R
SXMIT_RIGHT_4
	DC	$00F021			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
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
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_RIGHT_4

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_SPLIT_4
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
SXMIT_SPLIT_4
	DC	$00F020			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
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
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_SPLIT_4

;	Binned by 5 waveforms
;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_LEFT_5
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+000+000
	DC	CLK2+R_DELAY+000+000+H1L+H1R+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+000+000+H2L+H2R+H3L+H3R
SXMIT_LEFT_5
	DC	$00F000			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
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
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+ADC_TIM+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_LEFT_5

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_RIGHT_5
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+000+000
	DC	CLK2+R_DELAY+000+000+000+000+H2L+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+$000000+000+000+H1L+H1R+000+000+H3L+H3R
SXMIT_RIGHT_5
	DC	$00F021			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
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
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_RIGHT_5

;	xfer, A/D, integ, Pol+, Pol-, DCrestore, rst   (1 => switch open)
SERIAL_READ_SPLIT_5
	DC	CLK2+R_DELAY+RGL+RGR+H1L+H1R+H2L+H2R+000+000
	DC	VIDEO+$000000+%1110100	; Change nearly everything
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+000+000
	DC	CLK2+R_DELAY+000+000+H1L+000+000+H2R+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+000+000+000+H3L+H3R
	DC	CLK2+R_DELAY+000+000+000+H1R+H2L+000+H3L+H3R
SXMIT_SPLIT_5
	DC	$00F020			; Transmit A/D data to host
	DC	VIDEO+$000000+%1110111	; Stop resetting integrator
	DC	VIDEO+INT_TIM+%0000111	; Integrate reset level
	DC	VIDEO+$000000+%0011011	; Stop Integrate
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
	DC	VIDEO+INT_TIM+%0001011	; Integrate signal level
	DC	VIDEO+$000000+%0011011	; Stop integrate, A/D is sampling
END_SERIAL_READ_SPLIT_5

