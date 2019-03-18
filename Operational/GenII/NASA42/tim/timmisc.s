; This file is for utilities that are in common to all the timing board
;   programs, located starting at P:$200 in external SRAM


;  ****************  PROGRAM CODE IN SRAM PROGRAM SPACE    *******************
; Put all the following code in SRAM, starting at P:$200.
	IF	@SCP("DOWNLOAD","HOST")
	ORG	P:$200,P:$200	; Download address
	ELSE
	ORG	P:$200,P:APL_NUM*N_W_APL+APL_LEN ; EEPROM address
	ENDIF

; Fast clear of CCD, executed as a command
CLEAR	JSR	<CLR_CCD
	JMP     <FINISH

; Fast clear image before each exposure, executed as a subroutine.  Uses DG
CLR_CCD	DO      Y:<NPCLR,LPCLR		; Loop over number of lines in image
	MOVE    #ABCD_CLEAR_SPLIT,R0	; Address of parallel transfer waveform
	JSR     <CLOCK  		; Go clock out the CCD charge
	NOP				; Do loop restriction
LPCLR
	MOVE 	#DUMP_SERIAL,R0
	JSR	<CLOCK			; and wipe out the dregs in the SR
	MOVE	#TST_RCV,X0		; Wait for commands during exposure
	MOVE	X0,X:<IDL_ADR		;  instead of idling
	RTS

; Keep the CCD idling when not reading out
IDLE	DO      Y:<NS_CLR,IDL1     	; Loop over number of pixels per line
	MOVE    #<SERIAL_IDLE,R0 	; Serial transfer on pixel
	JSR     <CLOCK  		; Go to it
	JSR	<GET_RCV		; Check for FO or SSI commands
	JCC	<NO_COM			; Continue IDLE if no commands received
	ENDDO   			; Cancel the DO loop
	JMP     <CHK_SSI		; Go process header and command
NO_COM  NOP
IDL1
	MOVE    #ABCD_CLEAR_SPLIT,R0	; Address of parallel clocking waveform
	MOVE    R0,Y:<TESTLOC1	; HACK
	JSR     <CLOCK  		; Go clock out the CCD charge
	JMP     <IDLE

	
; Select which readouts to process
;   'SOS'  Amplifier_name  
;	Amplifier_names = '__A', '__B', '__C', '__D', '_AB', '_CD', '_BD', 'ALL'

SEL_OS	MOVE	X:(R4)+,X0		; Get amplifier(s) name
	JSR	<SELECT_OUTPUT_SOURCE
	JMP	<FINISH1

; A massive subroutine for setting all the addresses depending on the
; output source(s) selection and binning parameter.  Most of the
; waveforms are in fast Y memory (< 0xFF) but there isn't enough
; space for the fast serial binning waveforms for binning factors
; 1 through 4.  These are in high Y memory and have to be copied in.

SELECT_OUTPUT_SOURCE
; Set all the waveform addresses depending on which readout/binning mode
CMP_A	MOVE	#'__A',A		; A Amplifier = e2v H amp = Leach channel #3
	CMP	X0,A
	JNE	<CMP_B
	MOVE	X0,Y:<AMPVAL		; save the amp value
	MOVE	#ABCD_UP,A
	MOVE	A,Y:IS_PAR_CLK		; ganged parallels
	MOVE    #CD_UP,A
	MOVE    A,Y:S_PAR_CLK		; storage area parallels
	MOVE    #ABCD_CLEAR_UP,A	
	MOVE    A,Y:IS_PAR_CLR 		; Clear full CCD
	MOVE    #CD_CLEAR_UP,A		
	MOVE    A,Y:S_PAR_CLR 		; Clear storage area only
	MOVE	#SERIAL_SKIP_EH,A
	MOVE	A,Y:SERIAL_SKIP		; Now do the serials for general binning
	MOVE    #INITIAL_CLOCK_EH,A
	MOVE    A,Y:INITIAL_CLOCK
	MOVE    #SERIAL_CLOCK_EH,A
	MOVE    A,Y:SERIAL_CLOCK
	MOVE    #(CLK2+$030000+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+0000),A
	MOVE    A,Y:CCLK_1
        MOVE    #$00F063,X0		; Channel 3 only
        MOVE    X0,Y:SXMIT_VP		; Put into VIDEO_PROCESS for arbitrary binning
	MOVE	X0,Y:SXMIT_EH_1	; and into all the hard-coded binned cases in high Y
	MOVE	X0,Y:SXMIT_EH_2
	MOVE	X0,Y:SXMIT_EH_3
	MOVE	X0,Y:SXMIT_EH_4
	BCLR	#SPLIT_S,X:STATUS	; Serials not split
	BCLR	#SPLIT_P,X:STATUS	; Parallels not split
; Now go through copying in the serial read waveform if binning more than 4.
	CLR	A
	CLR	B
	MOVE	B,X:<BINBIT		; Clear BINBIT.  This is for 5 or greater
	MOVE	Y:<NSBIN,B0		; is bin factor more than 4?
	MOVE	#>4,A0
	CMP	B,A
	JLT	<CMP_END		; If binning 5 or more, don't copy.
	JSR	<SET_BINBIT		; else set BINBIT
	MOVE	#<SERIAL_READ,R7	; R7 is the destination address for all copies
TRY_1_A	JCLR	#1,X:<BINBIT,TRY_2_A
;	MOVE	#1,A0			; HACK
;	MOVE	A0,Y:<INTERVAL		; HACK
	MOVE	#SERIAL_READ_EH_1,R0	; Here if H amp, bin by 1
	MOVE	#(END_SERIAL_READ_EH_1-SERIAL_READ_EH_1),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_2_A	JCLR	#2,X:<BINBIT,TRY_3_A
	MOVE	#SERIAL_READ_EH_2,R0	; Here if H amp, bin by 2
	MOVE	#(END_SERIAL_READ_EH_2-SERIAL_READ_EH_2),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_3_A	JCLR	#3,X:<BINBIT,TRY_4_A
	MOVE	#SERIAL_READ_EH_3,R0	; Here if H amp, bin by 3
	MOVE	#(END_SERIAL_READ_EH_3-SERIAL_READ_EH_3),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_4_A	JCLR	#4,X:<BINBIT,CMP_ERROR
	MOVE	#SERIAL_READ_EH_4,R0	; Here if H amp, bin by 4
	MOVE	#(END_SERIAL_READ_EH_4-SERIAL_READ_EH_4),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END

