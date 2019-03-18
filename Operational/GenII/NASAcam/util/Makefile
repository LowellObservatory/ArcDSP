CC=g56k
# Assembly Compile
AS=asm56000
MASTERDEF = -d MASTER "TIMING"
DOWNDEF = -d DOWNLOAD HOST
ASDEF=-d DOWNLOAD HOST
ASFLAGS=-b
# Linking
LD=dsplnk
LDFLAGS=-v

CLD=cldlod



TIMSRC=timboot.s tim.s
TIM_OBJS=timboot.o tim.o 
TIM_CLNS=timboot.cln tim.cln 
UTIL_OBJS=utilboot.o utilappl.o 
UTIL_CLNS=utilboot.cln utilappl.cln


.s.o:
	$(COMPILE.s) $(MASTERDEF) $(DOWNDEF) -l $<

ALL:	TIM UTIL



TIM:	$(TIM_OBJS)
	$(LD) -btim.cld -v $(TIM_CLNS)
	rm -f tim.lod
	$(CLD) tim.cld > tim.lod

UTIL:	$(UTIL_OBJS)
	$(LD) -butil.cld $(UTIL_CLNS)
	rm -f util.lod
	$(CLD) util.cld > util.lod


install:
	mv *.lod ..
clean:
	$(RM) *.cln *.lst *.cld *~ *%

stripclean:	clean
	$(RM) *.lod
