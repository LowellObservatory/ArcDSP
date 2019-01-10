CC=g56k
# Assembly Compile
AS=asm56300
INFO2CODE=./info2code
DSP2CHDR=./dsp2chdr
MASTERDEF = -d MASTER "TIMING"
DOWNDEF = -d DOWNLOAD HOST
ASDEF=-d DOWNLOAD  HOST
WAVEDEF = -d INTTIM_SETTING "E" -d SIDELAY_SETTING "A7" -d RDELAY_SETTING "00"
CHIPDEF = -d ROWS_SETTING "6160" -d COLS_SETTING "6144"
DWEEBDEF=       -d SDWB_DELAY "10"
SHUTDEF=	-d SHDEL_SETTING "1500"

ASFLAGS=-b
# Linking
LD=$(TOOLPATH)dsplnk
LDFLAGS=-v

TIMDSPVERSION = V1.5/1

# FLAVOR is a nonblank 1-3 char string or else "none" which means none
TIMDSPFLAVOR  = a


# FLAVOR is a nonblank 1-3 char string or else "none" which means none
#UTILDSPFLAVOR = none

# these are the files scanned for the svn rev number.
TIMVERSIONSRCS=timboot.s tim.s timCCDmisc.s lmi.waveforms.s  timmisc.s timhdr.s Makefile timinfospec.s infospec.s

CLD=$(TOOLPATH)cldlod



TIMSRC=timboot.s tim.s
TIM_CLNS= tim.cln 


ALL:	tim.lod tim_dsp.h 

tim.lod:	$(TIM_CLNS)
	$(LD) -btim.cld -v $(TIM_CLNS)
	rm -f tim.lod
	$(CLD) tim.cld > tim.lod

timboot.cln:	timboot.s timhdr.s  Makefile
	$(COMPILE.s) $(MASTERDEF) $(DOWNDEF) -l timboot.s

tim.cln:        tim.s timCCDmisc.s  timmisc.s  lmi.waveforms.s timhdr.s timinfo.s timinfospec.s infospec.s Makefile
	$(COMPILE.s) $(MASTERDEF) $(DOWNDEF) $(WAVEDEF) $(DWEEBDEF) $(CHIPDEF) $(SHUTDEF)  -l tim.s

# need final blank in the sources argument
timinfo.s:	Makefile timboot.s  timhdr.s tim.s timCCDmisc.s  lmi.waveforms.s  timmisc.s  timinfospec.s infospec.s 
	$(INFO2CODE) $(TIMDSPVERSION) $(TIMDSPFLAVOR) "$(TIMVERSIONSRCS) " > timinfo.s

                 
tim_dsp.h:	tim.lod tim_dspC.ifc Makefile
		$(DSP2CHDR) tim.lod <tim_dspC.ifc > tim_dsp.h


clean:
	$(RM) *.cln *.lst *.cld *~ *%

stripclean:	clean
	$(RM) *.lod
