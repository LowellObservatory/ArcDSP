	COMMENT *

This file is used to generate DSP code for the PCI interface 
	board using a DSP56301 as its main processor.

April,2010    Peter L. Collins (Lowell Observatory)
            Modified to run on gen-iii.

Version 1.7_3/2 Added conditional code for interaction history log.
Version 1.7_3/1 Added conditional code for hardware timer, test point.
Version 1.7_3   Revised PCI Error handling and versioning support.

Version 1.7_2 - PCI DMA writes like the gen-III code with fiber optic and DMA
                transfer concurrency for still better performance.
                Fill ptr and wrap counter for circular buffer support.

Version 1.7_1 - PCI DMA writes like the gen-III code for better performance.

Version 1.7 - 	Replies to commands with polling only, no interrupts
		Number of 16-bit pixels returned to host during image readout

Some Rules - 
	Commands executed only by the PCI board end with a jump to FINISH,
		FINISH1 or ERROR, since these will assert the reply flags
		and return from interrupt.
	Commands passed along to the timing board end only with RTI since 
		the reply from the timing board will generate its own call
		to FINISH1 or ERROR.
	PCI -> commands are received as 24-bit words, with 
	Communication of commands and replies over the PCI bus is all at
		24 bits per word. PCI address that need to be passed are
		split into two 16-bit words. 

CHANGES, Feb,March,2009 (Peter L. Collins, Lowell Observatory)
         fixed race between READ_NUMBER_OF_PIXELS_READ (interrupt for pxl cntr)
         and C_RPXLS- problem coming from non-atomic update of the two counter
         locations, causing apparent pixel counter to occasionally 'back up'-
         this was OK in earlier LOIS versions where the pixel counter was a
         linear counter polled for completion- however, the circular buffering
         mode used (now) on MAGIC and HIPO blows up. The fix involves several Y 
         locations to save an old copy of the pixel counter locations during
         the critical section, and marking the critical state using bit 0 in
         X:<R_PXLS_CRIT.


March,2007 (Peter L. Collins, Lowell Observatory)
        -The "long form" unused PCI retry/handler previously following WR_ERR
         was slightly modified and made to work. The immediate effect was
         to remove a large volume of secondary PCI retries (factor of 2).

February, 2007   (Peter L. Collins, Lowell Observatory)
        -change pixel count returned in GET_PROGRESS ioctl to
         6 bits bits of wrap and 26 bits of FILL.

        -Keep error counts regardless of error logging switch.

        -Prevent error logging in Y memory from overrunning Y memory- it
         is bounded by PCIERRLOGSIZE.

        -Error buffer logging in Y memory controlled by X:PCIERRLOG switch.
         Further modification to DMA to flush PCI transmit fifo before each
         burst transfer. Error buffer added in Y memory following
         the 512 pixel image buffer.

        -Interleave copy from RDFIFO to IMAGE_BUFER with pci transfer
         using FILL and EMPTY. It is still tied to the 512 pixel block
         concept (and use of the  half full flag on the fiber optic fifo.)

January, 2007   (Peter L. Collins, Lowell Observatory)
	- put in geniii "DMA" to write to pci bus.
	- add loop statistics and oscilloscope check points.
        - fix to update DSR0 register for a pci retry. Prior
          code seemed to be writing the next burst where the
          last should have been- in the case of retry- ultimately
          causing bad pixels off the end of the image bufer to appear
          in the image in the case of retries (as engendered by heavy
          concurrent host pci activity, such as an ftp).

February to March 2001
	- Get rid of Number of Bytes per pixel in images. Assume 2.
	- Get rid of $80A7 = read image command. 
	- Process 'RDA' timing board command to start the readout
	- Jump to error if receiver FIFO is empty on vector commands
	- Replace GET_FO mess with calls to RD_FO
	- Implement a timeout on fiber optic words, called RD_FO_TIMEOUT
	- Number of bytes per image replaces NCOLS x NROWS
	- Interrupt levels set as folllows - 
		New vector command locations for more order
		NMI for read PCI image address, reset PCI, abort readout
		IPL = 2 for reset button, FIFO HF, enabled during readout
		IPL = 1 for all host commands
		Host commands disabled during image readout
	- Host flags = 5 if reading out image
	- Commands from the PCI host follow the fiber optic protocol, 
		header, command, arg1 - arg4
	    with command words written to $10020 and then vector $B1
	- A BUSY host flag was introduced =6 for the case where a command
		takes longer than the voodoo TIMEOUT to execute
	- The non-maskable reboot from EEPROM command = $807B is implemented
	- RDM and WRM were changed to abide by the timing board convention
		of embedding the memory type in the address' most significant
		nibble. This limits memory accesses to 64k on this board.
	- Eliminate Scatter/Gather image processing in favor of direct
		FIFO to PCI bus transfers. 
April 25 - Change PCI write handshaking to MARQ and MDT, eliminating the
		special writing of 8 pixels at the beginning of each image.

Version 1.7 as follows:
	- Slaved READ IMAGE to the controller for the number of pixels
		to be read, not just the starting time. 
	- Introduced the 'IIA' = Initialize Image Address command sent by
		the timing board as a reply to the 'SEX' command to set
		PCI_ADDR = BASE_ADDR at the start of an image instead of
		having the host computer issue it.
	- Took out the WRITE_NUMBER_OF_BYTES_IN_IMAGE and 	
		INITIALIZE_NUMBER_OF_PIXELS command because the
		timing board now does this.
 	- Introduced the local variable X:<HOST_FLAG that is set to
		the value of the DCTR register bits 5,4,3 to inform
		this program what state the controller is in. 
	- Separately process commands from the controller to the PCI board,
		distinguished by Destination = 1. Host commands or replies
		have Destination = 0.
	- Introduced RDI = 'Reading Image ON' and RDO = 'Reading Image Off'
		commands from the timing board to set host flags indicating
		that the controller is readout out. 
	*
	PAGE    132     ; Printronix page width - 132 columns

; Equates to define the X: memory tables
VAR_TBL		EQU	0	; Variables and constants table
ARG_TBL		EQU	$30	; Command arguments and addresses
VAR2_TBL	EQU	$60	; Another variable and constants table

; Various addressing control registers
BCR	EQU	$FFFFFB		; Bus Control Register
DCR	EQU	$FFFFFA		; DRAM Control Register
AAR0	EQU	$FFFFF9		; Address Attribute Register, channel 0	
AAR1	EQU	$FFFFF8		; Address Attribute Register, channel 1	
AAR2	EQU	$FFFFF7		; Address Attribute Register, channel 2	
AAR3	EQU	$FFFFF6		; Address Attribute Register, channel 3	
PCTL	EQU	$FFFFFD		; PLL control register
IPRP	EQU	$FFFFFE		; Interrupt Priority register - Peripheral
IPRC	EQU	$FFFFFF		; Interrupt Priority register - Core

; PCI control register
DTXS	EQU	$FFFFCD		; DSP Slave transmit data FIFO
DTXM	EQU	$FFFFCC		; DSP Master transmit data FIFO
DRXR	EQU	$FFFFCB		; DSP Receive data FIFO
DPSR	EQU	$FFFFCA		; DSP PCI Status Register 
DSR	EQU	$FFFFC9		; DSP Status Register
DPAR	EQU	$FFFFC8		; DSP PCI Address Register
DPMC	EQU	$FFFFC7		; DSP PCI Master Control Register 
DPCR	EQU	$FFFFC6		; DSP PCI Control Register
DCTR	EQU	$FFFFC5		; DSP Control Register

; Port E is the Synchronous Communications Interface (SCI) port
PCRE	EQU	$FFFF9F		; Port Control Register
PRRE	EQU	$FFFF9E		; Port Direction Register
PDRE	EQU	$FFFF9D		; Port Data Register

; Various PCI register bit equates
STRQ	EQU	1		; Slave transmit data request (DSR)
SRRQ	EQU	2		; Slave receive data request (DSR) 
HACT	EQU	23		; Host active, low true (DSR)
MTRQ	EQU	1		; Set whem master transmitter is not full (DPSR)
MARQ	EQU	4		; Master address request (DPSR)
TRTY	EQU	10		; PCI Target Retry (DPSR)
HCIE	EQU	0		; Host command interrupt enable (DCTR)
INTA	EQU	6		; Request PCI interrupt (DCTR)
APER	EQU	5		; Address parity error
DPER	EQU	6		; Data parity error
MAB	EQU	7		; Master Abort
TAB	EQU	8		; Target Abort
TDIS	EQU	9		; Target Disconnect
TO	EQU	11		; Timeout
MDT	EQU	14		; Master Data Transfer complete
RDCQ	EQU	15		; Remaining Data Count Qualifier
SCLK	EQU	2		; SCLK = transmitter special code

; DPCR bit definitions
CLRT	EQU	14		; Clear the master transmitter DTXM
MACE	EQU	18		; Master access counter enable
IAE	EQU	21		; Insert Address Enable

; DMA register definitions
DSR0	EQU	$FFFFEF		; Source address register
DDR0	EQU	$FFFFEE		; Destination address register
DCO0	EQU	$FFFFED		; Counter register
DCR0	EQU	$FFFFEC		; Control register

; Addresses of ESSI port
TX00	EQU	$FFFFBC		; Transmit Data Register 0
SSISR0	EQU	$FFFFB7		; Status Register
CRB0	EQU	$FFFFB6		; Control Register B
CRA0	EQU	$FFFFB5		; Control Register A

; SSI Control Register A Bit Flags
TDE	EQU	6		; Set when transmitter data register is empty

; Miscellaneous addresses
RDFIFO	EQU	$FFFFFF		; Read the FIFO for incoming fiber optic data

	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
; Timer Addresses
TCSR0   EQU     $FFFF8F         ; Triple timer control and status register 0
TLR0    EQU     $FFFF8E         ; Timer load register = 0
TCPR0   EQU     $FFFF8D         ; Timer compare register = exposure time
TCR0    EQU     $FFFF8C         ; Timer count register = elapsed time
TCSR1   EQU     $FFFF8B         ; Triple timer control and status register 1
TLR1    EQU     $FFFF8A         ; Timer load register = 0
TCPR1   EQU     $FFFF89         ; Timer compare register = exposure time
TCR1    EQU     $FFFF88         ; Timer count register = elapsed time
TCSR2   EQU     $FFFF87         ; Triple timer control and status register 2
TLR2    EQU     $FFFF86         ; Timer load register = 0
TCPR2   EQU     $FFFF85         ; Timer compare register = exposure time
TCR2    EQU     $FFFF84         ; Timer count register = elapsed time
TPLR    EQU     $FFFF83         ; Timer prescaler load register => milliseconds
TPCR    EQU     $FFFF82         ; Timer prescaler count register
TIM_BIT EQU     0               ; Set to enable the timer
TCF     EQU     21              ; Set when timer counter = compare register
	ELSE
TCSR0	EQU	$FFFF8F		; Triple timer control and status register 0
TCSR1	EQU	$FFFF8B		; Triple timer control and status register 1
TCSR2	EQU	$FFFF87		; Triple timer control and status register 2
	ENDIF

; Phase Locked Loop initialization
PLL_INIT EQU    $050003         ; PLL = 25 MHz x 4 = 100 MHz

; Port C is Enhanced Synchronous Serial Port 0
PCRC	EQU	$FFFFBF		; Port C Control Register
PRRC	EQU	$FFFFBE		; Port C Data direction Register
PDRC	EQU	$FFFFBD		; Port C GPIO Data Register

; Port D is Enhanced Synchronous Serial Port 1
PCRD	EQU	$FFFFAF		; Port D Control Register
PRRD	EQU	$FFFFAE		; Port D Data direction Register
PDRD	EQU	$FFFFAD		; Port D GPIO Data Register

; Bit number definitions of GPIO pins on Port D
EF	EQU	0		; FIFO Empty flag, low true
HF	EQU	1		; FIFO Half Full flag, low true

; STATUS bit definition
ODD	EQU	0		; Set if odd number of pixels are in the image
TIMROMBURN      EQU     1       ; Burning timing board EEPROM, ignore replies

; PCI transfer constants
FOBURST		EQU	512	; unit of pixels.
PCIBURST	EQU	128	; unit of pixels.
PCI2BURST	EQU	256	; unit of pixels.
PCI_ERRMAGIC    EQU	$FEEDEE ; set PCI_ERRLOG to this to enable retry log
PCI_ERRLOGSIZE  EQU     100     ; Maximum entries in Y memory pci error log
PCI_ERRLOGFIRST  EQU   1024     ; Start of Y memory pci error log
PCI_ERRLOGLAST  EQU    1124     ; End+1 of Y memory pci error log
PCI_YCOMM       EQU    2000     ; small comm area up through 2047
RPXLS_SAFE	EQU    PCI_YCOMM+16 ; alternate R_PXLS copy for race

; History log
	IF	@SCP("HISTLOG","SUPPORTED")	
PCI_HISTFIRST   EQU    2048     ; history log start in Y memory
PCI_HISTEND     EQU    4096     ; history log end + 1 in Y memory