CMP_B	MOVE	#'__B',A		; B Amplifier = e2v G amp = Leach channel #2
	CMP	X0,A
	JNE	<CMP_C
	MOVE	X0,Y:<AMPVAL		; save the amp value
	MOVE	#ABCD_UP,A
	MOVE	A,Y:IS_PAR_CLK		; ganged parallels
	MOVE    #CD_UP,A
	MOVE    A,Y:S_PAR_CLK		; storage area parallels
	MOVE    #ABCD_CLEAR_UP,A	
	MOVE    A,Y:IS_PAR_CLR 		; Clear full CCD
	MOVE    #CD_CLEAR_UP,A		
	MOVE    A,Y:S_PAR_CLR 		; Clear storage area only
	MOVE	#SERIAL_SKIP_FG,A
	MOVE	A,Y:SERIAL_SKIP		; Now do the serials for general binning
	MOVE    #INITIAL_CLOCK_FG,A
	MOVE    A,Y:INITIAL_CLOCK
	MOVE    #SERIAL_CLOCK_FG,A
	MOVE    A,Y:SERIAL_CLOCK
	MOVE    #(CLK2+$030000+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+0000),A
	MOVE    A,Y:CCLK_1
        MOVE    #$00F042,X0		; Channel 2 only
        MOVE    X0,Y:SXMIT_VP		; Put into VIDEO_PROCESS for arbitrary binning
	MOVE	X0,Y:SXMIT_FG_1	; and into all the hard-coded binned cases in high Y
	MOVE	X0,Y:SXMIT_FG_2
	MOVE	X0,Y:SXMIT_FG_3
	MOVE	X0,Y:SXMIT_FG_4
	BCLR	#SPLIT_S,X:STATUS	; Serials not split
	BCLR	#SPLIT_P,X:STATUS	; Parallels not split
; Now go through copying in the serial read waveform if binning more than 4.
	CLR	A
	CLR	B
	MOVE	B,X:<BINBIT		; Clear BINBIT.  This is for 5 or greater
	MOVE	Y:<NSBIN,B0		; is bin factor more than 4?
	MOVE	#>4,A0
	CMP	B,A
	JLT	<CMP_END		; If binning 5 or more, don't copy.
	JSR	<SET_BINBIT		; else set BINBIT
	MOVE	#<SERIAL_READ,R7	; R7 is the destination address for all copies
TRY_1_B	JCLR	#1,X:<BINBIT,TRY_2_B
;	MOVE	#1,A0			; HACK
;	MOVE	A0,Y:<INTERVAL		; HACK
	MOVE	#SERIAL_READ_FG_1,R0	; Here if G amp, bin by 1
	MOVE	#(END_SERIAL_READ_FG_1-SERIAL_READ_FG_1),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_2_B	JCLR	#2,X:<BINBIT,TRY_3_B
	MOVE	#SERIAL_READ_FG_2,R0	; Here if G amp, bin by 2
	MOVE	#(END_SERIAL_READ_FG_2-SERIAL_READ_FG_2),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_3_B	JCLR	#3,X:<BINBIT,TRY_4_B
	MOVE	#SERIAL_READ_FG_3,R0	; Here if G amp, bin by 3
	MOVE	#(END_SERIAL_READ_FG_3-SERIAL_READ_FG_3),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_4_B	JCLR	#4,X:<BINBIT,CMP_ERROR
	MOVE	#SERIAL_READ_FG_4,R0	; Here if G amp, bin by 4
	MOVE	#(END_SERIAL_READ_FG_4-SERIAL_READ_FG_4),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END

CMP_C	MOVE	#'__C',A		; C Amplifier = e2v E amp = Leach channel #0
	CMP	X0,A
	JNE	<CMP_D
	MOVE	X0,Y:<AMPVAL		; save the amp value
	MOVE	#ABCD_DOWN,A
	MOVE	A,Y:IS_PAR_CLK		; ganged parallels
	MOVE    #AB_DOWN,A
	MOVE    A,Y:S_PAR_CLK		; storage area parallels
	MOVE    #ABCD_CLEAR_DOWN,A	
	MOVE    A,Y:IS_PAR_CLR 		; Clear full CCD
	MOVE    #AB_CLEAR_DOWN,A		
	MOVE    A,Y:S_PAR_CLR 		; Clear storage area only
	MOVE	#SERIAL_SKIP_EH,A
	MOVE	A,Y:SERIAL_SKIP		; Now do the serials for general binning
	MOVE    #INITIAL_CLOCK_EH,A
	MOVE    A,Y:INITIAL_CLOCK
	MOVE    #SERIAL_CLOCK_EH,A
	MOVE    A,Y:SERIAL_CLOCK
	MOVE    #(CLK2+$030000+000+0000+SEH2+0000+0000+000+SFG1+0000+0000+0000),A
	MOVE    A,Y:CCLK_1
        MOVE    #$00F000,X0		; Channel 0 only
        MOVE    X0,Y:SXMIT_VP		; Put into VIDEO_PROCESS for arbitrary binning
	MOVE	X0,Y:SXMIT_EH_1	; and into all the hard-coded binned cases in high Y
	MOVE	X0,Y:SXMIT_EH_2
	MOVE	X0,Y:SXMIT_EH_3
	MOVE	X0,Y:SXMIT_EH_4
	BCLR	#SPLIT_S,X:STATUS	; Serials not split
	BCLR	#SPLIT_P,X:STATUS	; Parallels not split
; Now go through copying in the serial read waveform if binning more than 4.
	CLR	A
	CLR	B
	MOVE	B,X:<BINBIT		; Clear BINBIT.  This is for 5 or greater
	MOVE	Y:<NSBIN,B0		; is bin factor more than 4?
	MOVE	#>4,A0
	CMP	B,A
	JLT	<CMP_END		; If binning 5 or more, don't copy.
	JSR	<SET_BINBIT		; else set BINBIT
	MOVE	#<SERIAL_READ,R7	; R7 is the destination address for all copies
