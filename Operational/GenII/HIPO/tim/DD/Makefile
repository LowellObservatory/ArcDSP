CC=g56k
# Assembly Compile
AS=asm56000
#VERSION2CODE=./version2code
INFO2CODE=./info2code
DSP2CHDR=./dsp2chdr
MASTERDEF = -d MASTER "TIMING"
DOWNDEF = -d DOWNLOAD HOST
ASDEF=-d DOWNLOAD  HOST
WAVEDEF = -d INTTIM_SETTING "1D" -d SIDELAY_SETTING "82" -d RDELAY_SETTING "00"
DWEEBDEF=	-d SDWB_DELAY "50"
ASFLAGS=-b
# Linking
LD=dsplnk
LDFLAGS=-v

# V1.5 adds better abort support
TIMDSPVERSION = V1.5/1

# FLAVOR is a nonblank 1-3 char string or else "none" which means none
TIMDSPFLAVOR  = a


# these are the files scanned for the svn rev number.
TIMVERSIONSRCS=timboot.s tim.s timCCDmisc.s timmisc.s timhdr.s HIPO_DD.waveforms.s Makefile timinfospec.s infospec.s

CLD=cldlod



TIMSRC=timboot.s tim.s
TIM_CLNS=timboot.cln tim.cln 



ALL:	tim.lod tim_dsp.h 

tim.lod:	$(TIM_CLNS)
	$(LD) -btim.cld -v $(TIM_CLNS)
	rm -f tim.lod
	$(CLD) tim.cld > tim.lod

timboot.cln:	timboot.s timhdr.s timversion.s   Makefile
	$(COMPILE.s) $(MASTERDEF) $(DOWNDEF) -l timboot.s

tim.cln:	tim.s timCCDmisc.s  timmisc.s HIPO_DD.waveforms.s timhdr.s timinfo.s timinfospec.s infospec.s Makefile
	$(COMPILE.s) $(MASTERDEF) $(DOWNDEF) $(WAVEDEF) $(DWEEBDEF) -l tim.s

# need final blank in the sources argument
timinfo.s:	Makefile timboot.s  timhdr.s tim.s timCCDmisc.s  timmisc.s HIPO_DD.waveforms.s timhdr.s  timinfospec.s infospec.s 
	$(INFO2CODE) $(TIMDSPVERSION) $(TIMDSPFLAVOR) "$(TIMVERSIONSRCS) " > timinfo.s


tim_dsp.h:	tim.lod tim_dspC.ifc Makefile
		$(DSP2CHDR) tim.lod <tim_dspC.ifc > tim_dsp.h


clean:
	$(RM) *.cln *.lst *.cld *~ timinfo.s utilinfo.s *%

stripclean:	clean
	$(RM) *.lod