; PCI history tags
H_RDNUMPIX	EQU	'RNP'	; READ_NUMBER_OF_PIXELS_READ 
H_RDREPLYVAL	EQU	'RRP'	; READ_REPLY_VALUE
H_BASEPCIADDR	EQU	'WBP'	; WRITE_BASE_PCI_ADDRESS
H_CLEARHOSTFLG	EQU	'CHF'	; CLEAR_HOST_FLAG
F_READ_IMAGE	EQU	'RDA'	; READ_IMAGE
F_READING_IMAGE	EQU	'RDI'	; READING_IMAGE
F_INIT_NO_PIX	EQU	'IIA'	; INITIALIZE_NUMBER_OF_PIXELS
F_WCMDSTG1	EQU	'WS1'   ; WRITE-COMMAND error, stage 1, fifo empty
F_WCMDSTG2	EQU	'WS2'   ; WRITE-COMMAND error, stage 2, header bad
F_WCMDSTG3	EQU	'WS3'   ; WRITE-COMMAND error, stage 3, header bad
F_WCMDSTG4	EQU	'WS4'   ; WRITE-COMMAND error, stage 4, arg cnt <= 0
F_WCMDSTG5	EQU	'WS5'   ; WRITE-COMMAND error, stage 5, arg cnt too lrg
F_WCMDSTG6	EQU	'WS6'   ; WRITE-COMMAND error, stage 6, dest = 0
	ENDIF

;	Standard info fields specification
	INCLUDE "infospec.s"
;	PCI-specific info fields specification
	INCLUDE "pciinfospec.s"
;       File of info field values
	INCLUDE "pciinfo.s"
	INCLUDE "version.s"   ; backward compatibility

; set up pci capabilities word
	IF	@SCP("RDAFIX","SUPPORTED")	;bit 0 (1)
RDACAPABLE	EQU	1
        ELSE
RDACAPABLE	EQU	0
	ENDIF
	IF	@SCP("HISTLOG","SUPPORTED")	;bit 0 (1)
HISTCAPABLE	EQU	2
        ELSE
HISTCAPABLE	EQU	0
	ENDIF
	IF	@SCP("TIMER","SUPPORTED")	;bit 0 (1)
TIMCAPABLE	EQU	4
        ELSE
TIMCAPABLE	EQU	0
	ENDIF
PCICAPABLE	EQU TIMCAPABLE+HISTCAPABLE+RDACAPABLE


; Special address for two words for the DSP to bootstrap code from the EEPROM
	IF	@SCP("DOWNLOAD","ROM")		; Boot from ROM on power-on
	ORG	P:0,P:0
	DC	END_ADR-INIT-2			; Number of boot words
	DC	INIT				; Starting address
	ORG	P:0,P:2
INIT	JMP	<INIT_PCI			; Configure PCI port
	NOP
	ENDIF

	IF	@SCP("DOWNLOAD","HOST")		; Download via host computer
	ORG	P:0,P:0
	DC	END_ADR-INIT			; Number of boot words
	DC	INIT				; Starting address
	ORG	P:0,P:0
INIT	JMP	<START
	NOP
	ENDIF

	IF	@SCP("DOWNLOAD","ONCE")		; Download via ONCE debugger
	ORG	P:0,P:0
INIT	JMP	<START
	NOP
	ENDIF

; Vectored interrupt table, addresses at the beginning are reserved
	DC	0,0,0,0,0,0,0,0,0,0,0,0,0,0	; $02-$0f Reserved
	DC	0,0				; $11 - IRQA* = FIFO EF*
	DC	0,0				; $13 - IRQB* = FIFO HF*
	JSR	CLEAN_UP_PCI			; $15 - Software reset switch
	DC	0,0,0,0,0,0,0,0,0,0,0,0		; Reserved for DMA and Timer
 	DC	0,0,0,0,0,0,0,0,0,0,0,0		;   interrupts
	JSR	DOWNLOAD_PCI_DSP_CODE		; $2F

; Now we're at P:$30, where some unused vector addresses are located

; This is ROM only code that is only executed once on power-up when the 
;   ROM code is downloaded. It is skipped over on OnCE or PCI downloads.
; Initialize the PLL - phase locked loop
INIT_PCI
	MOVEP	#PLL_INIT,X:PCTL	; Initialize PLL 
	NOP

; Program the PCI self-configuration registers
	MOVE 	#0,X0
	MOVEP	#$500000,X:DCTR		; Set self-configuration mode
	REP	#4
	MOVEP	X0,X:DPAR		; Dummy writes to configuration space
	MOVEP	#>$0000,X:DPMC		; Subsystem ID
	MOVEP	#>$0000,X:DPAR		; Subsystem Vendor ID

; PCI Personal reset
	MOVEP	X0,X:DCTR		; Personal software reset
	NOP
	NOP
	JSET	#HACT,X:DSR,*		; Test for personal reset completion
	MOVE	P:(*+3),X0		; Trick to write "JMP <START" to P:0
	MOVE	X0,P:(0)
	JMP	<START

DOWNLOAD_PCI_DSP_CODE
	BCLR	#IAE,X:DPCR		; Do not insert PCI address with data
DNL0	JCLR	#SRRQ,X:DSR,*		; Wait for a receiver word
	MOVEP	X:DRXR,A		; Read it
	CMP	#$555AAA,A		; Check for sanity header word
	JNE	<DNL0
	MOVE	OMR,A
	AND	#$FFFFF0,A
	OR	#$00000C,A
	NOP
	MOVE	A,OMR			; Set boot mode to $C = PCI
	JMP	$FF0000			; Jump to boot code internal to DSP

	DC	0,0,0,0,0,0,0,0,0,0,0,0	; Filler
	DC	0,0			; $60 - PCI Transaction Termination
	DC	0,0,0,0,0,0,0,0,0	; $62-$71 Reserved PCI
        DC      0,0,0,0,0,0,0
        BCLR    #INTA,X:DCTR            ; $73 - Clear PCI interrupt
        DC      0                       ; Clear interrupt bit


; These interrupts are non-maskable, called from the host with $80xx
	JSR	READ_NUMBER_OF_PIXELS_READ	; $8075
	JSR	CLEAN_UP_PCI			; $8077	
	JSR	ABORT_READOUT			; $8079
	JSR	BOOT_EEPROM			; $807B
	DC	0,0,0,0				; Available

; These vector interrupts are masked at IPL = 1
	JSR	READ_REPLY_HEADER		; $81
	JSR	READ_REPLY_VALUE		; $83
	JSR	CLEAR_HOST_FLAG			; $85
	JSR	RESET_CONTROLLER		; $87
	JSR	READ_IMAGE			; $89
	DC	0,0				; Available
	JSR	WRITE_BASE_PCI_ADDRESS		; $8D

	DC	0,0,0,0				; Available
	DC	0,0,0,0,0,0,0,0,0,0,0,0,0,0
	DC	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0		

; New manual command for Version 1.6
	JSR	WRITE_COMMAND			; $B1

; ******************************************************************
;
;       AA0 = RDFIFO* of incoming fiber optic data
;       AA1 = EEPROM access
;       AA2 = DRAM access
;       AA3 = output to parallel data connector, for a video pixel clock
;       $FFxxxx = Write to fiber optic transmitter
;
; ******************************************************************


START	MOVEP	#>$00001,X:DPMC		; 32-bit PCI <-> 24-bit DSP data
	BSET	#20,X:DCTR		; HI32 mode = 1 => PCI
	BCLR	#21,X:DCTR
	BCLR	#22,X:DCTR
	NOP
	JSET	#12,X:DPSR,*		; Host data transfer not in progress
	NOP
	BSET	#MACE,X:DPCR		; Master access counter enable
	NOP				; End of PCI programming

; Set operation mode register OMR to normal expanded
	MOVEC   #$0000,OMR	; Operating Mode Register = Normal Expanded
	MOVEC	#0,SP		; Reset the Stack Pointer SP

; Move the table of constants from P: space to X: space
	MOVE	#CONSTANTS_TBL_START,R1 	; Start of table of constants 
	MOVE	#2,R0				; Leave X:0 for STATUS
	DO	#CONSTANTS_TBL_LENGTH,L_WRITE
	MOVE	P:(R1)+,X0
	MOVE	X0,X:(R0)+			; Write the constants to X:
L_WRITE

; Program the serial port ESSI0 = Port C for serial transmission to 
;   the timing board
	MOVEP	#>0,X:PCRC	; Software reset of ESSI0
        MOVEP   #$00080B,X:CRA0 ; Divide 100.0 MHz by 24 to get 4.17 MHz
				; DC0-CD4 = 0 for non-network operation
				; WL0-WL2 = ALC = 0 for 2-bit data words
				; SSC1 = 0 for SC1 not used
	MOVEP	#$010120,X:CRB0	; SCKD = 1 for internally generated clock
				; SHFD = 0 for MSB shifted first
				; CKP = 0 for rising clock edge transitions
				; TE0 = 1 to enable transmitter #0
				; MOD = 0 for normal, non-networked mode
				; FSL1 = 1, FSL0 = 0 for on-demand transmit
	MOVEP	#%101000,X:PCRC	; Control Register (0 for GPIO, 1 for ESSI)
				; Set SCK0 = P3, STD0 = P5 to ESSI0
        MOVEP   #%111100,X:PRRC ; Data Direction Register (0 for In, 1 for Out)

        MOVEP   #%000000,X:PDRC ; Data Register - AUX1 = output, AUX3 = input

; Conversion from software bits to schematic labels for Port C and D
;       PC0 = SC00 = AUX3               PD0 = SC10 = EF*
;       PC1 = SC01 = A/B* = input       PD1 = SC11 = HF*
;       PC2 = SC02 = No connect         PD2 = SC12 = RS*
;       PC3 = SCK0 = No connect         PD3 = SCK1 = NWRFIFO*
;       PC4 = SRD0 = AUX1               PD4 = SRD1 = No connect
;       PC5 = STD0 = No connect         PD5 = STD1 = WRFIFO*


; Program the serial port ESSI1 = Port D for general purpose I/O (GPIO)
	MOVEP	#%000000,X:PCRD	; Control Register (0 for GPIO, 1 for ESSI)
        MOVEP   #%011100,X:PRRD ; Data Direction Register (0 for In, 1 for Out)
        MOVEP   #%011000,X:PDRD ; Data Register - Pulse RS* low
	REP	#10
	NOP
        MOVEP   #%011100,X:PDRD


; Program the SCI port to benign values
        MOVEP   #%000,X:PCRE    ; Port Control Register   (0 => GPIO)
        MOVEP   #%110,X:PRRE    ; Port Direction Register (0 => Input)
        MOVEP   #%010,X:PDRE    ; Port Data Register
;	PE0 = RXD
;	PE1 = TXD
;	PE2 = SCLK
;       PE2 = SCLK = XMT SC = Fiber optic transmitter special character when set


; Program the triple timer to assert TCI0 as a GPIO output = 1
	MOVEP	#$2800,X:TCSR0
	MOVEP	#$2800,X:TCSR1
	MOVEP	#$2800,X:TCSR2

; Program the address attribute pins AA0 to AA2. AA3 is not yet implemented.
        MOVEP   #$FFFC21,X:AAR0 ; Y = $FFF000 to $FFFFFF asserts Y:RDFIFO*
        MOVEP   #$008929,X:AAR1 ; P = $008000 to $00FFFF asserts AA1 low true
        MOVEP   #$000122,X:AAR2 ; Y = $000800 to $7FFFFF accesses SRAM



; Program the bus control and DRAM memory access registers
;       MOVEP   #$020022,X:BCR  ; !!! was slower
        MOVEP   #$020021,X:BCR  ; Bus Control Register
        MOVEP   #$893A05,X:DCR  ; DRAM Control Register



; Clear all PCI error conditions
	MOVEP	X:DPSR,A
	OR	#$1FE,A
	NOP
	MOVEP	A,X:DPSR
        MOVE    #0,X0
        MOVE    X0,X:<STATUS    ; Initialize the STATUS variable

; Establish interrupt priority levels IPL
	MOVEP	#$0001C0,X:IPRC	; IRQC priority IPL = 2 (reset switch, edge)
				; IRQB priority IPL = 2 or 0 
				;     (FIFO half full - HF*, level)
	MOVEP	#>2,X:IPRP	; Enable PCI Host interrupts, IPL = 1
	BSET	#HCIE,X:DCTR	; Enable host command interrupts
	MOVE	#0,SR		; Don't mask any interrupts

; Initialize the fiber optic serial transmitter to zero
	JCLR	#TDE,X:SSISR0,*
	MOVEP	#$000000,X:TX00

; Clear out the PCI receiver and transmitter FIFOs
	BSET	#CLRT,X:DPCR		; Clear the master transmitter
	JSET	#CLRT,X:DPCR,*		; Wait for the clearing to be complete	
CLR0	JCLR	#SRRQ,X:DSR,CLR1	; Wait for the receiver to be empty
	MOVEP	X:DRXR,X0		; Read receiver to empty it
	NOP
	JMP	<CLR0
CLR1

; Clear the host buffer size thus disabling wrap mode
	CLR	A
	MOVE	X:<FLAG_DONE,X0		; Flag = 1 => Normal execution
	MOVE	A1,X:<PCI_BUFSIZE_0    ; Non-wrap mode for pci transfer
	MOVE	A0,X:<PCI_BUFSIZE_1    ; Non-wrap mode for pci transfer
	IF	@SCP("RDAFIX","SUPPORTED")	
	MOVE	#2000,A1
	NOP
	MOVE	A1,X:<WAIT_RDA         ; nominal wait in RDA.
	ENDIF


	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