TRY_1_C	JCLR	#1,X:<BINBIT,TRY_2_C
;	MOVE	#1,A0			; HACK
;	MOVE	A0,Y:<INTERVAL		; HACK
	MOVE	#SERIAL_READ_EH_1,R0	; Here if E amp, bin by 1
	MOVE	#(END_SERIAL_READ_EH_1-SERIAL_READ_EH_1),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_2_C	JCLR	#2,X:<BINBIT,TRY_3_C
	MOVE	#SERIAL_READ_EH_2,R0	; Here if E amp, bin by 2
	MOVE	#(END_SERIAL_READ_EH_2-SERIAL_READ_EH_2),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_3_C	JCLR	#3,X:<BINBIT,TRY_4_C
	MOVE	#SERIAL_READ_EH_3,R0	; Here if E amp, bin by 3
	MOVE	#(END_SERIAL_READ_EH_3-SERIAL_READ_EH_3),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_4_C	JCLR	#4,X:<BINBIT,CMP_ERROR
	MOVE	#SERIAL_READ_EH_4,R0	; Here if E amp, bin by 4
	MOVE	#(END_SERIAL_READ_EH_4-SERIAL_READ_EH_4),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END

CMP_D	MOVE	#'__D',A		; D Amplifier = e2v F amp = Leach channel #1
	CMP	X0,A
	JNE	<CMP_AB
	MOVE	X0,Y:<AMPVAL		; save the amp value
	MOVE	#ABCD_DOWN,A
	MOVE	A,Y:IS_PAR_CLK		; ganged parallels
	MOVE    #AB_DOWN,A
	MOVE    A,Y:S_PAR_CLK		; storage area parallels
	MOVE    #ABCD_CLEAR_DOWN,A	
	MOVE    A,Y:IS_PAR_CLR 		; Clear full CCD
	MOVE    #AB_CLEAR_DOWN,A		
	MOVE    A,Y:S_PAR_CLR 		; Clear storage area only
	MOVE	#SERIAL_SKIP_FG,A
	MOVE	A,Y:SERIAL_SKIP		; Now do the serials for general binning
	MOVE    #INITIAL_CLOCK_FG,A
	MOVE    A,Y:INITIAL_CLOCK
	MOVE    #SERIAL_CLOCK_FG,A
	MOVE    A,Y:SERIAL_CLOCK
	MOVE    #(CLK2+$030000+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+0000),A
	MOVE    A,Y:CCLK_1
        MOVE    #$00F021,X0		; Channel 1 only
        MOVE    X0,Y:SXMIT_VP		; Put into VIDEO_PROCESS for arbitrary binning
	MOVE	X0,Y:SXMIT_FG_1	; and into all the hard-coded binned cases in high Y
	MOVE	X0,Y:SXMIT_FG_2
	MOVE	X0,Y:SXMIT_FG_3
	MOVE	X0,Y:SXMIT_FG_4
	BCLR	#SPLIT_S,X:STATUS	; Serials not split
	BCLR	#SPLIT_P,X:STATUS	; Parallels not split
; Now go through copying in the serial read waveform if binning more than 4.
	CLR	A
	CLR	B
	MOVE	B,X:<BINBIT		; Clear BINBIT.  This is for 5 or greater
	MOVE	Y:<NSBIN,B0		; is bin factor more than 4?
	MOVE	#>4,A0
	CMP	B,A
	JLT	<CMP_END		; If binning 5 or more, don't copy.
	JSR	<SET_BINBIT		; else set BINBIT
	MOVE	#<SERIAL_READ,R7	; R7 is the destination address for all copies
TRY_1_D	JCLR	#1,X:<BINBIT,TRY_2_D
;	MOVE	#1,A0			; HACK
;	MOVE	A0,Y:<INTERVAL		; HACK
	MOVE	#SERIAL_READ_FG_1,R0	; Here if F amp, bin by 1
	MOVE	#(END_SERIAL_READ_FG_1-SERIAL_READ_FG_1),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_2_D	JCLR	#2,X:<BINBIT,TRY_3_D
	MOVE	#SERIAL_READ_FG_2,R0	; Here if F amp, bin by 2
	MOVE	#(END_SERIAL_READ_FG_2-SERIAL_READ_FG_2),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_3_D	JCLR	#3,X:<BINBIT,TRY_4_D
	MOVE	#SERIAL_READ_FG_3,R0	; Here if F amp, bin by 3
	MOVE	#(END_SERIAL_READ_FG_3-SERIAL_READ_FG_3),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_4_D	JCLR	#4,X:<BINBIT,CMP_ERROR
	MOVE	#SERIAL_READ_FG_4,R0	; Here if F amp, bin by 4
	MOVE	#(END_SERIAL_READ_FG_4-SERIAL_READ_FG_4),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END

CMP_AB	MOVE	#'_AB',A		; AB Amplifier = e2v HG amp = Leach channels 2-3
	CMP	X0,A
	JNE	<CMP_CD
	MOVE	X0,Y:<AMPVAL		; save the amp value
	MOVE	#ABCD_UP,A
	MOVE	A,Y:IS_PAR_CLK		; ganged parallels
	MOVE    #CD_UP,A
	MOVE    A,Y:S_PAR_CLK		; storage area parallels
	MOVE    #ABCD_CLEAR_UP,A	
	MOVE    A,Y:IS_PAR_CLR 		; Clear full CCD
	MOVE    #CD_CLEAR_UP,A		
	MOVE    A,Y:S_PAR_CLR 		; Clear storage area only
	MOVE	#SERIAL_SKIP_SPLIT,A
	MOVE	A,Y:SERIAL_SKIP		; Now do the serials for general binning
	MOVE    #INITIAL_CLOCK_SPLIT,A
	MOVE    A,Y:INITIAL_CLOCK
	MOVE    #SERIAL_CLOCK_SPLIT,A
	MOVE    A,Y:SERIAL_CLOCK
	MOVE    #(CLK2+$030000+000+0000+SEH2+0000+0000+000+0000+SFG2+0000+0000),A
	MOVE    A,Y:CCLK_1
        MOVE    #$00F062,X0		; Channels 2-3
        MOVE    X0,Y:SXMIT_VP		; Put into VIDEO_PROCESS for arbitrary binning
	MOVE	X0,Y:SXMIT_SPLIT_1	; and into all the hard-coded binned cases in high Y
	MOVE	X0,Y:SXMIT_SPLIT_2
	MOVE	X0,Y:SXMIT_SPLIT_3
	MOVE	X0,Y:SXMIT_SPLIT_4
	BSET	#SPLIT_S,X:STATUS	; Serials split
	BCLR	#SPLIT_P,X:STATUS	; Parallels not split
