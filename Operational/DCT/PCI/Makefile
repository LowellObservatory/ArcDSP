CC=g56k
TOOLPATH=/ibis/home/plc/leach/sw/leach_belay/Cameras/leach/clas563/bin
# Assembly Compile
AS=$(TOOLPATH)/asm56300
SREC=$(TOOLPATH)/srec 
CLD=$(TOOLPATH)/cldlod
DOWNHOSTDEF = -d DOWNLOAD HOST
ROMDEF = -d DOWNLOAD ROM
ONCEDEF = -d DOWNLOAD ONCE
TIMEDEF  = -d TIMER SUPPORTED
HISTDEF  = -d HISTLOG SUPPORTED
RDAFIX   = -d RDAFIX SUPPORTED
#TIMEDEF  = -d TIMER UNSUPPORTED

ASFLAGS=-b
# Linking
LD=$(TOOLPATH)/dsplnk
LDFLAGS=-v
DSPVERSION = V1.7/7/5

OPTIONS= $(TIMEDEF) $(HISTDEF) $(RDAFIX)



PCIBOOT_SRC=pciboot.s

VERSIONSRC= pciboot.s Makefile infospec.s pciinfospec.s version.s   

ALL:	HOST

HOST:	pci.lod pci_dsp.h

pci.lod: pciboot.cln Makefile 
	$(LD) -bpci.cld -v pciboot.cln
	rm -f pci.lod
	$(CLD) pci.cld > pci.lod

# you can edit this manally if you like. It's for backward compatiblity.
#version.s:	Makefile
#	 echo $(DSPVERSION) | ./version2code  > version.s

# need final blank in the sources argument
pciinfo.s:	$(VERSIONSRC)
	./info2code $(DSPVERSION) none "$(VERSIONSRC) " > pciinfo.s

# there are no dependencies- this target always does everything; it also
# eats its dead up to the level of clean.
Rom:
	./info2code $DSPVERSION none $(VERSIONSRCS) > pciinfo.s
	$(AS)  -b -lpciboot.rom.lst  $(ROMDEF) $(OPTIONS) $(PCIBOOT_SRC)
	rm -f pciinfo.s
	$(LD) -bpci.cld -v pciboot.cln
	rm -f pciboot.cln
	rm -f pci.rom
	$(CLD) pci.cld > pci.rom
	rm -f pci.cld
	./dsp2chdr pci.rom <pci_dspC.ifc > pci_dsp.h
	$(SREC) -bs pci.rom
 

pci_dsp.h: pci.lod pci_dspC.ifc Makefile
	./dsp2chdr pci.lod <pci_dspC.ifc > pci_dsp.h

pciboot.cln: $(PCIBOOT_SRC) pciinfo.s Makefile infospec.s pciinfospec.s version.s
	$(COMPILE.s) $(DOWNHOSTDEF) $(OPTIONS) -l $(PCIBOOT_SRC)

clean:
	$(RM) *.cln *.lst *.cld *~ *% pciinfo.s

stripclean:	clean
	$(RM) *.lod *.rom pci.s pci_dsp.h