;    This is timer code contributed by one of Bob Leach's users.
;
;    Set up the timer parameters and start the timer
;    We use two timers to generate a combined 45-bit counter.
;       Timer 0 - fine grain timer
;                 this timer is incremented using the internal
;                 clock, so it is incremented at a rate of (CLK/2)
;       Timer 1 - course grain timer
;                 This uses the prescalar, which is set to count to
;                 increment using the internal clock, and set to
;                 trigger when it counts to '$1FFFFF', the maximum
;                 21-bit value.
;    Thus, 'Timer 1' is updated at a frequency '1/2^21' that of 'Timer 0',
;    and consequently the MSB '3' bits of 'Timer 0' and the LSB '3' bits
;    of 'Timer 1' are redundant.  ( Note that to ensure that these '3'
;    bits are actually equal, we need to initially load 'TCR1' with '1'
;    instead of '0', because the value from 'TLR1' is loaded when the
;    prescalar initially triggers, which is after it has already counted
;    to '$1FFFFF' once ).  The redundant '3' bits are actually useful because
;    the two timers cannot be read atomically, so they will indicate if the
;    fine-grain timer has wrapped between the times the two are read.
;
;************************************************************
        BCLR    #TIM_BIT,X:TCSR0        ; Disable the timer
        BCLR    #TIM_BIT,X:TCSR1        ; Disable the timer
        MOVEP   #$1FFFFF,X:TPLR         ; Prescaler to generate msec timer,
                                        ; counting from system clock/2 = 50 MHz
        MOVEP   #$200000,X:TCSR0        ; Clear timer 0 complete bit, 
					; use internal (CLK/2) signal
        MOVEP   #$208000,X:TCSR1        ; Clear timer 1 complete bit, 
					; use prescaler
        MOVEP   #0,X:TLR0               ; Timer load register
        MOVEP   #1,X:TLR1               ; Timer 1 load register - use '1' here 
					; because it is only loaded after 
					;'TPLR' is first decremented down to 0
        BSET    #TIM_BIT,X:TCSR0        ; Enable the timer #0
        BSET    #TIM_BIT,X:TCSR1        ; Enable the timer #1
	ENDIF
   

; Repy = DONE host flags
	MOVE	X0,X:<HOST_FLAG	
	JSR	<FO_WRITE_HOST_FLAG

	IF	@SCP("HISTLOG","SUPPORTED")	
        MOVE    #PCI_HISTFIRST,R3	; hist buffer ptr initialization
	MOVE	R3,X:<PCI_HISTFILL
	ENDIF

	NOP

; ********************************************************************
;
;			REGISTER  USAGE
;
;	X0, X1, Y0, Y1, A and B are used freely in READ_IMAGE. Interrups
;		during readout will clobber these registers, as a result
;		of which only catastrophic commands such as ABORT_READOUT
;		and BOOT_EEPROM are allowed during readout.
;
;	X0, X1 and A are used for all interrupt handling routines, such
;		as CLEAR_HOST-FLAGS, command processing and so on. 
;
;	Y0, Y1 and B are used for all fiber optic processing routines,
;		which are not in interrupt service routines. 
;
; *********************************************************************



; ************  Start of command interpreting code  ******************

; Test for fiber optic data on the FIFO. Discard the header for now