; Now go through copying in the serial read waveform if binning more than 4.
	CLR	A
	CLR	B
	MOVE	B,X:<BINBIT		; Clear BINBIT.  This is for 5 or greater
	MOVE	Y:<NSBIN,B0		; is bin factor more than 4?
	MOVE	#>4,A0
	CMP	B,A
	JLT	<CMP_END		; If binning 5 or more, don't copy.
	JSR	<SET_BINBIT		; else set BINBIT
	MOVE	#<SERIAL_READ,R7	; R7 is the destination address for all copies
TRY_1_AB	JCLR	#1,X:<BINBIT,TRY_2_AB
;	MOVE	#1,A0			; HACK
;	MOVE	A0,Y:<INTERVAL		; HACK
	MOVE	#SERIAL_READ_SPLIT_1,R0	; Here if HG amp, bin by 1
	MOVE	#(END_SERIAL_READ_SPLIT_1-SERIAL_READ_SPLIT_1),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_2_AB	JCLR	#2,X:<BINBIT,TRY_3_AB
	MOVE	#SERIAL_READ_SPLIT_2,R0	; Here if HG amp, bin by 2
	MOVE	#(END_SERIAL_READ_SPLIT_2-SERIAL_READ_SPLIT_2),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_3_AB	JCLR	#3,X:<BINBIT,TRY_4_AB
	MOVE	#SERIAL_READ_SPLIT_3,R0	; Here if HG amp, bin by 3
	MOVE	#(END_SERIAL_READ_SPLIT_3-SERIAL_READ_SPLIT_3),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_4_AB	JCLR	#4,X:<BINBIT,CMP_ERROR
	MOVE	#SERIAL_READ_SPLIT_4,R0	; Here if HG amp, bin by 4
	MOVE	#(END_SERIAL_READ_SPLIT_4-SERIAL_READ_SPLIT_4),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END

CMP_CD	MOVE	#'_CD',A		; CD Amplifier = e2v EF amp = Leach channels 0-1
	CMP	X0,A
	JNE	<CMP_BD
	MOVE	X0,Y:<AMPVAL		; save the amp value
	MOVE	#ABCD_DOWN,A
	MOVE	A,Y:IS_PAR_CLK		; ganged parallels
	MOVE    #AB_DOWN,A
	MOVE    A,Y:S_PAR_CLK		; storage area parallels
	MOVE    #ABCD_CLEAR_DOWN,A	
	MOVE    A,Y:IS_PAR_CLR 		; Clear full CCD
	MOVE    #AB_CLEAR_DOWN,A		
	MOVE    A,Y:S_PAR_CLR 		; Clear storage area only
	MOVE	#SERIAL_SKIP_SPLIT,A
	MOVE	A,Y:SERIAL_SKIP		; Now do the serials for general binning
	MOVE    #INITIAL_CLOCK_SPLIT,A
	MOVE    A,Y:INITIAL_CLOCK
	MOVE    #SERIAL_CLOCK_SPLIT,A
	MOVE    A,Y:SERIAL_CLOCK
	MOVE    #(CLK2+$030000+000+0000+SEH2+0000+0000+000+0000+SFG2+0000+0000),A
	MOVE    A,Y:CCLK_1
        MOVE    #$00F020,X0		; Channels 0-1
        MOVE    X0,Y:SXMIT_VP		; Put into VIDEO_PROCESS for arbitrary binning
	MOVE	X0,Y:SXMIT_SPLIT_1	; and into all the hard-coded binned cases in high Y
	MOVE	X0,Y:SXMIT_SPLIT_2
	MOVE	X0,Y:SXMIT_SPLIT_3
	MOVE	X0,Y:SXMIT_SPLIT_4
	BSET	#SPLIT_S,X:STATUS	; Serials split
	BCLR	#SPLIT_P,X:STATUS	; Parallels not split
; Now go through copying in the serial read waveform if binning more than 4.
	CLR	A
	CLR	B
	MOVE	B,X:<BINBIT		; Clear BINBIT.  This is for 5 or greater
	MOVE	Y:<NSBIN,B0		; is bin factor more than 4?
	MOVE	#>4,A0
	CMP	B,A
	JLT	<CMP_END		; If binning 5 or more, don't copy.
	JSR	<SET_BINBIT		; else set BINBIT
	MOVE	#<SERIAL_READ,R7	; R7 is the destination address for all copies
TRY_1_CD	JCLR	#1,X:<BINBIT,TRY_2_CD
;	MOVE	#1,A0			; HACK
;	MOVE	A0,Y:<INTERVAL		; HACK
	MOVE	#SERIAL_READ_SPLIT_1,R0	; Here if EF amp, bin by 1
	MOVE	#(END_SERIAL_READ_SPLIT_1-SERIAL_READ_SPLIT_1),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_2_CD	JCLR	#2,X:<BINBIT,TRY_3_CD
	MOVE	#SERIAL_READ_SPLIT_2,R0	; Here if EF amp, bin by 2
	MOVE	#(END_SERIAL_READ_SPLIT_2-SERIAL_READ_SPLIT_2),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_3_CD	JCLR	#3,X:<BINBIT,TRY_4_CD
	MOVE	#SERIAL_READ_SPLIT_3,R0	; Here if EF amp, bin by 3
	MOVE	#(END_SERIAL_READ_SPLIT_3-SERIAL_READ_SPLIT_3),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_4_CD	JCLR	#4,X:<BINBIT,CMP_ERROR
	MOVE	#SERIAL_READ_SPLIT_4,R0	; Here if EF amp, bin by 4
	MOVE	#(END_SERIAL_READ_SPLIT_4-SERIAL_READ_SPLIT_4),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END

