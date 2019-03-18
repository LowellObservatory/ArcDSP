CC=g56k
# Assembly Compile
AS=asm56000
INFO2CODE=./info2code
DSP2CHDR=./dsp2chdr
MASTERDEF = -d MASTER "TIMING"
DOWNDEF = -d DOWNLOAD HOST
ASDEF=-d DOWNLOAD  HOST
ASFLAGS=-b
# Linking
LD=dsplnk
LDFLAGS=-v


POWERCTLDEF= -d POWERCTL OFF

TEMPDEF = -d TEMPREG ON -d TEMPWSETPT ON -D TAVCYCLE 64 -DTEMPSTATS OFF

DACSDEF = -d WRDACS ON -d WRDACSALL OFF

EXPOSEDEF = -d EXPOSECTL OFF


UTILDSPVERSION = V1.4/1

# FLAVOR is a nonblank 1-3 char string or else "none" which means none
UTILDSPFLAVOR = none

# these are the files scanned for the svn rev number.
UTILVERSIONSRCS=utilboot.s utilappl.s Makefile utilinfospec.s infospec.s 

CLD=cldlod



UTIL_CLNS=utilboot.cln utilappl.cln



ALL:	 util.lod util_dsp.h


util.lod:	$(UTIL_CLNS)
	$(LD) -butil.cld $(UTIL_CLNS)
	rm -f util.lod
	$(CLD) util.cld > util.lod

utilboot.cln:	utilboot.s Makefile
	$(COMPILE.s) $(MASTERDEF) $(DOWNDEF) -l utilboot.s

utilappl.cln:	utilappl.s  utilinfo.s utilinfospec.s infospec.s utilversion.s  Makefile
	$(COMPILE.s) $(MASTERDEF) $(DOWNDEF) $(EXPOSEDEF) $(POWERCTLDEF) $(TEMPDEF) $(DACSDEF)  -l utilappl.s



# need final blank in the sources argument
utilinfo.s:	Makefile utilboot.s  utilappl.s utilinfospec.s infospec.s
	$(INFO2CODE) $(UTILDSPVERSION) $(UTILDSPFLAVOR) "$(UTILVERSIONSRCS) " > utilinfo.s

util_dsp.h:	util.lod util_dspC.ifc Makefile
		$(DSP2CHDR) util.lod <util_dspC.ifc > util_dsp.h

clean:
	$(RM) *.cln *.lst *.cld *~  utilinfo.s *%

stripclean:	clean
	$(RM) *.lod
