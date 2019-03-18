CC=g56k
# Assembly Compile
AS=asm56000
#VERSION2CODE=./version2code
INFO2CODE=./info2code
DSP2CHDR=./dsp2chdr
MASTERDEF = -d MASTER "TIMING"
DOWNDEF = -d DOWNLOAD HOST
ASDEF=-d DOWNLOAD  HOST
ASFLAGS=-b
# Linking
LD=dsplnk
LDFLAGS=-v

TIMDSPVERSION = V1.4/1

# FLAVOR is a nonblank 1-3 char string or else "none" which means none
TIMDSPFLAVOR  = a

UTILDSPVERSION = V1.3/1

# FLAVOR is a nonblank 1-3 char string or else "none" which means none
UTILDSPFLAVOR = none

# these are the files scanned for the svn rev number.
TIMVERSIONSRCS=timboot.s tim.s timCCDmisc.s timmisc.s timhdr.s Makefile timinfospec.s infospec.s
UTILVERSIONSRCS=utilboot.s utilappl.s Makefile utilinfospec.s infospec.s 

CLD=cldlod

TIMSRC=timboot.s tim.s
TIM_CLNS=timboot.cln tim.cln 
UTIL_CLNS=utilboot.cln utilappl.cln

#.s.o:
#	$(COMPILE.s) $(MASTERDEF) $(DOWNDEF) -l $<

ALL:	tim.lod tim_dsp.h util.lod util_dsp.h

tim.lod:	$(TIM_CLNS)
	$(LD) -btim.cld -v $(TIM_CLNS)
	rm -f tim.lod
	$(CLD) tim.cld > tim.lod

timboot.cln:	timboot.s timhdr.s timversion.s   Makefile
	$(COMPILE.s) $(MASTERDEF) $(DOWNDEF) -l timboot.s

tim.cln:	tim.s timCCDmisc.s  timhdr.s timinfo.s timinfospec.s infospec.s Makefile
	$(COMPILE.s) $(MASTERDEF) $(DOWNDEF) -l tim.s

# need final blank in the sources argument
timinfo.s:	Makefile timboot.s  timhdr.s tim.s timCCDmisc.s  timhdr.s  timinfospec.s infospec.s 
	$(INFO2CODE) $(TIMDSPVERSION) $(TIMDSPFLAVOR) "$(TIMVERSIONSRCS) " > timinfo.s

# you can edit this manally if you like. It's for backward compatiblity.
#timversion.s:	Makefile
#	echo $(TIMDSPVERSION) F$(TIMDSPFLAVOR) > fon.s
#	echo $(TIMDSPVERSION) F$(TIMDSPFLAVOR)| $(VERSION2CODE) > timversion.s

tim_dsp.h:	tim.lod tim_dspC.ifc Makefile
		$(DSP2CHDR) tim.lod <tim_dspC.ifc > tim_dsp.h


util.lod:	$(UTIL_CLNS)
	$(LD) -butil.cld $(UTIL_CLNS)
	rm -f util.lod
	$(CLD) util.cld > util.lod

utilboot.cln:	utilboot.s Makefile
	$(COMPILE.s) $(MASTERDEF) $(DOWNDEF) -l utilboot.s

utilappl.cln:	utilappl.s  utilinfo.s utilinfospec.s infospec.s utilversion.s  Makefile
	$(COMPILE.s) $(MASTERDEF) $(DOWNDEF) -l utilappl.s


# you can edit this manally if you like. It's for backward compatiblity.
#utilversion.s:	Makefile
#	echo $(UTILDSPVERSION) Fno | $(VERSION2CODE) > utilversion.s

# need final blank in the sources argument
utilinfo.s:	Makefile utilboot.s  utilappl.s utilinfospec.s infospec.s
	$(INFO2CODE) $(UTILDSPVERSION) $(UTILDSPFLAVOR) "$(UTILVERSIONSRCS) " > utilinfo.s

util_dsp.h:	util.lod util_dspC.ifc Makefile
		$(DSP2CHDR) util.lod <util_dspC.ifc > util_dsp.h

clean:
	$(RM) *.cln *.lst *.cld *~ *%

stripclean:	clean
	$(RM) *.lod