CMP_BD	MOVE	#'_BD',A		; BD Amplifier = e2v FG amp = Leach channels 1-2
	CMP	X0,A			; Note that EH amplifier isn't possible - Leach channels 0 & 3
	JNE	<CMP_ALL		; are not adjacent so SXMIT doesn't work.
	MOVE	X0,Y:<AMPVAL		; save the amp value
	MOVE	#ABCD_SPLIT,A
	MOVE	A,Y:IS_PAR_CLK		; ganged parallels
	MOVE    #CD_UP,A
	MOVE    A,Y:S_PAR_CLK		; storage area parallels; NA for split parallels
	MOVE    #ABCD_CLEAR_SPLIT,A	
	MOVE    A,Y:IS_PAR_CLR 		; Clear full CCD
	MOVE    #CD_CLEAR_UP,A		
	MOVE    A,Y:S_PAR_CLR 		; Clear storage area only; NA for split parallels
	MOVE	#SERIAL_SKIP_FG,A
	MOVE	A,Y:SERIAL_SKIP		; Now do the serials for general binning
	MOVE    #INITIAL_CLOCK_FG,A
	MOVE    A,Y:INITIAL_CLOCK
	MOVE    #SERIAL_CLOCK_FG,A
	MOVE    A,Y:SERIAL_CLOCK
	MOVE    #(CLK2+$030000+000+SEH1+0000+0000+0000+000+0000+SFG2+0000+0000),A
	MOVE    A,Y:CCLK_1
        MOVE    #$00F041,X0		; Channels 1-2
        MOVE    X0,Y:SXMIT_VP		; Put into VIDEO_PROCESS for arbitrary binning
	MOVE	X0,Y:SXMIT_FG_1	; and into all the hard-coded binned cases in high Y
	MOVE	X0,Y:SXMIT_FG_2
	MOVE	X0,Y:SXMIT_FG_3
	MOVE	X0,Y:SXMIT_FG_4
	BCLR	#SPLIT_S,X:STATUS	; Serials not split
	BSET	#SPLIT_P,X:STATUS	; Parallels split
; Now go through copying in the serial read waveform if binning more than 4.
	CLR	A
	CLR	B
	MOVE	B,X:<BINBIT		; Clear BINBIT.  This is for 5 or greater
	MOVE	Y:<NSBIN,B0		; is bin factor more than 4?
	MOVE	#>4,A0
	CMP	B,A
	JLT	<CMP_END		; If binning 5 or more, don't copy.
	JSR	<SET_BINBIT		; else set BINBIT
	MOVE	#<SERIAL_READ,R7	; R7 is the destination address for all copies
TRY_1_BD	JCLR	#1,X:<BINBIT,TRY_2_BD
;	MOVE	#1,A0			; HACK
;	MOVE	A0,Y:<INTERVAL		; HACK
	MOVE	#SERIAL_READ_FG_1,R0	; Here if FG amp, bin by 1
	MOVE	#(END_SERIAL_READ_FG_1-SERIAL_READ_FG_1),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_2_BD	JCLR	#2,X:<BINBIT,TRY_3_BD
	MOVE	#SERIAL_READ_FG_2,R0	; Here if FG amp, bin by 2
	MOVE	#(END_SERIAL_READ_FG_2-SERIAL_READ_FG_2),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_3_BD	JCLR	#3,X:<BINBIT,TRY_4_BD
	MOVE	#SERIAL_READ_FG_3,R0	; Here if FG amp, bin by 3
	MOVE	#(END_SERIAL_READ_FG_3-SERIAL_READ_FG_3),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_4_BD	JCLR	#4,X:<BINBIT,CMP_ERROR
	MOVE	#SERIAL_READ_FG_4,R0	; Here if FG amp, bin by 4
	MOVE	#(END_SERIAL_READ_FG_4-SERIAL_READ_FG_4),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END

CMP_ALL	MOVE	#'ALL',A		; ABCD Amplifier = e2v EFGH amp = Leach channels 0-3
	CMP	X0,A
	JNE	<CMP_ERROR
	MOVE	X0,Y:<AMPVAL		; save the amp value
	MOVE	#ABCD_SPLIT,A
	MOVE	A,Y:IS_PAR_CLK		; ganged parallels
	MOVE    #CD_UP,A
	MOVE    A,Y:S_PAR_CLK		; storage area parallels; NA for split parallels
	MOVE    #ABCD_CLEAR_SPLIT,A	
	MOVE    A,Y:IS_PAR_CLR 		; Clear full CCD
	MOVE    #CD_CLEAR_UP,A		
	MOVE    A,Y:S_PAR_CLR 		; Clear storage area only; NA for split parallels
	MOVE	#SERIAL_SKIP_SPLIT,A
	MOVE	A,Y:SERIAL_SKIP		; Now do the serials for general binning
	MOVE    #INITIAL_CLOCK_SPLIT,A
	MOVE    A,Y:INITIAL_CLOCK
	MOVE    #SERIAL_CLOCK_SPLIT,A
	MOVE    A,Y:SERIAL_CLOCK
	MOVE    #(CLK2+$030000+000+0000+SEH2+0000+0000+000+0000+SFG2+0000+0000),A
	MOVE    A,Y:CCLK_1
        MOVE    #$00F060,X0		; All four channels
        MOVE    X0,Y:SXMIT_VP		; Put into VIDEO_PROCESS for arbitrary binning
	MOVE	X0,Y:SXMIT_SPLIT_1	; and into all the hard-coded binned cases in high Y
	MOVE	X0,Y:SXMIT_SPLIT_2
	MOVE	X0,Y:SXMIT_SPLIT_3
	MOVE	X0,Y:SXMIT_SPLIT_4
	BSET	#SPLIT_S,X:STATUS	; Serials split
	BSET	#SPLIT_P,X:STATUS	; Parallels split
; Now go through copying in the serial read waveform if binning more than 4.
	CLR	A
	CLR	B
	MOVE	B,X:<BINBIT		; Clear BINBIT.  This is for 5 or greater
	MOVE	Y:<NSBIN,B0		; is bin factor more than 4?
	MOVE	#>4,A0
	CMP	B,A
	JLT	<CMP_END		; If binning 5 or more, don't copy.
	JSR	<SET_BINBIT		; else set BINBIT
	MOVE	#<SERIAL_READ,R7	; R7 is the destination address for all copies