; Check for the header $AC in the first byte = Y0. Wait a little while and
;  clear the FIFO if its not $AC - there was probably noise on the line.
; We assume only two word replies here - Header = (S,D,#words)  Reply

GET_FO	
	IF	@SCP("HISTLOG","SUPPORTED")	
	CLR	B

	MOVE	X:<PCI_HISTFILL,B1
	NOP
	SUB	#PCI_HISTEND,B
	NOP
	JLT     CHK_FO
        MOVE    #PCI_HISTFIRST,B1	; hist buffer ptr wrapped
	NOP
	MOVE	B1,X:<PCI_HISTFILL
	NOP

CHK_FO
	ENDIF

	JCLR	#EF,X:PDRD,GET_FO	; Test for new fiber optic data
	JSR	<RD_FO_TIMEOUT		; Move the FIFO reply into B1
	JCS	<FO_ERR

; Check the header bytes for self-consistency
	MOVE	B1,Y0
	MOVE	#$FCFCF8,B		; Test for S.LE.3 and D.LE.3 and N.LE.7
	AND     Y0,B		
	JNE     <FO_ERR			; Test failed
	MOVE	#$030300,B		; Test for either S.NE.0 or D.NE.0
	AND     Y0,B
       	JEQ     <FO_ERR			; Test failed
	MOVE	#>7,B
	AND	Y0,B			; Extract NWORDS, must be >= 2
	CMP	#1,B
	JLE	<HDR_ERR
	MOVE	Y0,B
	EXTRACTU #$008020,B,B		; Extract bits 15-8 = destination byte
	NOP
	MOVE	B0,X:<FO_DEST

; Check whether this is a self-test header
        MOVE    X:<FO_DEST,B            ; B1 = Destination
        CMP     #2,B
        JEQ     <SELF_TEST              ; Command = $000203 'TDL' value


; Read the reply or command from the fiber optics FIFO
	JSR	<RD_FO_TIMEOUT		; Move the FIFO reply into A1
	JCS	<FO_ERR
	MOVE	B1,X:<FO_CMD

; Check for commands from the controller to the PCI board, FO_DEST = 1
	MOVE	X:<FO_DEST,B
	CMP	#1,B
	JNE	<HOSTCMD
	MOVE	X:<FO_CMD,B
	CMP	#'RDA',B		; Read the image
	JEQ	<READ_IMAGE
	CMP	#'IIA',B
	JEQ	<INITIALIZE_NUMBER_OF_PIXELS ; IPXLS = 0
	CMP	#'RDI',B
	JEQ	<READING_IMAGE		; Controller is reading an image
	CMP	#'RDO',B
	JEQ	<READING_IMAGE_OFF	; Controller no longer reading an image
	JMP	<GET_FO			; Not on the list -> just ignore it

; Check if the command or reply is for the host. If not just ignore it. 
HOSTCMD	MOVE	X:<FO_DEST,B
	CMP	#0,B
	JNE	<GET_FO
	MOVE	X:<FO_CMD,B		; Get the command

	IF	@SCP("HISTLOG","SUPPORTED")	
        MOVE   X:<PCI_HISTFILL,R3	        ; history buffer
	NOP
	NOP
	NOP
	MOVE	B1,Y:(R3)+
	NOP
	MOVE	X:<PCI_HISTON,B
	TST	B
	JEQ    DO_REPLYHST
	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        MOVEP   X:TCR0,Y:(R3)+			; lo order time
        MOVEP   X:TCR1,Y:(R3)+			; hi order time
	ENDIF
	MOVE   R3,X:<PCI_HISTFILL
	NOP
DO_REPLYHST
	MOVE	X:<FO_CMD,B		; Get the command
	NOP
;       the fiber loop wraps PCI_HIST when it gets the chance.
	ENDIF

	CMP	#'DON',B
	JEQ	<CONTROLLER_DONE	; Normal DONE reply
        JSET    #TIMROMBURN,X:STATUS,FO_REPLY   ; If executing TimRomBurn
	CMP	#'ERR',B
	JEQ	<CONTROLLER_ERROR	; Error reply
	CMP	#'BSY',B
	JEQ	<CONTROLLER_BUSY	; Controller is busy executing a command
	CMP	#'SYR',B
	JEQ	<CONTROLLER_RESET	; Controller system reset

; The controller reply is none of the above so return it as a reply
FO_REPLY
	MOVE	B1,X:<REPLY		; Report value
	MOVE	X:<FLAG_REPLY,Y0	; Flag = 2 => Reply with a value
	MOVE	Y0,X:<HOST_FLAG	
	JSR	<FO_WRITE_HOST_FLAG
	JMP	<GET_FO

CONTROLLER_DONE
	MOVE	X:<FLAG_DONE,Y0		; Flag = 1 => Normal execution
	MOVE	Y0,X:<HOST_FLAG	
	JSR	<FO_WRITE_HOST_FLAG
	JMP	<GET_FO			; Keep looping for fiber optic commands

CONTROLLER_ERROR
	MOVE	X:<FLAG_ERR,Y0		; Flag = 3 => controller error
	MOVE	Y0,X:<HOST_FLAG	
	JSR	<FO_WRITE_HOST_FLAG
	JMP	<GET_FO			; Keep looping for fiber optic commands

CONTROLLER_RESET
	MOVE	X:<FLAG_SYR,Y0		; Flag = 4 => controller reset
	MOVE	Y0,X:<HOST_FLAG	
	JSR	<FO_WRITE_HOST_FLAG
	JMP	<GET_FO			; Keep looping for fiber optic commands

CONTROLLER_BUSY
	MOVE	X:<FLAG_BUSY,Y0	; Flag = 6 => controller busy
	MOVE	Y0,X:<HOST_FLAG	
	JSR	<FO_WRITE_HOST_FLAG
	JMP	<GET_FO			; Keep looping for fiber optic commands

; A special handshaking here ensures that the host computer has read the 'DON'
;   reply to the start_exposure command before the reading_image state is
;   set in the host flags. Reading_image occurs only after a start_exposure
READING_IMAGE

	IF	@SCP("HISTLOG","SUPPORTED")	
	MOVE	X:<PCI_HISTON,B
	TST	B
	JEQ    DO_IMG
        MOVE   X:<PCI_HISTFILL,R3	        ; history buffer
	NOP
	MOVE	#F_READING_IMAGE,R4		; tag
	NOP
	MOVE	R4,Y:(R3)+
	NOP
	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        MOVEP   X:TCR0,Y:(R3)+			; lo order time
        MOVEP   X:TCR1,Y:(R3)+			; hi order time
	ENDIF

	MOVE   R3,X:<PCI_HISTFILL
DO_IMG
	ENDIF

READING_IMG
	MOVE	X:<HOST_FLAG,B		; Retrieve current host flag value
	MOVE	X:<FLAG_RDI,X0
	CMP	X0,B			; If we're already in read_image 
	JEQ	<GET_FO			;   mode then do nothing
	TST	B			; Wait for flag to be cleared, which
	JNE	<READING_IMG		;  the host does when it gets the DONE

	BCLR	#HCIE,X:DCTR		; Disable host command interrupts
	MOVE	X:<FLAG_RDI,Y0
	MOVE	Y0,X:<HOST_FLAG
	JSR	<FO_WRITE_HOST_FLAG	; Set Host Flag to "reading out"
	JMP	<GET_FO			; Keep looping for fiber optic commands

READING_IMAGE_OFF			; Controller is no longer reading out
	MOVE	X:<FLAG_ZERO,Y0
	MOVE	Y0,X:<HOST_FLAG
	JSR	<FO_WRITE_HOST_FLAG
	BSET	#HCIE,X:DCTR		; Enable host command interrupts
	JMP	<GET_FO			; Keep looping for fiber optic commands

; Write X:<HOST_FLAG to the DCTR flag bits 5,4,3, as a subroutine
FO_WRITE_HOST_FLAG
	MOVE	X:DCTR,B
	MOVE	X:<HOST_FLAG,Y0	
	AND	#$FFFFC7,B		; Clear bits 5,4,3
	NOP
	OR	Y0,B			; Set flags appropriately
	NOP
	MOVE	B,X:DCTR
	RTS

; There was an erroneous header word on the fiber optic line
HDR_ERR MOVE    #'HDR',Y0
        MOVE    Y0,X:<REPLY             ; Set REPLY = header as a diagnostic
        MOVE    X:<FLAG_REPLY,Y0        ; Flag = 2 => Reply with a value
        MOVE    Y0,X:<HOST_FLAG
        JSR     <FO_WRITE_HOST_FLAG
        JMP     <GET_FO

; There was an erroneous word on the fiber optic line -> clear the FIFO 
FO_ERR	MOVEP	#%010000,X:PDRD		; Clear FIFO RESET* for 2 milliseconds
	MOVE	#200000,Y0
	DO	Y0,*+3
	NOP
	MOVEP	#%010100,X:PDRD		; Data Register - Set RS* high
	JMP	<GET_FO

; Connect PCI board fiber out <==> fiber in and execute 'TDL' timing board
SELF_TEST
        JSR     <RD_FO_TIMEOUT          ; Move the 'COMMAND' into B1
        JCS     <FO_ERR
        CMP     #'TDL',B
        JNE     <CONTROLLER_ERROR       ; Must be 'TDL' if destination = 2
        JSR     <RD_FO_TIMEOUT          ; Move the argument into B1
        JCS     <FO_ERR
        JMP     <FO_REPLY               ; Return argument as the reply value



; **************  Boot from byte-wide on-board EEPROM  *******************

BOOT_EEPROM
        MOVEP   #$0202A0,X:BCR          ; Bus Control Register for slow EEPROM
	MOVE	OMR,A
	AND	#$FFFFF0,A
	OR	#$000009,A		; Boot mode = $9 = byte-wide EEPROM
	NOP
	MOVE	A,OMR	
	JMP	$FF0000			; Jump to boot code internal to DSP

; ***************  Command processing  ****************

WRITE_COMMAND
;	JCLR	#SRRQ,X:DSR,ERROR	; Error if receiver FIFO has no data
	JSET	#SRRQ,X:DSR,WCSTG1	; Error if receiver FIFO has no data
	MOVE	#F_WCMDSTG1,A
	JMP	<WC_ERROR
        
WCSTG1
	MOVEP	X:DRXR,A		; Get the header
	NOP				; Pipeline restriction
	MOVE	A1,X:<HEADER

; Check the header bytes for self-consistency
	MOVE	A1,X0
	MOVE	#$FCFCF8,A		; Test for S.LE.3 and D.LE.3 and N.LE.7
	AND     X0,A		
;	JNE     <ERROR			; Test failed
 	JEQ	<WCSTG2				
	MOVE	#F_WCMDSTG2,A		; Test failed, illegal bits set
	JMP	<WC_ERROR

WCSTG2
	MOVE	#$030300,A		; Test for either S.NE.0 or D.NE.0
	AND     X0,A
;      	JEQ     <ERROR			; Test failed- both 0
 	JNE	<WCSTG3		
	MOVE	#F_WCMDSTG3,A		; Test failed- both 0
	JMP	<WC_ERROR

WCSTG3
	MOVE	#>7,A
	AND	X0,A			; Extract NUM_ARG, must be >= 0
	NOP				; Pipeline restriction
	SUB	#2,A
;	JLT	<ERROR			; Number of arguments >= 0
	JGE	<WCSTG4			; Number of arguments >= 1
	MOVE	#F_WCMDSTG4,A
	JMP	<WC_ERROR

WCSTG4
	MOVE	A1,X:<NUM_ARG		; Store number of arguments in command
	CMP	#6,A			; Number of arguments <= 6
;	JGT	<ERROR
	JLE	<WCSTG5			
	MOVE	#F_WCMDSTG5,A		; too many arguments
	JMP	<WC_ERROR

WCSTG5
; Get the DESTINATION number (1 = PCI, 2 = timing, 3 = utility)
	MOVE	X0,A			; Still the header
	LSR	#8,A
	AND	#>3,A			; Extract just three bits of 
	MOVE	A1,X:<DESTINATION	;   the destination byte
;	JEQ	<ERROR			; Destination of zero = host not allowed
	JNE	<WCSTG6			; Destination of zero = host not allowed
	MOVE	#F_WCMDSTG6,A		; destination = host

WC_ERROR
	IF	@SCP("HISTLOG","SUPPORTED")	
        MOVE   X:<PCI_HISTFILL,R3	        ; history buffer
	NOP
	NOP
	NOP
	MOVE	A1,Y:(R3)+
	NOP
	MOVE	X:<PCI_HISTON,A
	TST	A
	JEQ    <DO_FIFO0
	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        MOVEP   X:TCR0,Y:(R3)+			; lo order time
        MOVEP   X:TCR1,Y:(R3)+			; hi order time
	ENDIF
	MOVE   R3,X:<PCI_HISTFILL
	NOP

;       the fiber loop wraps PCI_HIST when it gets the chance.
	ENDIF

DO_FIFO0
;       now clear out anything remaining in the fifo. If history is on, the
;       second parameter (or the first if only 1) will be logged, assuming
;       anything is there at all. It's really a violation of the command
;       protocol and should never occur.
	JCLR	#SRRQ,X:DSR,DO_ERROR	; Is the receiver empty?

	MOVEP	X:DRXR,A0		; Read receiver to empty one word
	NOP				; wait for flag to toggle
	JCLR	#SRRQ,X:DSR,LOG_RCV0	; If now empty, go log parameter 1.
	MOVEP	X:DRXR,A0		; Read receiver to empty one word
	NOP				; wait for flag to toggle
LOG_RCV0

	IF	@SCP("HISTLOG","SUPPORTED")	
        MOVE   X:<PCI_HISTFILL,R3	        ; history buffer
	NOP
	NOP
	NOP
	MOVE	A0,Y:(R3)+
	NOP
	MOVE	X:<PCI_HISTON,A
	TST	A
	JEQ    DO_ENDFIFO0
	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        MOVEP   X:TCR0,Y:(R3)+			; lo order time
        MOVEP   X:TCR1,Y:(R3)+			; hi order time
	ENDIF
	MOVE   R3,X:<PCI_HISTFILL
	NOP

;       the fiber loop wraps PCI_HIST when it gets the chance.
	ENDIF

DO_ENDFIFO0
	JCLR	#SRRQ,X:DSR,DO_ERROR	; Wait for the receiver to be empty
	MOVEP	X:DRXR,A0		; Read receiver to empty one word
	NOP				; wait for flag to toggle
	JMP	DO_ENDFIFO0


DO_ERROR
	JMP	<ERROR		; various errors in cmd recognition

WCSTG6

	CMP	#1,A			; Destination byte for PCI board
	JEQ	<PCI

; Write the controller command and its arguments to the fiber optics
	MOVE	X:<HEADER,A
	JSR	XMT_WRD			; Write the word to the fiber optics
	JCLR	#SRRQ,X:DSR,ERROR	; Error if receiver FIFO has no data
	MOVEP	X:DRXR,A		; Write the command
	JSR	<XMT_WRD		; Write the command to the fiber optics

	IF	@SCP("HISTLOG","SUPPORTED")	
        MOVE   X:<PCI_HISTFILL,R3	        ; history buffer
	NOP
	NOP
	NOP
	MOVE	A1,Y:(R3)+
	NOP
	MOVE	X:<PCI_HISTON,A
	TST	A
	JEQ    DO_ARGS
	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        MOVEP   X:TCR0,Y:(R3)+			; lo order time
        MOVEP   X:TCR1,Y:(R3)+			; hi order time
	ENDIF
	MOVE   R3,X:<PCI_HISTFILL
	NOP
DO_ARGS
;       the fiber loop wraps PCI_HIST when it gets the chance.
	ENDIF

	DO	X:<NUM_ARG,L_ARGS1	; Do loop won't execute if NUM_ARG = 0 
	MOVEP	X:DRXR,A		; Get the arguments
	JSR	<XMT_WRD		; Write the argument to the fiber optics
	NOP				; DO loop restriction
L_ARGS1	
;       now clear out anything remaining in the fifo. If history is on, the
;       second parameter (or the first if only 1) will be logged, assuming
;       anything is there at all. It's really a violation of the command
;       protocol and should never occur.
	JCLR	#SRRQ,X:DSR,END_CMCTRLR	; Is the receiver empty?

	MOVEP	X:DRXR,A0		; Read receiver to empty one word
	NOP				; wait for flag to toggle
	JCLR	#SRRQ,X:DSR,LOG_RCV1	; If now empty, go log parameter 1.
	MOVEP	X:DRXR,A0		; Read receiver to empty one word
	NOP				; wait for flag to toggle
LOG_RCV1

	IF	@SCP("HISTLOG","SUPPORTED")	
        MOVE   X:<PCI_HISTFILL,R3	        ; history buffer
	NOP
	NOP
	NOP
	MOVE	A0,Y:(R3)+
	NOP
	MOVE	X:<PCI_HISTON,A
	TST	A
	JEQ    DO_ENDFIFO1
	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        MOVEP   X:TCR0,Y:(R3)+			; lo order time
        MOVEP   X:TCR1,Y:(R3)+			; hi order time
	ENDIF
	MOVE   R3,X:<PCI_HISTFILL
	NOP
	NOP

;       the fiber loop wraps PCI_HIST when it gets the chance.
	ENDIF

DO_ENDFIFO1
	JCLR	#SRRQ,X:DSR,END_CMCTRLR ; Wait for the receiver to be empty
	MOVEP	X:DRXR,A0		; Read receiver to empty one word
	NOP				; wait for flag to toggle
	JMP	DO_ENDFIFO1

END_CMCTRLR
	RTI				; The other board will generate reply

; Since it's a PCI command store the command and its arguments in X: memory
PCI	JCLR	#SRRQ,X:DSR,ERROR	; Error if receiver FIFO has no data
	MOVEP	X:DRXR,X:COMMAND	; Get the command
	MOVE	X:<NUM_ARG,A		; Get number of arguments in command
	MOVE	#ARG1,R0		; Starting address of argument list
	DO	A,L_ARGS2		; DO loop won't execute if A = 0
	JCLR	#SRRQ,X:DSR,ERROR	; Error if receiver FIFO has no data
	MOVEP	X:DRXR,X:(R0)+		; Get arguments
L_ARGS2

;       now clear out anything remaining in the fifo. If history is on, the
;       second parameter (or the first if only 1) will be logged, assuming
;       anything is there at all. It's really a violation of the command
;       protocol and should never occur.
	JCLR	#SRRQ,X:DSR,PCI_COMMAND	; Is the receiver empty?

	MOVEP	X:DRXR,A0		; Read receiver to empty one word
	NOP				; wait for flag to toggle
	JCLR	#SRRQ,X:DSR,LOG_RCV2	; If now empty, go log parameter 1.
	MOVEP	X:DRXR,A0		; Read receiver to empty one word
	NOP				; wait for flag to toggle
LOG_RCV2

	IF	@SCP("HISTLOG","SUPPORTED")	
        MOVE   X:<PCI_HISTFILL,R3	        ; history buffer
	NOP
	NOP
	NOP
	MOVE	A0,Y:(R3)+
	NOP
	MOVE	X:<PCI_HISTON,A
	TST	A
	JEQ    DO_ENDFIFO2
	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        MOVEP   X:TCR0,Y:(R3)+			; lo order time
        MOVEP   X:TCR1,Y:(R3)+			; hi order time
	ENDIF
	MOVE   R3,X:<PCI_HISTFILL
	NOP

;       the fiber loop wraps PCI_HIST when it gets the chance.
	ENDIF

DO_ENDFIFO2
	JCLR	#SRRQ,X:DSR,PCI_COMMAND    ; Wait for the receiver to be empty
	MOVEP	X:DRXR,A0		; Read receiver to empty one word
	NOP				; wait for flag to toggle
	JMP	DO_ENDFIFO2


; Process a PCI board non-vector command
PCI_COMMAND
	MOVE	X:<COMMAND,A		; Get the command

	IF	@SCP("HISTLOG","SUPPORTED")	
        MOVE   X:<PCI_HISTFILL,R3	        ; history buffer
	NOP
	NOP
	NOP
	MOVE	A1,Y:(R3)+
	NOP
	MOVE	X:<PCI_HISTON,A
	TST	A
	JEQ    DO_CMDPCI
	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        MOVEP   X:TCR0,Y:(R3)+			; lo order time
        MOVEP   X:TCR1,Y:(R3)+			; hi order time
	ENDIF
	MOVE   R3,X:<PCI_HISTFILL
	NOP
DO_CMDPCI
	MOVE	X:<COMMAND,A		; Get the command
	NOP
;       the fiber loop wraps PCI_HIST when it gets the chance.
	ENDIF

	CMP	#'TRM',A		; Is it the test DRAM command?
	JEQ	<TEST_DRAM
	CMP	#'TDL',A		; Is it the test data link command?
	JEQ	<TEST_DATA_LINK
	CMP	#'RDM',A
	JEQ	<READ_MEMORY		; Is it the read memory command?
	CMP	#'WRM',A
	JEQ	<WRITE_MEMORY		; Is it the write memory command?

	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        CMP     #'GTK',A
        JEQ     <GET_TICK               ; Is it Get Ticks?
	ENDIF
        CMP     #'INF',A
        JEQ     <GET_INFO               ; Is it Get Info?

	JMP	<ERROR			; Its not a recognized command

; ********************  Vector commands  *******************

READ_NUMBER_OF_PIXELS_READ		; Write the reply to the DTXS FIFO

	IF	@SCP("HISTLOG","SUPPORTED")	
        MOVE    X:<PCI_HISTFILL,R3     ; history buffer
	NOP
	MOVE	#H_RDNUMPIX,R4
	MOVE    R4,Y:(R3)+     ; tag
;       the main readout loop wraps PCI_HISTFILL when it gets the chance.
	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        MOVEP   X:TCR0,Y:(R3)+          ; lo order time
        MOVEP   X:TCR1,Y:(R3)+			; hi order time
	ENDIF
	NOP
        MOVE	R3,X:<PCI_HISTFILL
	NOP
	ENDIF

        JSET	#0,X:<R_PXLS_CRIT,SEND_RPXLS_LAST	;are R_PXLS 'safe'?

	MOVEP	X:R_PXLS_0,X:DTXS	; DSP-to-host slave transmit
	NOP
	MOVEP	X:R_PXLS_1,X:DTXS	; DSP-to-host slave transmit

	RTI

;       use the safe copy in RPXLS_SAFE
SEND_RPXLS_LAST
        MOVE    #RPXLS_SAFE,R5
        BSET	#1,X:<R_PXLS_CRIT	; mark race as having happened
	NOP
	MOVEP	Y:(R5)+,X:DTXS		;DSP-to-host slave transmit
	NOP
	MOVEP	Y:(R5)+,X:DTXS		;DSP-to-host slave transmit

	RTI

; Reset the controller by transmitting a special byte code
RESET_CONTROLLER
        BSET    #SCLK,X:PDRE            ; Enable special command mode
        NOP
        NOP
        MOVE    #$FFF000,R0             ; Memory mapped address of transmitter
        MOVE    #$10000B,X0             ; Special command to reset controller
        MOVE    X0,X:(R0)
        REP     #6                      ; Wait for transmission to complete
        NOP
        BCLR    #SCLK,X:PDRE            ; Disable special command mode

; Wait until the timing board is reset, because FO data is invalid
        MOVE    #10000,X0               ; Delay by about 350 milliseconds
        DO      X0,L_DELAY
        DO      #1000,L_RDFIFO
        MOVEP   Y:RDFIFO,Y0             ; Read the FIFO word to keep the
        NOP                             ;   receiver empty
L_RDFIFO
        NOP
L_DELAY
        NOP

; Wait for 'SYR' from the controller, with a 260 millisecond timeout
        DO      #20,L_WAIT_SYR
        JSR     <RD_FO_TIMEOUT          ; Move the FIFO reply into B1
        JCS     <L_WAIT_SYR-1
        ENDDO
        JMP     <L_SYS
        NOP
L_WAIT_SYR
        JMP     <ERROR                  ; Timeout, respond with error

L_SYS   CMP     #$020002,B
        JNE     <ERROR                  ; There was an error
        JSR     <RD_FO_TIMEOUT          ; Move the FIFO reply into B1
        JCS     <ERROR
        CMP     #'SYR',B
        JNE     <ERROR                  ; There was an error
        JMP     <SYR                    ; Reply to host, return from interrupt


; ****************  Exposure and readout commands  ****************

WRITE_BASE_PCI_ADDRESS
	JCLR	#SRRQ,X:DSR,ERROR	; Error if receiver FIFO has no data
	MOVEP	X:DRXR,A0
	JCLR	#SRRQ,X:DSR,ERROR	; Error if receiver FIFO has no data
	MOVEP	X:DRXR,X0		; Get most significant word
	INSERT	#$010010,X0,A
	NOP
	MOVE	A0,X:<BASE_ADDR_0	; BASE_ADDR is 8 + 24 bits
	MOVE	A1,X:<BASE_ADDR_1

	IF	@SCP("HISTLOG","SUPPORTED")	
	MOVE	X:<PCI_HISTON,A
	TST	A
	JEQ    DO_DON
        MOVE   X:<PCI_HISTFILL,R3	        ; history buffer
	NOP
	MOVE	#H_BASEPCIADDR,R4		; tag
	MOVE	R4,Y:(R3)+
	NOP
	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        MOVEP   X:TCR0,Y:(R3)+			; lo order time
        MOVEP   X:TCR1,Y:(R3)+			; hi order time
	ENDIF
	MOVE   R3,X:<PCI_HISTFILL
DO_DON
	ENDIF

;       the fiber loop wraps PCI_HIST when it gets the chance.
	JMP 	<FINISH			; Write 'DON' reply

; Write the base PCI image address to the PCI address
INITIALIZE_NUMBER_OF_PIXELS

	IF	@SCP("HISTLOG","SUPPORTED")	
	MOVE	X:<PCI_HISTON,A
	TST	A
	JEQ    DO_NPIX
        MOVE   X:<PCI_HISTFILL,R3	        ; history buffer
	NOP
	MOVE	#F_INIT_NO_PIX,R4		; tag
	NOP
	MOVE	R4,Y:(R3)+
	NOP
	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        MOVEP   X:TCR0,Y:(R3)+			; lo order time
        MOVEP   X:TCR1,Y:(R3)+			; hi order time
	ENDIF
	MOVE   R3,X:<PCI_HISTFILL
DO_NPIX
	ENDIF

	CLR	A
	NOP
	MOVE	A1,X:<R_PXLS_1		; Up counter of number of pixels read
	MOVE	A0,X:<R_PXLS_0
 	MOVE	A0,X:<R_PXLS_CRIT	; mark safe
 	MOVE	A0,X:<R_PXLS_RACE	; clear stats

	MOVE	X:<BASE_ADDR_0,A0	; BASE_ADDR is 2 x 16-bits
	MOVE	X:<BASE_ADDR_1,A1
	NOP
	MOVE	A0,X:<PCI_ADDR_0	; PCI_ADDR is 8 + 24 bits
	MOVE	A1,X:<PCI_ADDR_1


	JMP 	<CONTROLLER_DONE	; Repy = DONE host flags

; Send an abort readout command to the controller to stop image transmission
ABORT_READOUT
	MOVE	X:<FLAG_DONE,X0
	MOVE	X0,X:<HOST_FLAG	
	JSR	<FO_WRITE_HOST_FLAG

	MOVE	X:<C000202,A
	JSR	<XMT_WRD		; Timing board header word
	MOVE	#'ABR',A
	JSR	<XMT_WRD		; Abort Readout

       CLR      A

ABR0   ADD      #>1,A
; Ensure that image data is no longer being received from the controller
	JCLR	#EF,X:PDRD,ABR2		; Test for incoming FIFO data
ABR1	MOVEP	Y:RDFIFO,X0		; Read the FIFO until its empty
	NOP
	JSET	#EF,X:PDRD,ABR1
ABR2	DO	#2400,ABR3		; Wait for about 30 microsec in case
	NOP				;   FIFO data is still arriving
ABR3	JSET	#EF,X:PDRD,ABR1		; Keep emptying if more data arrived
	MOVE	A1,X:<ABT_PIXELS
	DO	#4095,PUNT		; Wait 
	NOP
PUNT	NOP

; Wait for a 'DON' reply from the controller
        JSR     <RD_FO_TIMEOUT          ; Move the FIFO reply into B1
        JCS     <ERROR
        CMP     #$020002,B
        JNE     <ERROR                  ; There was an error
        JSR     <RD_FO_TIMEOUT          ; Move the FIFO reply into B1
        JCS     <ERROR
        CMP     #'DON',B
        JNE     <ERROR                  ; There was an error



; Clean up the PCI board from wherever it was executing
CLEAN_UP_PCI
	MOVEP	#$0001C0,X:IPRC		; Disable HF* FIFO interrupt
	BSET	#HCIE,X:DCTR		; Enable host command interrupts
	MOVEC	#1,SP			; Point stack pointer to the top	
	MOVEC	#$000200,SSL		; SR = zero except for interrupts
	MOVEC	#0,SP			; Writing to SSH preincrements the SP
	MOVEC	#START,SSH		; Set PC to for full initialization
	NOP
	RTI

; Read the image - change the serial receiver to expect 16-bit (image) data
READ_IMAGE

	IF	@SCP("RDAFIX","SUPPORTED")	
	; give the host a chance to clear host flags (FWIW).
	DO	X:<WAIT_RDA,*+3	; Do loop won't execute if WAIT_RDA = 0 
	NOP
	ENDIF

	BCLR	#HCIE,X:DCTR		; Disable host command interrupts
	MOVE	X:<FLAG_RDI,X0
	MOVE	X0,X:<HOST_FLAG
	JSR	<FO_WRITE_HOST_FLAG	; Set HCTR bits to "reading out"
	MOVEP	X:DPSR,A		; Clear all PCI error conditions
	OR	#$1FE,A
	NOP
	MOVEP	A,X:DPSR
	BSET	#CLRT,X:DPCR		; Clear the master transmitter FIFO
	JSET	#CLRT,X:DPCR,*		; Wait for the clearing to be complete

	IF	@SCP("HISTLOG","SUPPORTED")	
	MOVE	X:<PCI_HISTON,A
	TST	A
	JEQ    DO_PXL
        MOVE   X:<PCI_HISTFILL,R3	        ; history buffer
	NOP
	MOVE	#F_READ_IMAGE,R4		; tag
	NOP
	MOVE	R4,Y:(R3)+
	NOP
	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        MOVEP   X:TCR0,Y:(R3)+			; lo order time
        MOVEP   X:TCR1,Y:(R3)+			; hi order time
	ENDIF
	MOVE   R3,X:<PCI_HISTFILL
DO_PXL
	ENDIF


; Compute the number of pixels to read from the controller
	JSR	<RD_FO_TIMEOUT		; Read number of columns 
	JCS	<FO_ERR
	MOVE	B1,X1
	JSR	<RD_FO_TIMEOUT		; Read number of rows
	JCS	<FO_ERR
	MOVE	B1,Y1			; Number of rows to read is in Y1
	MPY	X1,Y1,A
	ASR	A			; Correct for 0 in LS bit after MPY
	NOP
	MOVE	A1,X:<NPXLS_1		; NPXLS set by controller
	MOVE	A0,X:<NPXLS_0

	; Make sure the PCI address is on a 512 pixel boundary
        MOVE    X:<PCI_ADDR_0,A         ; Current PCI address
        AND     #$0003FF,A              ; If addr .and. $3FF .ne. 0 then
        JEQ     <IM_INIT                ;   addr = (addr + $400) .and. $FFFC00
        MOVE    X:<PCI_ADDR_1,A1
        MOVE    X:<PCI_ADDR_0,A0
        MOVE    #0,X1
        MOVE    #$400,X0
        ADD     X,A
        NOP
        MOVE    A1,X:<PCI_ADDR_1
        MOVE    A0,B1
        AND     #$FFFC00,B
        NOP
        MOVE    B1,X:<PCI_ADDR_0

IM_INIT CLR     B
;     a pad of zeroes as sentinel if we overrun on the DMA phase.
;     clear the whole image buffer and again as much beyond.
        MOVE    #IMAGE_BUFER,R1
        DO	#2000,Z_BUFFER
        MOVE	B1,Y:(R1)+
Z_BUFFER
        MOVE    #PCI_ERRLOGFIRST,R2	; error buffer to record pci dma events
	MOVE	B1,X:<PCI_BURST_NO	; overall count of pci bursts completed
        MOVE    B1,X:<IPXLS_1           ; IPXLS = 0
        MOVE    B0,X:<IPXLS_0
        MOVE    B0,X1                   ; X = 512 = 1/2 the FIFO depth
        MOVE    X:<C512,X0
        MOVE    #RDFIFO,R6

							
; There are four separate stages of writing the image to the PCI bus
;	a. Write complete 512 pixel FIFO half full blocks
;	b. Write the pixels left over from the last complete FIFO block
;               in blocks of 32 pixels
;       c. Write the pixels left over from the last 32 pixel block
;       d. If the number of pixels in the image is odd write the very last pixel


; Compute the number of pixel pairs from the FIFO --> PCI bus
L_FIFO	

	IF	@SCP("HISTLOG","SUPPORTED")	
	CLR	A

        MOVE   X:<PCI_HISTFILL,A1
	NOP
	SUB	#PCI_HISTEND,A
	NOP
	JLT     CHK_FO_RDO
        MOVE    #PCI_HISTFIRST,A1	; hist buffer ptr wrapped
	NOP
	MOVE	A1,X:<PCI_HISTFILL
	ENDIF

CHK_FO_RDO
	CLR	A
	MOVE	X:<NPXLS_1,A1		; Number of pixels to write to PCI
	MOVE	X:<NPXLS_0,A0
	MOVE	X:<IPXLS_1,Y1		; Compare it to image pixels written.
	MOVE	X:<IPXLS_0,Y0
	NOP
	SUB	Y,A			; If (Image size - Ipxls)  <= 512 
	NOP				;   we're at the end of the image
	SUB	X,A
	JLE	<WRITE_LAST_LITTLE_BIT_OF_IMAGE


; (a) New DMA writing in burst mode, 128 pixels in a burst
WR_IMAGE
;	BSET	#4,X:PDRC
	JSET	#HF,X:PDRD,*		; Wait for FIFO to be half full + 1
	NOP
	NOP
	JSET	#HF,X:PDRD,WR_IMAGE	; Protection against metastability
;	BCLR	#4,X:PDRC

; Priming the pump:
; Copy part of the fiber optic FIFO load  (512 pixels) to DSP Y: memory
; We need a PCIBURST worth of pixels before we can  start a transfer to the bus.
        MOVE    #IMAGE_BUFER,R0
	MOVE	R0,R1			;R0,R1 to 'FIRST'


;	BSET	#4,X:PDRC
        DO      #PCIBURST,L_BUFFER
        MOVEP   Y:RDFIFO,Y:(R0)+
L_BUFFER
        
; Priming the pump:
; Prepare the HI32 DPMC and DPAR address registers
        MOVE    X:<PCI_ADDR_1,A1        ; Current PCI address
        MOVE    X:<PCI_ADDR_0,A0
        ASL     #8,A,A
        NOP
        ORI     #$3F0000,A              ; Burst length = # of PCI writes (!!!)
        NOP                             ;   = # of pixels / 2 - 1 
        MOVE    A1,X:DPMC               ; DPMC = B[31:16] + $070000
        ASL     #16,A,A                 ; Get PCI_ADDR[15:0] into A1[15:0]
        NOP
        AND     #$00FFFF,A              ; Making sure it is just 16bits 
        NOP
        OR      #$070000,A              ; A1 will get written to DPAR register
; Make sure its always 512 pixels per loop = 1/2 FIFO (4 bursts -> PCI)
        MOVE    R1,X:DSR0               ; Source address for DMA = pixel data
        MOVEP   #DTXM,X:DDR0            ; Destination = PCI master transmitter
        MOVEP   #>127,X:DCO0            ; DMA Count = # of pixels - 1 (!!!)
	MOVEP   #$8EFA51,X:DCR0         ; Start DMA with control register DE=1
        MOVEP   A1,X:DPAR               ; Initiate writing to the PCI bus
;       NOP
;       NOP

; At  this point we have a PCI transfer underway to be checked later.
; Enter the main loop which interleaves FO and PCI transfers.
; R0 is now the 'FILL' ptr for the image buffer, and R1
; is the empty ptr.  (R1 only reflects DMA successfully completed)
; A0,1 holds the pci address
; X0 holds a constant 512.


; 	BCLR	#4,X:PDRC
NEXTBURST
; First try to read out the fiber optic. We want to read at least enough
; to have one more pci burst worth ready to go (beyond the pci transfer
; ongoing) but we cannot read past the 512 pixel limit authorized by the
; HF flag on the fifo.
	CLR	B
	MOVE	R0,B1
	SUB	#IMAGE_BUFER,B   ; FILL - FIRST == available data (no wrap)
	SUB	#FOBURST,B
	JGE 	<PCIXFERPOLL		; No more pixels in this empty of FO.
	CLR	B
	MOVE    R1,Y0
	MOVE	R0,B1
	NOP
	SUB	Y0,B			;FILL- EMPTY == data not DMA'd (! wrap)
	NOP
	MOVE	B1,Y0			; Image bytes already available for pci
	CLR	B
	MOVE	#PCI2BURST,B		; want enough more for additional burst
	SUB 	Y0,B
	JLE	<PCIXFERPOLL
	DO	B1,FOXFER
	MOVEP   Y:RDFIFO,Y:(R0)+
FOXFER	
; we are guaranteed to have a transfer waiting here.
PCIXFERPOLL
        JCLR    #MARQ,X:DPSR,*          ; Wait until the PCI operation is done
; 	BCLR	#4,X:PDRC
        JSET    #MDT,X:DPSR,WR_OK0      ; If no error go to the next sub-block
;	BSET	#4,X:PDRC
        JSR     <PCI_ERROR_RECOVERY     ; clear h/w and then do the retry.
WR_OK0  ADD     #>256,A                 ; PCI address = + 2 x # of pixels (!!!)
	CLR	B
	MOVE	R1,B1			; update R1 for the image buffer addr
	NOP
	ADD	#>128,B			; corresponding to the next pci block
	NOP
	MOVE	B1,R1
	CLR	B
	MOVE	X:<PCI_BURST_NO,B1	;increment count of pci burst
	ADD	#>1,B
	NOP
	MOVE	B1,X:<PCI_BURST_NO

;	BCLR	#4,X:PDRC
STARTBURST
;       Is the DMA pending in the image buffer done here?
	CLR	B
	MOVE    R1,Y0
	MOVE	R0,B1
	SUB	Y0,B
	JEQ	CHECKENDBURST
;       No go to the next burst block.
	BSET	#CLRT,X:DPCR		; Clear the master transmitter
	JSET	#CLRT,X:DPCR,*		; Wait for the clearing to be complete	
        MOVEP   #$8EFA51,X:DCR0         ; Start DMA with control register DE=1
        MOVEP   A1,X:DPAR               ; Initiate writing to the PCI bus
        NOP
        NOP
	JMP	NEXTBURST
CHECKENDBURST
	; there's no more bytes to dma, check FO fill progress
	CLR	B
	MOVE	R0,B1
	SUB	#IMAGE_BUFER,B
	SUB	#FOBURST,B
	JLT 	NEXTBURST
; DMA is done and 512 bytes emptied.


;	BCLR	#4,X:PDRC
; Re-calculate and store the PCI address where image data is being written to
	CLR	A
	MOVE	X:<IPXLS_0,A0		; Number of pixels to write to PCI
	MOVE	X:<IPXLS_1,A1
	ADD	X,A			; X = 512 = 1/2 FIFO size
	NOP
	MOVE	A0,X:<IPXLS_0		; Number of pixels to write to PCI
	MOVE	A1,X:<IPXLS_1
	MOVE    X:<PCI_ADDR_1,A1        ; Current PCI address
	MOVE    X:<PCI_ADDR_0,A0
	ADD     X,A                     ; Add the byte increment = 1024
	ADD     X,A

	NOP
	MOVE    A1,X:<PCI_ADDR_1        ; Incremented current PCI address
	MOVE    A0,X:<PCI_ADDR_0

	JSR	<C_RPXLS		; Calculate number of pixels read
	JMP	<L_FIFO			; Go process the next 1/2 FIFO

; (b) Write the pixels left over, in 32 pixel blocks
WRITE_LAST_LITTLE_BIT_OF_IMAGE
	CLR 	B
	ADD	X,A			; Exit if there are no more pixels
	TST	A
	JLE	<ALLDONE
	MOVE     #>31,B0
	MOVE	A0,X:<NUM_PIX		; Number of pixels in the last block
;	ADD	#>31,A			; round up to next 32 pixel block
	MOVE	B1,Y1
	MOVE	B0,Y0
	NOP
	ADD	Y,A
	NOP
	
	ASR	#5,A,A
	NOP		
	MOVE	A0,X:<NUM_BLOCKS	; Number (upper) of small blocks at end
	CLR	A		        ; being safe (?)
	MOVE	X:<NUM_PIX,A0		; being safe (?)
        NOP
	ASR	#5,A,A
	MOVE	#>16,Y0
	MOVE	A0,Y1
	MPY	Y0,Y1,A
	NOP
	MOVE	A0,Y0
	MOVE	X:<NUM_PIX,A		; LAST_BIT = NUM_PIX - INT(NUMPIX*32)
	SUB	Y0,A
	NOP
	MOVE	A1,X:<LAST_BIT		; # of pixels in the last little bit

; Prepare the HI32 DPMC and DPAR address registers
	MOVE	X:<PCI_ADDR_1,A1	; Current PCI address
	MOVE	X:<PCI_ADDR_0,A0
	ASL	#8,A,A
	NOP
	ORI	#$0F0000,A		; Burst length = # of PCI writes (!!!)
	NOP				;   = # of pixels / 2 - 1 
	MOVE	A1,X:DPMC		; DPMC = B[31:16] + $070000
	ASL	#16,A,A			; Get PCI_ADDR[15:0] into A1[15:0]
	NOP
	AND	#$00FFFF,A
	NOP
	OR	#$070000,A		; A1 will get written to DPAR register

; Write the image pixels from FIFO to PCI bus one 32 pixel block at a time
	MOVE	#IMAGE_BUFER,R0
	MOVE	R0,R1
	MOVEP	#DTXM,X:DDR0		; Destination = PCI master transmitter
	MOVEP	#>31,X:DCO0		; DMA Count = # of pixels - 1 (!!!)
	MOVEP	R0,X:DSR0		; Source address for DMA = pixel data

	DO	X:<NUM_BLOCKS,L_SMALL_BLOCKS
	CLR	B
        MOVE	X:<NUM_BLOCKS,B1
	NOP
	SUB  	#$1,B
	NOP
	MOVE	B1,X:<NUM_BLOCKS	; Decrement block count
	TST	B
	JGT	LGBLK
	MOVE	X:<LAST_BIT,B1		; this last block is small
	NOP
	TST	B
	JGT	SMFIFO			; unless LAST_BIT is 0
LGBLK
	MOVE	#32,B1
	NOP
SMFIFO					; copy pixels from fiber to Y: area

	DO	B1,S_BUFFER
	JCLR	#EF,X:PDRD,*		; Wait for the pixel datum to be there
	NOP					; Settling time
	MOVEP	Y:RDFIFO,Y:(R0)+
S_BUFFER

AGAIN1	BSET	#CLRT,X:DPCR		; Clear the master transmitter FIFO
	JSET	#CLRT,X:DPCR,*		; Wait for the clearing to be complete
	MOVEP	#$8EFA51,X:DCR0		; Start DMA with control register DE=1
	MOVEP	A1,X:DPAR		; Initiate writing to the PCI bus
	NOP
	NOP
	JCLR	#MARQ,X:DPSR,*		; Wait until the PCI operation is done
	JSET	#MDT,X:DPSR,WR_OK1	; If no error go to the next sub-block
	MOVE	X:<PCI_LSTERRS,B1
	ADD	#$1,B
	NOP
	MOVE	B1,X:<PCI_LSTERRS
	JSR	<PCI_ERROR_RECOVERY
WR_OK1	ADD	#>64,A			; PCI address = + 2 x # of pixels (!!!)
	MOVE	R0,R1
L_SMALL_BLOCKS
	JMP	<ALLDONE

; (c) Write the pixels left over from the last 32 pixel block
	MOVE	X:<LAST_BIT,B		; Skip over this if there are no
	TST	B			;   pixels left to write to the PCI bus
	JLE	<ALLDONE
	MOVE	X:DPMC,B		; Burst length = 0
	AND	#$FFFF,B 
	MOVE	B1,X:DPMC
	MOVE	X:<LAST_BIT,B
	LSR	B
	NOP
	DO	B1,L_BIT
	JCLR	#EF,X:PDRD,*
	MOVE	Y:(R6),X0
	MOVE	X0,X:DTXM
	JCLR	#EF,X:PDRD,*
	MOVE	Y:(R6),X0
	MOVE	X0,X:DTXM

AGAIN2	MOVEP	A1,X:DPAR		; Write to PCI bus
	NOP				; Pipeline delay
	NOP
	JCLR	#MARQ,X:DPSR,*		; Bit is clear if PCI is still active
	JSET	#MDT,X:DPSR,DONE2	; If no error then we're all done
;	JSR	<PCI_ERROR_RECOVERY
	JMP	<AGAIN2
DONE2	ADD	#>4,A			; Two bytes per PCI write
	NOP
L_BIT

; (d) If the number of pixels in the image is odd write the very last pixel
	JCLR	#0,X:<LAST_BIT,ALLDONE	; All done if even number of pixels
	JCLR	#EF,X:PDRD,*
	MOVE	Y:(R6),X0
	MOVE	X0,X:DTXM
	MOVE	#0,X0
	MOVE	X0,X:DTXM
AGAIN3	MOVEP	A1,X:DPAR		; Write to PCI bus
	NOP				; Pipeline delay
	NOP
	JCLR	#MARQ,X:DPSR,*		; Bit is clear if PCI is still active
	JSET	#MDT,X:DPSR,ALLDONE	; If no error then we're all done
;	JSR	<PCI_ERROR_RECOVERY
	JMP	<AGAIN3
	JMP	<ALLDONE


; Calculate and store the PCI address where image data is being written to
ALLDONE	
        MOVE    X:<PCI_ADDR_1,A1        ; Current PCI address
        MOVE    X:<PCI_ADDR_0,A0
        MOVE    X:<NUM_PIX,X0           ; Add the byte increment = NUM_PIX * 2
        MOVE    #0,X1
        ADD     X,A
        ADD     X,A
        NOP
        MOVE    A1,X:<PCI_ADDR_1        ; Incremented current PCI address
        MOVE    A0,X:<PCI_ADDR_0
	JSR	<C_RPXLS		; Calculate number of pixels read

; see how many extra pixels need to be tossed
        CLR	A
     	JCLR	#EF,X:PDRD,TOSS2	; Test for incoming FIFO data
TOSS1	ADD	#>1,A
	MOVEP	Y:RDFIFO,X0		; Read the FIFO until its empty
	NOP
	JSET	#EF,X:PDRD,TOSS1
TOSS2	DO	#2400,TOSS3		; Wait for about 30 microsec in case
	NOP				;   FIFO data is still arriving
TOSS3	JSET	#EF,X:PDRD,TOSS1	; Keep emptying if more data arrived
	MOVE	A1,X:<TOSS_PIXELS

	MOVE	X:<FLAG_DONE,X0
	MOVE	X0,X:<HOST_FLAG
	JSR	<FO_WRITE_HOST_FLAG	; Clear Host Flag to 'DONE'
	BSET	#HCIE,X:DCTR		; Enable host command interrupts
	JMP	<GET_FO			; We're all done, go process FO input

; R_PXLS is the number of pixels read out since the last IIA command
; in non-wrap mode. In wrap mode it represents the position of the FILL
; ptr in the low order 26 bits, and the number of times the fill ptr has
; wrapped, modulo 6 in the upper 6.
; 
; C_RPXLS looks for a non-zero PCI_BUFSIZE to signal wrap mode-
; and also where to wrap.
C_RPXLS	
	; safe copy of R_PXLS_
        MOVE    #RPXLS_SAFE,R7
	MOVE	X:<R_PXLS_0,B0
	CLR	A
	MOVE	B0,Y:(R7)+
	MOVE	X:<R_PXLS_1,B0
	MOVE	X:<PCI_BUFSIZE_1,Y1
	MOVE	B0,Y:(R7)+
	CLR	B
	BSET	#0,X:<R_PXLS_CRIT	; unsafe if R_PXLS_1,2 locs in xsition

	MOVE	X:<PCI_BUFSIZE_0,B0
	INSERT	#$10010,Y1,B
	MOVE	X:<BASE_ADDR_0,Y0	; BASE_ADDR is 2 x 16-bits
	MOVE	X:<BASE_ADDR_1,Y1
	MOVE	X:<PCI_ADDR_1,A1	; Current PCI address
	MOVE	X:<PCI_ADDR_0,A0
	SUB	Y,A			; Current (PCI - BASE) address
	ASR	A			; /2 => convert byte address to pixel
	CMP	#$0000,B
        JEQ	RPXLS_NOWRAP		; wrap is moot if bufsize 0.
	CMP	A,B
	JGT	RPXLS_NOWRAP		; wrap didn't happen
	SUB	B,A
	MOVE	Y0,X:<PCI_ADDR_0	; reset pci address to base at wrap.
; need to increment the fill wrap counter here.
	MOVE	X:<R_PXLS_1,B1
	ADD	#$400,B	 		; incr bit 26
	MOVE	Y1,X:<PCI_ADDR_1        ; reset pci address to base at wrap.
	MOVE	B1,X:<R_PXLS_1
RPXLS_NOWRAP
	MOVE	A0,X:<R_PXLS_0		; R_PXLS is 2 x 16 bits, number of
	MOVE	X:<R_PXLS_1,B0
	EXTRACTU #$00A010,A,A		;   hi order 10 bits of fill pixels.
	EXTRACTU #$00600A,B,B		;   preserve wrap counter for fill.
	ASL	#$A,B,B
	ADD	B,A
 	NOP
	MOVE	A0,X:<R_PXLS_1
	BCLR	#0,X:<R_PXLS_CRIT	; safe if these two locs not in xsition
        JCLR    #1,X:<R_PXLS_CRIT,NORACE
	MOVE	X:<R_PXLS_RACE,B1	; increment race counter
	ADD	#$1,B
	NOP
	MOVE	B1,X:<R_PXLS_RACE
	BCLR	#1,X:<R_PXLS_CRIT
NORACE
	
	RTS

; Recover from an error writing to the PCI bus. Trashes B register.
; All it does now is clear error bit in DPSR and log/record event.
; The PCI_BURST_NO must fit in 16 bits. (8 Mpix with 128 pixel burst)
PCI_ERROR_RECOVERY
	MOVE	X:<PCI_ERRS,B1
	ADD	#$1,B
	NOP
	MOVE	B1,X:<PCI_ERRS
	CLR	B
	MOVE	X:<PCI_ERRLOG,B
	CMP	#PCI_ERRMAGIC,B
	JNE	WR_ERR
	CLR	B
	MOVEP	X:DPSR,B0
	NOP
	EXTRACTU #$08005,B,B
	MOVE	B0,Y1
	MOVE    X:<PCI_BURST_NO,B1
	INSERT	#$08028,Y1,B
	MOVE	B1,Y:(R2)+	; log this one to error buf.
	CLR	B
	MOVE	R2,B1
	SUB	#PCI_ERRLOGLAST,B
	JLE	CLEAR_EBITS
        MOVE    #PCI_ERRLOGFIRST,R2	; error buffer ptr overflowed
CLEAR_EBITS
; Write the remaining pixels of the DMA block on a retry error
WR_ERR

; Save DPMC and DPAR for later use
	MOVEP	X:DPMC,X:SV_DPMC	; These registers are changed here,
	MOVE	A1,X:<SV_A1		;   so save and restore them

WR_ERR_AGAIN
	MOVEP	X:DPSR,A		; Get Remaining Data count bits[21:16]
	LSR	#16,A			; Put RDC field in A1
	JCLR	#RDCQ,X:DPSR,*+3
	ADD     #1,A			; Add one if RDCQ is set
	NOP
	MOVE	A1,Y1			; Save Y1 = # of PCI words remaining

; Compute number of bytes completed, using previous DPMC burst length
	MOVEP	X:DPMC,A
	ANDI	#$3F0000,A
	LSR	#16,A
	SUB	Y1,A			; A1 = # of PCI writes completed
	LSL	#2,A			; Convert to a byte address
	NOP
	MOVE	A1,Y0			; Byte address of # completed

	MOVEP	X:DPAR,A		; Save Y0 = DPAR + # of bytes completed
	ADD	Y0,A
	NOP
	MOVE	A1,Y0			; New DPAR value

; Write the new burst length to the X:DPMC register
	MOVEP	X:DPMC,A
	INSERT	#$006028,Y1,A		; Y1 = new burst length
	NOP
	MOVEP	A1,X:DPMC		; Update DPMC burst length

; Clear all error condition and initiate the PCI writing 
	MOVEP	X:DPSR,B
	OR	#$1FE,B
	NOP
	MOVEP	B,X:DPSR
	MOVEP	Y0,X:DPAR		; Initiate writing to the PCI bus
	NOP
	NOP
	JCLR	#MARQ,X:DPSR,*		; Test for PCI operation completion
	JSET	#MDT,X:DPSR,WR_ERR_OK	; Test for Master Data Transfer complete
	JMP	<WR_ERR_AGAIN
WR_ERR_OK
	MOVEP	X:SV_DPMC,X:DPMC	; Restore these two registers
	MOVE	X:<SV_A1,A1
	RTS

; ***** Test Data Link, Read Memory and Write Memory Commands ******

; Test the data link by echoing back ARG1
TEST_DATA_LINK
	MOVE	X:<ARG1,X0
	JMP	<FINISH1

; Read from PCI memory. The address is masked to 16 bits, so only 
;   the bottom 64k words of DRAM will be accessed.
READ_MEMORY
	MOVE    X:<ARG1,A	; Get the address in an accumulator
	AND	#$FFFF,A	; Mask off only 16 address bits
	MOVE	A1,R0		; Get the address in an address register
	MOVE    X:<ARG1,A	; Get the address in an accumulator
	NOP
	JCLR    #20,A,RDX 	; Test address bit for Program memory
	MOVE	P:(R0),X0	; Read from Program Memory
        JMP     <FINISH1	; Send out a header with the value
RDX     JCLR    #21,A,RDY 	; Test address bit for X: memory
        MOVE    X:(R0),X0	; Write to X data memory
        JMP     <FINISH1	; Send out a header with the value
RDY     JCLR    #22,A,RDR	; Test address bit for Y: memory
        MOVE    Y:(R0),X0	; Read from Y data memory
	JMP     <FINISH1	; Send out a header with the value
RDR	JCLR	#23,A,ERROR	; Test address bit for read from EEPROM memory

; Read the word from the PCI board EEPROM
        MOVEP   #$0202A0,X:BCR  ; Bus Control Register for slow EEPROM
        MOVE    X:<THREE,X1     ; Convert to word address to a byte address
        MOVE    R0,X0           ; Get 16-bit address in a data register
        MPY     X1,X0,A         ; Multiply
        ASR     A               ; Eliminate zero fill of fractional multiply
        MOVE    A0,R0           ; Need to address memory
        BSET    #15,R0          ; Set bit so its in EEPROM space
        DO      #3,L1RDR
        MOVE    P:(R0)+,A2      ; Read each ROM byte
        ASR     #8,A,A          ; Move right into A1
        NOP
L1RDR
        MOVE    A1,X0           ; Prepare for FINISH1
        MOVEP   #$020021,X:BCR  ; Restore fast FIFO access
        JMP     <FINISH1


; Program WRMEM - write to PCI memory, reply = DONE host flags. The address is
;  masked to 16 bits, so only the bottom 64k words of DRAM will be accessed.
WRITE_MEMORY
	MOVE    X:<ARG1,A	; Get the address in an accumulator
	AND	#$FFFF,A	; Mask off only 16 address bits
	MOVE	A1,R0		; Get the address in an address register
	MOVE    X:<ARG1,A	; Get the address in an accumulator
	MOVE    X:<ARG2,X0	; Get the data to be written
        JCLR    #20,A,WRX	; Test address bit for Program memory
        MOVE	X0,P:(R0)	; Write to Program memory
        JMP     <FINISH
WRX     JCLR    #21,A,WRY	; Test address bit for X: memory
        MOVE    X0,X:(R0)	; Write to X: memory
        JMP     <FINISH
WRY     JCLR    #22,A,WRR	; Test address bit for Y: memory
        MOVE    X0,Y:(R0)	; Write to Y: memory
	JMP	<FINISH
WRR	JCLR	#23,A,ERROR	; Test address bit for write to EEPROM

; Write the word to the on-board PCI EEPROM
        MOVEP   #$0202A0,X:BCR  ; Bus Control Register for slow EEPROM
        MOVE    X:<THREE,X1     ; Convert to word address to a byte address
        MOVE    R0,X0           ; Get 16-bit address in a data register
        MPY     X1,X0,A         ; Multiply
        ASR     A               ; Eliminate zero fill of fractional multiply
        MOVE    A0,R0           ; Need to address memory
        BSET    #15,R0          ; Set bit so its in EEPROM space
        MOVE    X:<ARG2,A       ; Get the data to be written, again
        DO      #3,L1WRR        ; Loop over three bytes of the word
        MOVE    A1,P:(R0)+      ; Write each EEPROM byte
        ASR     #8,A,A          ; Move right one byte
        MOVE    #1000000,X0
        DO      X0,L2WRR        ; Delay by 10 millisec for EEPROM write
        NOP
L2WRR
        NOP                     ; DO loop nesting restriction
L1WRR
        MOVEP   #$020021,X:BCR  ; Restore fast FIFO access
        JMP     <FINISH




	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
; save timer values in Y memory communications area
GET_TICK
        MOVE    #PCI_YCOMM,R7
        NOP
        NOP
        MOVEP   X:TCR1,Y:(R7)+
        NOP
        MOVEP   X:TCR0,Y:(R7)
        JMP     <FINISH
	ENDIF

; return information fields from a pseudo address space.
GET_INFO
	MOVE    X:<ARG1,A	; Get the address in an accumulator
	MOVE	#IVERSION,X0
        CMP     #GET_VERSION,A
        JEQ     <FINISH1               ; Is it Version?
	MOVE	#IFLAVOR,X0
        CMP     #GET_FLAVOR,A
        JEQ     <FINISH1               ; Is it Flavor?
	MOVE	#ITIME0,X0
        CMP     #GET_TIME0,A
        JEQ     <FINISH1               ; Is it Time0?
	MOVE	#ITIME1,X0
        CMP     #GET_TIME1,A
        JEQ     <FINISH1               ; Is it Time1?
	MOVE	#ISVNREV,X0
        CMP     #GET_SVNREV,A
        JEQ     <FINISH1               ; Is it Svn rev?
	MOVE	#>PCICAPABLE,X0
        CMP     #GET_CAPABLE,A
        JEQ     <FINISH1               ; Is it Pci Capabilities?
	JMP	<ERROR


;  ***** Subroutines for generating replies to command execution ******
; Return from the interrupt with a reply = DONE host flags
FINISH	MOVE	X:<FLAG_DONE,X0		; Flag = 1 => Normal execution
	MOVE	X0,X:<HOST_FLAG	
	JMP	<RTI_WRITE_HOST_FLAG

; Return from the interrupt with value in (X1,X0)
FINISH1	MOVE	X0,X:<REPLY		; Report value
	MOVE	X:<FLAG_REPLY,X0	; Flag = 2 => Reply with a value
	MOVE	X0,X:<HOST_FLAG	
	JMP	<RTI_WRITE_HOST_FLAG

; Routine for returning from the interrupt on an error
ERROR	MOVE	X:<FLAG_ERR,X0		; Flag = 3 => Error value
	MOVE	X0,X:<HOST_FLAG	
	JMP	<RTI_WRITE_HOST_FLAG

; Routine for returning from the interrupt with a system reset
SYR	MOVE	X:<FLAG_SYR,X0		; Flag = 4 => System reset
	MOVE	X0,X:<HOST_FLAG	
	JMP	<RTI_WRITE_HOST_FLAG

; Routine for returning a BUSY status from the controller
BUSY	MOVE	X:<FLAG_BUSY,X0	; Flag = 6 => Controller is busy
	MOVE	X0,X:<HOST_FLAG	
	JMP	<RTI_WRITE_HOST_FLAG

; Write X:<HOST_FLAG to the DCTR flag bits 5,4,3, as an interrupt
RTI_WRITE_HOST_FLAG
	MOVE	X:DCTR,A
	MOVE	X:<HOST_FLAG,X0	
	AND	#$FFFFC7,A		; Clear bits 5,4,3
	NOP
	OR	X0,A			; Set flags appropriately
	NOP
	MOVE	A,X:DCTR
	RTI

; Put the reply value into the transmitter FIFO
READ_REPLY_VALUE

	IF	@SCP("HISTLOG","SUPPORTED")	
	MOVE	X:<PCI_HISTON,A
	TST	A
	JEQ    DO_REP
        MOVE   X:<PCI_HISTFILL,R3	        ; history buffer
	NOP
	MOVE	#H_RDREPLYVAL,R4		; tag
	MOVE	R4,Y:(R3)+
	NOP
	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        MOVEP   X:TCR0,Y:(R3)+			; lo order time
        MOVEP   X:TCR1,Y:(R3)+			; hi order time
	ENDIF
	MOVE   R3,X:<PCI_HISTFILL
DO_REP
	ENDIF

;       the fiber loop wraps PCI_HIST when it gets the chance.
	MOVEP	X:REPLY,X:DTXS		; DSP-to-host slave transmit
	RTI

READ_REPLY_HEADER
	MOVE	X:<HEADER,X0
	JMP	<FINISH1

; Clear the reply flags and receiver FIFO after a successful reply transaction,
;   but leave the Read Image flags set if the controller is reading out.
CLEAR_HOST_FLAG

	IF	@SCP("HISTLOG","SUPPORTED")	
	MOVE	X:<PCI_HISTON,A
	TST	A
	JEQ    DO_CLH
        MOVE   X:<PCI_HISTFILL,R3	        ; history buffer
	NOP
	MOVE	#H_CLEARHOSTFLG,R4		; tag
	MOVE	R4,Y:(R3)+
	NOP
	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
        MOVEP   X:TCR0,Y:(R3)+			; lo order time
        MOVEP   X:TCR1,Y:(R3)+			; hi order time
	ENDIF
	MOVE   R3,X:<PCI_HISTFILL
DO_CLH
	ENDIF

;       the fiber loop wraps PCI_HIST when it gets the chance.

	MOVE	X:<FLAG_ZERO,X0
	MOVE	X0,X:<HOST_FLAG
	MOVE	#$FFFFC7,X0
	MOVE	X:DCTR,A
	AND	X0,A
	NOP
	MOVE	A1,X:DCTR

;       the receiver clear below engendered a race condition with the
;       host submitting the next cmd. We clear the receiver now -after-
;       receipt of each command via WRITE-COMMAND.

;CLR_RCV	JCLR	#SRRQ,X:DSR,CLR_RTS	; Wait for the receiver to be empty

;	MOVEP	X:DRXR,X0		; Read receiver to empty it

;	IF	@SCP("HISTLOG","SUPPORTED")	
;	MOVE	X:<PCI_HISTON,A
;	TST	A
;	JEQ    DO_CLRR
;        MOVE   X:<PCI_HISTFILL,R3	        ; history buffer
;	NOP
;	MOVE	X0,R4				; tag
;	NOP
;	MOVE	R4,Y:(R3)+
;	NOP
;	IF	@SCP("TIMER","SUPPORTED")	; Hardware timer
;        MOVEP   X:TCR0,Y:(R3)+			; lo order time
;        MOVEP   X:TCR1,Y:(R3)+			; hi order time
;	ENDIF
;	MOVE   R3,X:<PCI_HISTFILL
;DO_CLRR
;	ENDIF

;       the fiber loop wraps PCI_HIST when it gets the chance.

;	NOP				; Wait for flag to change
;	JMP	<CLR_RCV
;CLR_RTS
	RTI

; *************  Miscellaneous subroutines used everywhere  *************

; 250 MHz code - Transmit contents of Accumulator A1 to the timing board.
XMT_WRD MOVE    A0,X:SV_A0              ; Save registers used in XMT_WRD
        MOVE    A1,X:SV_A1
        MOVE    A2,X:SV_A2
        MOVE    X1,X:SV_X1
        MOVE    X0,X:SV_X0
        MOVE    Y1,X:SV_Y1
        MOVE    Y0,X:SV_Y0
        MOVE    #$1000AC,Y1
        ASL     #8,A,A
        MOVE    #$FFF000,R0             ; Memory mapped address of transmitter
        MOVE    A2,Y0
        ASL     #8,A,A
        NOP
        MOVE    A2,X1
        ASL     #8,A,A
        NOP
        MOVE    A2,X0
        MOVE    Y1,X:(R0)               ; Header = $AC
        MOVE    Y0,X:(R0)               ; MS Byte
        MOVE    X1,X:(R0)               ; Middle byte
        MOVE    X0,X:(R0)               ; LS byte
        MOVE    A0,X:SV_A0
        MOVE    A1,X:SV_A1
        MOVE    A2,X:SV_A2
        MOVE    X:SV_X1,X1              ; Restore registers used here
        MOVE    X:SV_X0,X0
        MOVE    X:SV_Y1,Y1
        MOVE    X:SV_Y0,Y0
        RTS


; Read one word of the fiber optic FIFO into B1 with a timeout
RD_FO_TIMEOUT
	MOVE	#1000000,Y0		; 13 millisecond timeout
	DO	Y0,LP_TIM
	JCLR	#EF,X:PDRD,NOT_YET	; Test for new fiber optic data
	NOP
	NOP
	JCLR	#EF,X:PDRD,NOT_YET	; For metastability, check it twice
	ENDDO
	JMP	<RD_FIFO		; Go read the FIFO word
NOT_YET	NOP
LP_TIM	NOP
	BSET	#0,SR			; Timeout reached, error return
	NOP
	RTS

; Read one word from the fiber optics FIFO, check it and put it in B1
RD_FIFO MOVEP   Y:RDFIFO,Y0             ; Read the FIFO word
        MOVE    X:<C00FF00,B            ; DMASK = $00FF00
        AND     Y0,B
        CMP     #$00AC00,B
        JEQ     <GT_RPLY                ; If byte equalS $AC then continue
        MOVEP   #%011000,X:PDRD         ; Clear RS* low for 2 milliseconds
        MOVE    #200000,Y1
        DO      Y1,*+3
        NOP
        MOVEP   #%011100,X:PDRD         ; Data Register - Set RS* high
        BSET    #0,SR                   ; Set carry bit => error
        NOP
        RTS

GT_RPLY	MOVE	Y0,B
	LSL	#16,B			; Shift byte in D7-D0 to D23-D16
	NOP
	MOVE	B1,Y1
	MOVE	Y:RDFIFO,Y0		; Read the FIFO word
	MOVE	#$00FFFF,B
	AND	Y0,B			; Select out D15-D0
	OR	Y1,B			; Add D23-D16 to D15-D0
	NOP
	NOP
	BCLR	#0,SR			; Clear carry bit => no error
	NOP
	RTS


; This might work with some effort
;GT_RPLY	MOVE	Y:RDFIFO,B		; Read the FIFO word
;	EXTRACTU #$010018,B,B
;	INSERT	#$008000,Y0,B		; Add MSB to D23-D16	
;	NOP
;	MOVE	B0,B1
;	NOP
;	NOP
;	BCLR	#0,SR			; Clear carry bit => no error
;	NOP
;	RTS

; ************************  Test on board DRAM  ***********************
; Test Y: memory mapped to AA0 and AA2 from $000000 to $FFFFFF (16 megapixels)
; DRAM definitions 

TEST_DRAM

; Test Y: memory mapped to AA0 and AA2 from $000000 to $FFFFFF (16 megapixels)
	CLR	A
	NOP
	MOVE	A,R0
	MOVE	#$FF0000,Y0		; Y:$000000 to Y:$FEFFFF
	DO	Y0,L_WRITE_RAM0	
	MOVE	A1,Y:(R0)+
	ADD	#1,A
	NOP
L_WRITE_RAM0

	CLR	A
	NOP
	MOVE	A,R0
	MOVE	#$FF0000,Y0
	DO	Y0,L_CHECK_RAM0
	MOVE	Y:(R0)+,X0
	CMPU	X0,A
	JEQ	<L_RAM4
	ENDDO
	JMP	<ERROR_Y
L_RAM4	ADD	#1,A
	NOP
L_CHECK_RAM0

; Test X: memory mapped to AA3 from $1000 to $7FFFFF (8 megapixels)
	CLR	A
	MOVE	#$1000,R0			; Skip over internal X: memory
	MOVE	#$7FF000,Y0			; X:$001000 to X:$7FFFFF
	DO	Y0,L_WRITE_RAM3	
	MOVE	A,X:(R0)+
	ADD	#1,A
	NOP
L_WRITE_RAM3

	CLR	A
	MOVE	#$1000,R0
	MOVE	#$7FF000,Y0
	DO	Y0,L_CHECK_RAM3	
	MOVE	X:(R0)+,X0
	CMPU	X0,A
	JEQ	<L_RAM5
	ENDDO
	JMP	<ERROR_X
L_RAM5	ADD	#1,A
	NOP
L_CHECK_RAM3
	JMP 	<FINISH

ERROR_Y	MOVE	#'__Y',X0
	MOVE	X0,X:<TRM_MEM
	MOVE	R0,X:<TRM_ADR	
	JMP	<ERROR
ERROR_X	MOVE	#'__X',X0
	MOVE	X0,X:<TRM_MEM
	MOVE	R0,X:<TRM_ADR	
	JMP	<ERROR

;  ****************  Setup memory tables in X: space ********************

; Define the address in P: space where the table of constants begins

        ORG     X:VAR_TBL,P:

; Parameters
STATUS		DC	0		; Execution status bits
		DC	0		; Reserved

	IF	@SCP("DOWNLOAD","HOST")	; Download via host computer
CONSTANTS_TBL_START	EQU	@LCV(L)
	ENDIF

	IF	@SCP("DOWNLOAD","ROM")	; Boot ROM code
CONSTANTS_TBL_START	EQU	@LCV(L)-2
	ENDIF

	IF	@SCP("DOWNLOAD","ONCE")	; Download via ONCE debugger
CONSTANTS_TBL_START	EQU	@LCV(L)
	ENDIF

; Parameter table in P: space to be copied into X: space during 
;   initialization, and must be copied from ROM in the boot process
ONE		DC	1		; One
THREE		DC	3		; Three
FOUR		DC	4		; Four

; Host flags are bits 5,4,3 of the HSTR
FLAG_ZERO	DC	0		; Flag = 0 => command executing
FLAG_DONE	DC	$000008		; Flag = 1 => DONE
FLAG_REPLY	DC	$000010		; Flag = 2 => reply value available
FLAG_ERR	DC	$000018		; Flag = 3 => error
FLAG_SYR	DC	$000020		; Flag = 4 => controller reset
FLAG_RDI	DC	$000028		; Flag = 5 => reading out image
FLAG_BUSY	DC	$000030		; Flag = 6 => controller is busy
C512		DC	512		; 1/2 the FIFO size
C00FF00		DC	$00FF00
C000202		DC	$000202		; Timing board header
TRM_MEM		DC	0		; Test DRAM, memory type of failure
TRM_ADR		DC	0		; Test DRAM, address of failure

; Tack the length of the variable table onto the length of code to be booted
CONSTANTS_TBL_LENGTH EQU	@CVS(P,*-ONE) ; Length of variable table

; Ending address of program so its length can be calculated for bootstrapping
; The constants defined after this are NOT initialized, so need not be 
;    downloaded. 

END_ADR	EQU	@LCV(L)		; End address of P: code written to ROM

; Miscellaneous variables
BASE_ADDR_1	DC	0	; Starting PCI address of image, MS byte
BASE_ADDR_0	DC	0	; Starting PCI address of image, LS 24-bits
DSP_VERS	DC	VERSION	; code version
NPXLS_1		DC 	0	; # of pxls in current READ_IMAGE call, MS byte
NPXLS_0		DC 	0	; # of pxls in current READ_IMAGE, LS 24-bits
IPXLS_1		DC 	0	; Down pixel counter in READ_IMAGE, MS byte
IPXLS_0		DC 	0	; Down pixel counter in READ_IMAGE, 24-bits
R_PXLS_1	DC 	0	; Up Counter of # of pixels read, MS 16-bits
R_PXLS_0	DC 	0	; Up Counter of # of pixels read, LS 16-bits
PCI_ADDR_1	DC	0	; Current PCI address of image, MS byte
PCI_ADDR_0	DC	0	; Current PCI address of image, LS 24-bits
REPLY	 	DC	0	; Reply value
HOST_FLAG	DC	0	; Value of host flags written to X:DCTR
FO_DEST		DC	0	; Whether host or PCI board receives command
FO_CMD		DC	0	; Fiber optic command or reply
NUM_PIX         DC      0       ; Number of pixels in the last block
NUM_BLOCKS      DC      0       ; Number of small blocks at the end
LAST_BIT        DC      0       ; # of pixels in the last little bit
SV_DPMC         DC      0       ; Save register
SV_A0           DC      0       ; Place for saving accumulator A
SV_A1           DC      0       ; Accumulator A in interrupt service routine
SV_A2           DC      0       ; Accumulator A in interrupt service routine
PCI_ERRS	DC	0	; Detected error count for pci xfer, DMA only.
PCI_BURST_NO	DC	0	; count of pci bursts for an image.
PCI_ERRLOG	DC      0       ; set to PCI_ERRMAGIC to get error logging in Y:
SV_X0		DC	0
SV_X1		DC	0
SV_Y0		DC	0
SV_Y1		DC	0



; Check that the parameter table is not too big
        IF	@CVS(N,*)>=ARG_TBL
        WARN    'The parameter table is too big!'
	ENDIF

	ORG	X:ARG_TBL,P:

; Table that contains the header, command and its arguments
HEADER		DC	0	; (Source, Destination, Number of words)
COMMAND		DC	0	; Manual command	
ARG1		DC	0	; First command argument
ARG2		DC	0	; Second command argument
DESTINATION	DC	0	; Derived from header
NUM_ARG		DC	0	; Derived from header

;        ORG     X:VAR2_TBL,P:

; If PCI_BUFSIZE_1 is set non-zero (by host) PCI_BUFSIZE* is understood to
; be the size of the mapped dma buffer in the host, and if the dma transfer 
; for an image exceeds this size, the transfer will wrap back to the start
; of the buffer at BASE_ADDR*. The size MUST be a multiple of 512 pixels.
; PCI_BUFSIZE* is in units of pixels.
;
; The value returned by the 
; READ_NUMBER_OF_PIXELS_READ command is modified as follows: Bits 25-0 are
; the difference between BASE_ADDR* and the next location into which data
; will transfer, serving as a "FILL" ptr for the transfer. Bits 31-26 are
; the low order 6 bits of the number of times the FILL has wrapped. Note that
; if the FILL ptr does not wrap (for example, if the BUFSIZE exceeds the image
; size) the READ_NUMBER_OF_PIXELS_READ will return the same values in either 
; mode. Ordinarily, the wrapping mode is used for continuous or effectively 
; continuous transfers in strip scan or occultation modes, and an extremely 
; large count of rows is given to the controller. The transfer ends when this 
; effective image size is exhausted or the image is aborted. The maximum image
; size that can be handled in this way is 2**48 pixels.

PCI_BUFSIZE_0	DC	0 
PCI_BUFSIZE_1	DC	0
PCI_LSTERRS	DC	0  ; pci errors in the "last little bit"- these are 
		   	   ; also recorded in PCI_ERRS.

TOSS_PIXELS     DC      0   ; count of pixels thrown away in end of readout,
ABT_PIXELS     DC       0   ; count of pixels thrown away in ABORT_READOUT

	IF	@SCP("HISTLOG","SUPPORTED")	
PCI_HISTFILL    DC      0   ; Current history fill ptr.
PCI_HISTON	DC	0   ; If zero all history log suppressed save NMI.
	ENDIF

	IF	@SCP("RDAFIX","SUPPORTED")	
WAIT_RDA        DC      0   ; time units to wait to enter rdi after RDA
	ENDIF

R_PXLS_CRIT	DC	0   ; if non-zero R_PXL's are in a transitory state..
R_PXLS_RACE	DC	0   ; if non-zero R_PXL's are in a transitory state..

	ORG	Y:0,P:

; This must be the LAST constant definition, because it is a large table
IMAGE_BUFER	DC	0	; Copy image data from FIFO to here


; End of program
	END