TRY_1_ALL	JCLR	#1,X:<BINBIT,TRY_2_ALL
;	MOVE	#1,A0			; HACK
;	MOVE	A0,Y:<INTERVAL		; HACK
	MOVE	#SERIAL_READ_SPLIT_1,R0	; Here if ALL amp, bin by 1
	MOVE	#(END_SERIAL_READ_SPLIT_1-SERIAL_READ_SPLIT_1),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_2_ALL	JCLR	#2,X:<BINBIT,TRY_3_ALL
	MOVE	#SERIAL_READ_SPLIT_2,R0	; Here if ALL amp, bin by 2
	MOVE	#(END_SERIAL_READ_SPLIT_2-SERIAL_READ_SPLIT_2),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_3_ALL	JCLR	#3,X:<BINBIT,TRY_4_ALL
	MOVE	#SERIAL_READ_SPLIT_3,R0	; Here if ALL amp, bin by 3
	MOVE	#(END_SERIAL_READ_SPLIT_3-SERIAL_READ_SPLIT_3),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform
	JMP	<CMP_END
TRY_4_ALL	JCLR	#4,X:<BINBIT,CMP_ERROR
	MOVE	#SERIAL_READ_SPLIT_4,R0	; Here if ALL amp, bin by 4
	MOVE	#(END_SERIAL_READ_SPLIT_4-SERIAL_READ_SPLIT_4),B0
	MOVE	B0,Y:<SERWAVLEN		; Source address & length now set
	JSR	<WAVECPY		; Copy the waveform

CMP_END	MOVE	#'DON',X0	
	RTS
CMP_ERROR				; Here if illegal amplifier or binning
	MOVE	#'ERR',X0
	RTS

; Short function to copy in waveforms from high Y to fast Y memory.
; R0 is the source address, R7 the destination, and X0 is intermediary reg.
WAVECPY	
	DO	B0,WAVELP	; Copy the waveform; B0 is SERWAVLEN already
	MOVE	Y:(R0)+,X0
	MOVE	X0,Y:(R7)+
	NOP
WAVELP
	NOP
	RTS

; Short function to set the correct bit in BINBIT based on NSBIN
; Called only if NSBIN is less than 6.

SET_BINBIT
;	MOVE	Y:<TESTLOC1,A0			; HACK - test if this code is executed
;	INC	A				; HACK
;	MOVE	A0,Y:<TESTLOC1			; HACK
	MOVE    #>1,A0                  ; Put a bit in A and shift to right spot
        DO      Y:<NSBIN,BINLOOP        ; Bit zero position not used, 1-4 used
        ASL     A
BINLOOP
	MOVE	A0,X:<BINBIT		; set bit 1-4 for SELECT_OUTPUT_SOURCE jump table
	RTS


; Set the number of rows and columns and binning factors
SET_ROWS_COLUMNS
        MOVE    X:(R4)+,X0              ; Set the value of the NSR = NAXIS1
        MOVE    X0,Y:NSR
        MOVE    X:(R4)+,X0              ; Set the value of the NPR = NAXIS2
        MOVE    X0,Y:NPR
        MOVE    X:(R4)+,X0              ; Set the value of the NSBIN
        MOVE    X0,Y:NSBIN
        MOVE    X:(R4)+,X0              ; Set the value of the NPBIN
        MOVE    X0,Y:NPBIN
	MOVE	Y:<AMPVAL,X0		; Get ampval in X0 for SOS call
	JSR	<SELECT_OUTPUT_SOURCE	; Update serial read waveform in case binning changed
        JMP     <FINISH

; Set the variables for the time-resolved modes
SET_IMAGE_PARAM
        MOVE    X:(R4)+,X0              ; Set the value of the Image mode
        MOVE    X0,X:IMAGE_MODE
        MOVE    X:(R4)+,X0              ; Set the value of the Iframes = NAXIS3
        MOVE    X0,Y:IFRAMES
        MOVE    X:(R4)+,X0              ; Set the value of the Srows
        MOVE    X0,Y:SROWS
        MOVE    X:(R4)+,X0              ; Set the value of the Interval
;       MOVE    X0,Y:INTERVAL		; HACK - Using Interval as a test location
        JMP     <FINISH


; Set the hardware trigger bit, executed as a command
SET_TRIGGER
	MOVE	X:(R4)+,X0		; Get the trigger value
	MOVE	#'_ON',A
	CMP	X0,A
	JNE	NO_TRIGGER
	JSET    #11,X:PBD,TRIG_CLR      ; Is Trigger running?
	JMP     <ERROR                  ; Yes! report Error!  Why do this?
TRIG_CLR
	BSET    #TRIGGER,X:<STATUS 	; Set status bit, hardware trigger
	JMP	<FINISH
NO_TRIGGER
	BCLR	#TRIGGER,X:<STATUS	; Clear Status bit, software timing
	JMP	<FINISH

; Calculate the fast read parameters for each readout box
SETUP_SUBROUTINE
	MOVE	Y:<SERWAVLEN,X0 	; # of waveforms
	MOVE	Y:<NSERIALS_READ,X1	; Number of pixels to read
	JSR	<FASTSKP		; Compute number of clocks required
	MOVE	X1,Y:<NREAD		; Number of waveforms per line
	MOVE	Y:<NR_BIAS,A		; Number of pixels to read
	JCLR	#SPLIT_S,X:STATUS,*+3	; Split serials require / 2
	ASR	A
	MOVE	A,X1			; Number of waveforms per line
	JSR	<FASTSKP		; Compute number of clocks required
	MOVE	X1,Y:<NBIAS		; Number of waveforms per line
	MOVE	#(END_SERIAL_SKIP_SPLIT-SERIAL_SKIP_SPLIT),X0 ; # of waveforms
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

; Returns immediately if hardware triggering is not being used
; Blocks until the trigger is found to be high twice in a row.
; Waits until the trigger goes high
WAIT_UNTIL_TRIGGER
	JCLR	#TRIGGER,X:STATUS,UNTIL_TRIGGER_RETURN		
	NOP
	JCLR    #11,X:PBD,WAIT_UNTIL_TRIGGER       ; Is Trigger Low?
        NOP				     	   ; Pause 
	JCLR    #11,X:PBD,WAIT_UNTIL_TRIGGER	   ; Is Trigger still Low? 
	NOP	
UNTIL_TRIGGER_RETURN
	RTS

; Returns immediately if hardware triggering is not being used
; Blocks until the trigger is found to be low twice in a row.
; Waits while the trigger is high
WAIT_WHILE_TRIGGER
	JCLR	#TRIGGER,X:STATUS,WHILE_TRIGGER_RETURN		
	NOP
	JSET    #11,X:PBD,WAIT_WHILE_TRIGGER       ; Is Trigger High?
        NOP				           ; Pause 
	JSET    #11,X:PBD,WAIT_WHILE_TRIGGER	   ; Is Trigger still High? 
	NOP	
WHILE_TRIGGER_RETURN
	RTS

; Like WAIT_WHILE_TRIGGER but clears the CCD while waiting
; Pro:  Clears CCD while waiting.  Con: timing rattiness of 1 parallel time
; Returns immediately if hardware triggering is not being used
; Blocks until the trigger is found to be low twice in a row.
; Waits while the trigger is high
CLEAR_WHILE_TRIGGER
	JCLR	#TRIGGER,X:STATUS,CLEAR_TRIG_RETURN		
	MOVE    Y:<IS_PAR_CLR,R0		; Address of parallel transfer waveform
	JSR     <CLOCK  		; Go clock out the CCD charge
	JSET    #11,X:PBD,CLEAR_WHILE_TRIGGER       ; Is Trigger High?
        NOP				           ; Pause 
	JSET    #11,X:PBD,CLEAR_WHILE_TRIGGER	   ; Is Trigger still High? 
	NOP	
CLEAR_TRIG_RETURN
	RTS

; Subroutine to compute SROWS in unbinned pixels and store in UBSROWS

UB_CONV
	MOVE	Y:<SROWS,X0
        MOVE    Y:<NPBIN,X1			; Adjust for for parallel binning factor
        MPY     X0,X1,A
        ASR     A
        MOVE    A0,Y:<UBSROWS			; Put unbinned number in UBSROWS
	RTS
	
; Key code segments for the HIPO modes.
; Jump table to the various modes - see also timhdr.s
START_FT_EXPOSURE
        JSET    #FIND,X:IMAGE_MODE,SINGLE_PROC
        JSET    #SINGLE,X:IMAGE_MODE,SINGLE_PROC
;       JSET    #SERIES,X:IMAGE_MODE,SERIES_PROC        ; defunct.  Use basic occ.
        JSET    #FDOTS,X:IMAGE_MODE,FDOT_PROC
        JSET    #SDOTS,X:IMAGE_MODE,SDOT_PROC		; slow dots & strips use sdot_proc
        JSET    #STRIP,X:IMAGE_MODE,SDOT_PROC
        JSET    #B_OCC,X:IMAGE_MODE,SINGLE_PROC		; basic occ uses single_proc
;       JSET    #F_OCC,X:IMAGE_MODE,FPO_PROC		; fast & pipelined occ use occ_proc
;       JSET    #P_OCC,X:IMAGE_MODE,FPO_PROC
        MOVE    #'ERR',X0               ; error if not a valid mode
        JMP     <ERROR

FDOT_PROC					; used by fdots only
; Start by replacing SROWS (binned rows) with unbinned rows.  Will get rewritten on next SEX command
; Leave the DO loop in here - no reason to change it - won't exceed 65535 dots, for sure!
	JSR	UB_CONV				; Fill in unbinned SROWS
	MOVE	Y:<NPR,A
	MOVE	A,Y:<NP_READ			; Make sure that NP_READ=NPR in case of subframe
	BSET	#OPEN_CLOSE,X:<ISTATUS		; set the open-close bit
	BSET	#STORAGE,X:<ISTATUS		; Don't shift the storage array for FDOTS 
	BSET	#NO_SKIP,X:<ISTATUS		; Don't parallel skip up to the subframe boundary
	JSR	IMG_INI				; Set up the status bits and PCI card
	JSR	<CLR_CCD			; Clear out the CCD
	JSR	<WAIT_WHILE_TRIGGER		; wait for low trigger, or
;	JSR	<CLEAR_WHILE_TRIGGER		; clear while waiting for low trigger
	JSR	<C_OSHUT			; Open shutter if not a dark frame
	DO	Y:<IFRAMES,FDOT_LOOP		; Loop over the number of FDOTS  
	JSET	#TRIGGER,X:STATUS,FDX_END	; If no triggering jump to expose image function
	MOVE	#FDX_END,R7			; Store the Address into R7 
	JMP	<EXPOSE				; Delay for specified exposure time
FDX_END JSR	<WAIT_UNTIL_TRIGGER		; wait for high trigger or fall through
        MOVE    Y:<UBSROWS,X1			; Number of unbinned rows per shift
	JSR     <ISHIFT				; Clock out the waveforms
	JSR	<WAIT_WHILE_TRIGGER		; wait for low trigger
	NOP
FDOT_LOOP
	JSR	<C_CSHUT			; Conditionally close shutter
	DO	Y:<IFRAMES,FDOT_LP1		; Loop over the number of FDOTS during readout
	JSR	<RDCCD				; Finally, read out the CCD
	NOP
FDOT_LP1	
;	JSR	<WAIT_UNTIL_TRIGGER		; If taking more than one set of dots sync. trigger.  Vestigial?
	JMP	CLEANUP				; clean up after command.

SINGLE_PROC					; Used by find, single, and basic occ
	BCLR	#OPEN_CLOSE,X:<ISTATUS		; clear open-close for find & basic occ
        JCLR    #SINGLE,X:IMAGE_MODE,*+3	; But if single mode,
	BSET	#OPEN_CLOSE,X:<ISTATUS		; set the open-close bit
	BCLR	#STORAGE,X:<ISTATUS		; Do the FT, storage clocks only during readout
        JSET    #B_OCC,X:IMAGE_MODE,NO_CHG	; STORAGE=0 for basic, 1 otherwise
	BSET	#STORAGE,X:<ISTATUS		; Don't do the FT, ganged clocks only during readout
NO_CHG	BCLR	#NO_SKIP,X:<ISTATUS		; Do parallel skip up to the subframe boundary
        DO	#50,TST_DELAY1
        MOVE	#25000,X0
        DO	X0,TST_DELAY0
	NOP
TST_DELAY0	NOP
TST_DELAY1	NOP
    
	JSR	IMG_INI				; Set up the status bits and PCI card
	JSR	<CLR_CCD			; Clear out the CCD
	JSR	<WAIT_WHILE_TRIGGER		; wait for low trigger, or
;	JSR	<CLEAR_WHILE_TRIGGER		; clear while waiting for low trigger
	MOVE	Y:<IFRAMES,A0
	MOVE	A0,Y:<IFLPCNT			; Set up 24-bit loop counter in IFLPCNT
SN_LP	JSR	<C_OSHUT			; Open shutter if not a dark frame
	JSET	#TRIGGER,X:STATUS,SNX_END	; If no triggering jump to expose image function
	MOVE	#SNX_END,R7			; Store the Address into R7 
	JMP	<EXPOSE				; Delay for specified exposure time
SNX_END JSR	<WAIT_UNTIL_TRIGGER		; wait for high trigger or fall through
	JSR	<C_CSHUT			; Close shutter if open-close bit is set
	JSR	<RDCCD				; Finally, read out the CCD
	JSR	<WAIT_WHILE_TRIGGER		; wait for low trigger
	CLR	A
	MOVE	Y:<IFLPCNT,A0
	DEC	A				; Get loop count, decrement, and loop till zero
	MOVE	A0,Y:<IFLPCNT
	TST	A
	JNE	SN_LP				; End of IFRAMES loop
        JSET    #FIND,X:IMAGE_MODE,*+3
	JSR	<CSHUT				; Close the shutter unless in find mode
	JMP	CLEANUP				; clean up after command.

SDOT_PROC					; Used by slow dots and strips
	MOVE	Y:<SROWS,A
	MOVE	A,Y:<NP_READ			; Make sure that NP_READ=SROWS
        BCLR    #OPEN_CLOSE,X:<ISTATUS          ; clear open-close for strips
        JCLR    #SDOTS,X:IMAGE_MODE,*+3		; But if sdots mode,
        BSET    #OPEN_CLOSE,X:<ISTATUS          ; set the open-close bit
        BSET    #STORAGE,X:<ISTATUS             ; Don't shift the storage array for SDOTS and strips
	BSET	#NO_SKIP,X:<ISTATUS		; Don't parallel skip up to the subframe boundary
        JSR     IMG_INI                         ; Set up the status bits and PCI card
        JSR     <CLR_CCD                        ; Clear out the CCD
	JSR	<WAIT_WHILE_TRIGGER		; wait for low trigger, or
;	JSR	<CLEAR_WHILE_TRIGGER		; clear while waiting for low trigger
	MOVE	Y:<IFRAMES,A0
	MOVE	A0,Y:<IFLPCNT			; Set up 24-bit loop counter in IFLPCNT
SD_LP   JSR     <C_OSHUT                        ; Open shutter if not a dark frame
        JSET    #TRIGGER,X:STATUS,SDX_END       ; If no triggering jump to expose image function
        MOVE    #SDX_END,R7                     ; Store the Address into R7
        JMP     <EXPOSE                         ; Delay for specified exposure time
SDX_END JSR     <WAIT_UNTIL_TRIGGER             ; wait for high trigger or fall through
        JSR     <C_CSHUT                        ; Close shutter if open-close is set
        JSR     <RDCCD                          ; Finally, read out the CCD.  
						; No FT or parallel skip since STORAGE=1
        JSR     <WAIT_WHILE_TRIGGER             ; wait for low trigger
	CLR	A
	MOVE	Y:<IFLPCNT,A0
	DEC	A				; Get loop count, decrement, and loop till zero
	MOVE	A0,Y:<IFLPCNT
	TST	A
	JNE	SD_LP				; End of IFRAMES loop
        JSR     <CSHUT				; Unconditionally close shutter
        JMP     CLEANUP                         ; clean up after command.

; Support subroutines and code fragments used in the various mode code
; IMG_INI, CLEANUP, ISHIFT, SSHIFT, RSHIFT
;  Image initialization subroutine.  Sets up status bits & PCI card

IMG_INI MOVEP   #$020102,Y:WRFO         ; Transmit header word
        REP     #15                     ; Delay for transmission
        NOP
        MOVEP   #'IIA',Y:WRFO           ; Initialize Image Address
        REP     #15
        NOP
        BSET    #ST_RDC,X:<STATUS       ; Set status to reading out
        JSR     <PCI_READ_IMAGE         ; Get the PCI board reading the image
        BSET    #WW,X:PBD               ; Set WW = 1 for 16-bit image data
        NOP
        RTS

; Cleanup code fragment (not a subroutine) for the end all modes.  JMP to it.

CLEANUP BCLR    #WW,X:PBD               ; Clear WW to 0 for 32-bit commands
        BCLR    #ST_RDC,X:<STATUS       ; Clear status to NOT reading out
; Restore the controller to non-image data transfer and idling if necessary
        JCLR    #IDLMODE,X:<STATUS,START ; Don't idle after readout
        MOVE    #IDLE,X0
        MOVE    X0,X:<IDL_ADR
        JMP     <START                  ; Wait for a new command

; Shift image and storage areas down by the number of rows in X1
ISHIFT
	DO      X1,ISH_LOOP		; Number of rows to shift is in X1
	MOVE    Y:<IS_PAR_CLR,R0		; Ganged clocks with DG running
	JSR     <CLOCK			; Parallel clocking
	NOP
ISH_LOOP
	MOVE    #DUMP_SERIAL,R0         ; clear the SR after parallel clear
	JSR     <CLOCK
	RTS			; End of ISHIFT

; Shift storage area only down by the number of rows in X1
SSHIFT
	DO      X1,SSH_LOOP		; Number of rows to shift is in X1
	MOVE    Y:<S_PAR_CLR,R0		; Storage clocks only with DG running
	JSR     <CLOCK			; Parallel clocking
	NOP
SSH_LOOP
	MOVE    #DUMP_SERIAL,R0         ; clear the SR after parallel clear
	JSR     <CLOCK
	RTS			; End of SSHIFT
