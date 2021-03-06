#  Makefile for building varioius different systems
#  Le-Lisp version 15.2 > August 1, 1987
#  Maintenance: This makefile has been created by C. Jullien (Eligis).

# $Date: 2017/09/23 13:25:29 $
# $Revision: 1.9 $
# $Author: jullien $

# First entry, to start everything
all: default

CC		= gcc -m32
SYSTEM		= cygwin
HOST		= $(SYSTEM)
LD		= $(CC)
LDR		= ld -m i386pe
LDRFLAGS	= -r -o
MV		= mv

################################
# Names of standard binaries
################################

FLT		= 31
BIN		= lelisp$(FLT)

lelispbin: $(BIN)bin.exe
	@rm -f lelispbin.exe
	cp $(BIN)bin.exe lelispbin.exe

leX11bin: $(BIN)X11bin.exe
	@rm -f leX11bin
	cp $(BIN)X11bin.exe leX11bin.exe

leM11bin:
	@echo "** Use the Aida Makefile to produce your binary **"

##########################################################################
# Options that depend upon the system
##########################################################################
#

# name of the system

CSYSTEM		= CYGWIN
LLNAMESYST	= -D$(CSYSTEM)

# type of UNIX

LLUNIX		= -D_POSIX_SOURCE

# unique stamp

#STAMP=-DSTAMP=\"$$$$\"

# to add various CFLAGS in Le-Lisp

LL_LLFLAGS	= # -DLLDEBUG

# Flags for C compilation of Le-Lisp

# for the C includes concerning Le-Lisp:

LLINCLUDE	= -I../common -I../cygwin/C
LL_CFLAGS	= $(LLUNIX) $(LLNAMESYST) $(LL_LLFLAGS)

################################################
# all LD flags for le-Lisp
#

# directories of linker's libraries (-Lxxx)

CLIB		=

# LOCALVARS = -x default, no local symbols.
#           = -X for debug.

LOCALVARS	=

# specifics LD flags

LDFLAGS		= $(LOCALVARS) $(CLIB)

# specifics libraries

LDLIBS		= # -lm -lc

##############################################
# all C flags on CYGWIN

# for debug

DEBUG		=

# special include for LL on CYGWIN

CINCLUDE	=

# optimisations for ICC on CYGWIN

C_OPTless	=
C_OPTstd	= -O
C_OPThigh	= -O

# choice of optimisation
# C_OPT=$(C_OPTless)
# C_OPT=$(C_OPThigh)
C_OPT		= $(C_OPTstd)

# compiler flags need on CYGWIN

C_CFLAGS	= -std=c90 -Wall -Wextra -Wstrict-prototypes

##############################################
# globals C compiler flags
CFLAGSLESS	= $(DEBUG) $(C_CFLAGS) $(CINCLUDE) $(LL_CFLAGS) $(LLINCLUDE)
CFLAGS		= $(CFLAGSLESS) $(C_OPT)

########################################
# specifics compilation flags for X11
# ( eventually add -DBP24BP for screen 24plans)

WINDOW		= # -DX11 -DBP24BP

# X11 path

XPATH		= /usr/X11R6

# directories for X11's libraries ( $(XLIB)/libX*.a )

XLIB		= -L$(XPATH)/lib 

# directories for X11's *.h ( $(XINCLUDE)/X/?*.h )

XINCLUDE	= -I$(XPATH)/include -I../virbitmap/X11

# compilation flags for X11

X11_CFLAGS	= $(WINDOW) $(XINCLUDE)
X11_LDFLAGS	=
X11_LDLIBS	= $(XLIB) -lX11

########################################
# specifics flags for MOTIF (cf USERMBIN)

# C compilation flags for Motif

MOTIF_VERSION	= 2.0
MOTIF_PATH	= /cygdrive/d/lesstif/dist/LessTif/Motif$(MOTIF_VERSION)
MOTIF_INCLUDE	= -I$(MOTIF_PATH)/include
MOTIF_LDFLAGS	=
MOTIF_LDLIBS	= -L$(MOTIF_PATH)/lib $(XLIB) -lXm

#########################################################################
##
## C files used to build the binaries
##
#########################################################################
# .h files that are common to nearly all
LLH		= ../common/lelisp.h ../$(SYSTEM)/C/Machine.h

# .c files that are common to all

LLMAIN		= o/llmain.o
common_cobj	= $(LLMAIN) o/llstdio.o o/llfloat.o o/llfloat$(FLT).o \
		  o/cfix.o o/lelisp.o o/getgloba.o o/alloc.o o/cload.o
extra_cobj	=
cobj		= $(extra_cobj) $(common_cobj)

# C files for the X11 bitmap
x11cobj		= o/x11.o o/evloop.o

# C files from LL virtual bitmap only used by MOTIF
motifcobj	= o/x11share.o o/x11draw.o o/evloop.o

#########################################################################
##
## building all possible binaries according
## to the options available on this machine
##
#########################################################################

lelisp31bin.obj= $(cobj) lelisp31bin.o
lelisp31bin.exe: $(lelisp31bin.obj) o/def_nlist.o
	@echo Final link for $@
	$(LD) -o lelisp31bin.exe \
		$(LDFLAGS) \
		$(lelisp31bin.obj) o/def_nlist.o \
		$(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) -o lelisp31bin.exe \
		$(LDFLAGS) \
		$(lelisp31bin.obj) nlist.o \
		$(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) -o lelisp31bin.exe \
		$(LDFLAGS) \
		$(lelisp31bin.obj) nlist.o \
		$(LDLIBS)
	echo End of link.

foobin.exe: $(lelisp31bin.obj) o/def_nlist.o
	@echo Final link for $@
	$(LD) -o foobin.exe \
		$(LDFLAGS) \
		$(lelisp31bin.obj) o/def_nlist.o \
		$(LDLIBS)
	@dlltool -v --export-all-symbols --output-def foobin.def foobin.exe
	@dlltool -v --output-exp foobin.exp --def foobin.def
	$(LD) -o foobin.exe \
		$(LDFLAGS) \
		$(lelisp31bin.obj) \
		$(LDLIBS)  o/def_nlist.o foobin.exp
	echo End of link.

lelisp64bin.obj=$(cobj) lelisp64bin.o
lelisp64bin.exe: $(lelisp64bin.obj) o/def_nlist.o
	@echo Final link for $@
	$(LD) -o lelisp64bin \
		$(LDFLAGS) \
		$(lelisp64bin.obj) o/def_nlist.o \
		$(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) -o lelisp64bin \
		$(LDFLAGS) \
		$(lelisp64bin.obj) nlist.o \
		$(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
		$(LD) -o lelisp64bin \
		$(LDFLAGS) \
		$(lelisp64bin.obj) nlist.o \
		$(LDLIBS)
	echo End of link.

lelisp31X11bin.obj=$(cobj) $(x11cobj) lelisp31bin.o
lelisp31X11bin.exe: $(lelisp31X11bin.obj) o/def_nlist.o
	@echo Final link for $@
	$(LD)  -o lelisp31X11bin.exe \
		$(LDFLAGS) $(X11_LDFLAGS) \
		$(lelisp31X11bin.obj) o/def_nlist.o \
		$(X11_LDLIBS) $(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) -o lelisp31X11bin.exe \
		$(LDFLAGS) $(X11_LDFLAGS) \
		$(lelisp31X11bin.obj) nlist.o \
		$(X11_LDLIBS) $(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) -o lelisp31X11bin.exe \
		$(LDFLAGS) $(X11_LDFLAGS) \
		$(lelisp31X11bin.obj) nlist.o \
		$(X11_LDLIBS) $(LDLIBS)
	echo End of link.

lelisp64X11bin.obj=$(cobj) $(x11cobj) lelisp64bin.o
lelisp64X11bin.exe: $(lelisp64X11bin.obj)
	@echo Final link for $@
	$(LD)  -o lelisp64X11bin.exe \
		$(LDFLAGS) $(X11_LDFLAGS) \
		$(lelisp64X11bin.obj) o/def_nlist.o \
		$(X11_LDLIBS) $(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) -o lelisp64X11bin.exe \
		$(LDFLAGS) $(X11_LDFLAGS) \
		$(lelisp64X11bin.obj) nlist.o \
		$(X11_LDLIBS) $(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) -o lelisp64X11bin.exe \
		$(LDFLAGS) $(X11_LDFLAGS) \
		$(lelisp64X11bin.obj) nlist.o \
		$(X11_LDLIBS) $(LDLIBS)
	echo End of link.

#lelisp31M11bin.obj=$(cobj) $(motifcobj) lelisp31bin.o
#lelisp31M11bin:
#	@echo "** Use the Aida Makefile to produce your binary **"
#

lelisp31M11bin.obj=$(cobj) $(x11cobj) lelisp31bin.o
lelisp31M11bin.exe: $(lelisp31M11bin.obj) o/def_nlist.o
	@echo Final link for $@
	$(LD)  -o lelisp31M11bin.exe \
		$(LDFLAGS) $(X11_LDFLAGS) \
		$(lelisp31M11bin.obj) o/def_nlist.o \
		$(MOTIF_LDLIBS) $(X11_LDLIBS) $(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) -o lelisp31M11bin.exe \
		$(LDFLAGS) $(X11_LDFLAGS) \
		$(lelisp31M11bin.obj) nlist.o \
		$(MOTIF_LDLIBS) $(X11_LDLIBS) $(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) -o lelisp31M11bin.exe \
		$(LDFLAGS) $(X11_LDFLAGS) \
		$(lelisp31M11bin.obj) nlist.o \
		$(MOTIF_LDLIBS) $(X11_LDLIBS) $(LDLIBS)
	echo End of link.

#lelisp64M11bin.obj=$(cobj) $(motifcobj) lelisp64bin.o
#lelisp64M11bin:
#	@echo "** Use the Aida Makefile to produce your binary **"

lelisp64M11bin.obj=$(cobj) $(x11cobj) lelisp64bin.o
lelisp64M11bin.exe: $(lelisp64M11bin.obj) o/def_nlist.o
	@echo Final link for $@
	$(LD)  -o lelisp64M11bin.exe \
		$(LDFLAGS) $(X11_LDFLAGS) \
		$(lelisp64M11bin.obj) o/def_nlist.o \
		$(MOTIF_LDLIBS) $(X11_LDLIBS) $(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) -o lelisp64M11bin.exe \
		$(LDFLAGS) $(X11_LDFLAGS) \
		$(lelisp64M11bin.obj) nlist.o \
		$(MOTIF_LDLIBS) $(X11_LDLIBS) $(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) -o lelisp64M11bin.exe \
		$(LDFLAGS) $(X11_LDFLAGS) \
		$(lelisp64M11bin.obj) nlist.o \
		$(MOTIF_LDLIBS) $(X11_LDLIBS) $(LDLIBS)
	echo End of link.


##########################################################
# Ordinary inputs
##########################################################

DEFAULTS	= lelispbin leX11bin cmplc++ lelisp cll2lm
ALLCORES	= lelisp cmplc lelispX11 cmplc++ lelisps ceyx cll2lm lelisp64
ALLBINS		= lelisp31bin.exe lelisp64bin.exe lelisp31X11bin.exe lelisp64X11bin.exe

# To build client systems : $(DEFAULTS)
# % make
default: $(DEFAULTS)
allcore: $(ALLCORES)
allbin:	$(ALLBINS)

# To clean up everything that's built by this makefile: the binaries,
# the standard commands.
# % make clean
clean: cleanbin cleancore cleano
cleanbin:
	rm -f $(ALLBINS)

cleancore:
	for i in $(ALLCORES) ; do \
		rm -f $$i ; \
		rm -f llcore/$$i.core ; \
		done

cleano:
	rm -f $(x11cobj) $(motifcobj) $(olcobj) $(cobj)

# to clean up EVERYTHING
clear:
	rm -f *bin
	rm -f llcore/?*.core
	rm -f o/?*.o

# To remove everything that is not absolutely necessary for minimal use
#  of Le-Lisp.  Warning: you won't be able to make any other binary, or
#  any other core image in Le-Lisp as soon as you launch this command!
#
# Obviously, no maintenance can be performed without
#  a COMPLETE distribution of Le-Lisp.
#
# % make minimal
minimal:
	@( echo "Are you sure you wish to retain only a minimum Le-Lisp? (y/n) ";\
	read rep ;\

	if [ $$rep = "o" ] ;\
	then \
		echo "OK, let's start..." ;\
		(cd .. ;\
		/bin/rm -f TAR* LL*FILES ;\
		/bin/rm -rf benchmarks ;\
		/bin/rm -rf ceyx ;\
		/bin/rm -rf common ;\
		/bin/rm -rf info ;\
		/bin/rm -rf lltest ;\
		) ;\
		/bin/rm -f *.o
		/bin/rm -rf conf ;\
		/bin/rm -rf recette ;\
		/bin/rm -rf o ;\
		/bin/rm -ri llcore ;\
		/bin/rm -f *FILES* ;\
		/bin/rm -f Make* ;\
		echo "Job completed." ;\
	fi )

#########################################################################
#                 .c files
#########################################################################
LINTFLAGS	= -nchxa
lint:
	$(MV) $(cobj) .
	$(MAKE) CC=/bin/lint \
		CFLAGS="$(LINTFLAGS) $(LL_CFLAGS)" \
		$(cobj)

o/llmain.o: ../common/llmain.c
	$(CC) $(CFLAGS) -c ../common/llmain.c
	$(MV) llmain.o o

o/lelisp.o: ../common/lelisp.c $(LLH)
	$(CC) $(CFLAGS) $(STAMP) -c ../common/lelisp.c
	$(MV) lelisp.o o/lelisp.o

o/llstdio.o: ../common/llstdio.c $(LLH)
	$(CC) $(CFLAGSLESS) -c ../common/llstdio.c
	$(MV) llstdio.o o

o/alloc.o: ../$(SYSTEM)/C/Alloc.c $(LLH)
	$(CC) $(CFLAGSLESS) -c ../$(SYSTEM)/C/Alloc.c
	$(MV) Alloc.o o/alloc.o

o/getgloba.o: ../$(SYSTEM)/C/Getgloba.c $(LLH)
	$(CC) $(CFLAGS) -c ../$(SYSTEM)/C/Getgloba.c
	$(MV) Getgloba.o o/getgloba.o

o/cload.o: ../$(SYSTEM)/C/Cload.c $(LLH)
	$(CC) $(CFLAGS) -c ../$(SYSTEM)/C/Cload.c
	$(MV) Cload.o o/cload.o

o/cfix.o: ../$(SYSTEM)/C/Cfix.c $(LLH)
	$(CC) $(CFLAGS) -c ../$(SYSTEM)/C/Cfix.c
	$(MV) Cfix.o o/cfix.o

o/nlist.o: ../$(SYSTEM)/C/nlist.c $(LLH)
	$(CC) $(CFLAGS) $(STAMP) -c ../$(SYSTEM)/C/nlist.c
	$(MV) nlist.o o/nlist.o

o/evloop.o: ../common/evloop.c $(LLH)
	$(CC) $(CFLAGS) -c ../common/evloop.c
	$(MV) evloop.o o

o/llfloat.o: ../common/llfloat.c
	$(CC) $(CFLAGS) -c ../common/llfloat.c
	$(MV) llfloat.o o

o/llfloat$(FLT).o: ../common/llfloat$(FLT).c
	$(CC) $(CFLAGS) -c ../common/llfloat$(FLT).c
	$(MV) llfloat$(FLT).o o

o/cstruct.o: ../common/cstruct.c
	$(CC) $(CFLAGS) -c ../common/cstruct.c
	$(MV) cstruct.o o

o/def_nlist.o: ../$(SYSTEM)/C/def_nlist.c
	$(CC) $(CFLAGS) -c ../$(SYSTEM)/C/def_nlist.c
	$(MV) def_nlist.o o/def_nlist.o

# For the X11 bitmap

XWINSRC		= ../virbitmap/X11

o/x11.o: o/x11lib.o o/x11share.o o/x11draw.o
	ld $(LDRFLAGS) x11.o \
		o/x11lib.o \
		o/x11share.o \
		o/x11draw.o 
	mv x11.o o

o/x11share.o: $(XWINSRC)/x11share.c $(XWINSRC)/x11.h
	$(CC) $(CFLAGS) $(XINCLUDE) -c $(XWINSRC)/x11share.c
	mv x11share.o o

o/x11draw.o: $(XWINSRC)/x11draw.c $(XWINSRC)/x11.h
	$(CC) $(CFLAGS) $(XINCLUDE) -c $(XWINSRC)/x11draw.c
	mv x11draw.o o

o/x11lib.o: $(XWINSRC)/x11lib.c $(XWINSRC)/x11.h
	$(CC) $(CFLAGS) $(XINCLUDE) -c $(XWINSRC)/x11lib.c
	mv x11lib.o o

#o/x11share.o: o/x11.o
#o/x11draw.o: o/x11.o

o/BADx11.o: ../virbitmap/X11/x11lib.c ../virbitmap/X11/x11share.c
	cd ../virbitmap/X11 ; ls
	$(MAKE) ../../$(SYSTEM)/o/x11.o \
		SYSTEM=$(SYSTEM) \
		CC='$(CC)' \
		LD='$(LDR)' \
		LDFLAGS='$(LDRFLAGS)' \
		CFLAGS='$(CFLAGS) $(X11_CFLAGS)'

o/unix-x11.o: ../virbitmap/X11/x11lib.c ../virbitmap/X11/x11share.c
	@xinclude=`echo $(XINCLUDE) | sed -e 's/-I//'`; export xinclude;\
	if [ -f $$xinclude/X11/Xlib.h ] || [ -f /usr/include/X11/Xlib.h ] ;\
	then \
		( cd ../virbitmap/X11 ; \
		$(MAKE) ../../$(SYSTEM)/o/x11.o \
			SYSTEM=$(SYSTEM) \
			CC='$(CC)' \
			LD='$(LDR)' \
			LDFLAGS='$(LDRFLAGS)' \
			CFLAGS='$(CFLAGS) $(X11_CFLAGS)' ) ;\
	else \
		echo "make: ** The X11 libraries are not in $$xinclude/X11" ;\
		echo "      ** Edit the XINCLUDE variable in the makefile." ;\
		exit 1 ;\
	fi

#####################################################################
#       Other C files
#
#
# To test the callexterns (without cload)
letestextbin.obj=$(cobj) $(BIN)bin.o o/testext.o 
letestextbin.exe: $(letestextbin.obj) o/def_nlist.o
	@echo Final link for $@
	$(LD) $(LDFLAGS) -o letestextbin \
		$(letestextbin.obj) o/def_nlist.o \
		$(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) $(LDFLAGS) -o letestextbin \
		$(letestextbin.obj) nlist.o \
		$(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) $(LDFLAGS) -o letestextbin \
		$(letestextbin.obj) nlist.o \
		$(LDLIBS)
	echo End of link.

o/testext.o: ../lltest/testext.c $(LLH)
	$(CC) $(CFLAGS) -c ../lltest/testext.c
	$(MV) testext.o o

# The libraries of the linker for C

FORTRAN_LDLIBS= # -lF77

leftestbin.obj=$(cobj) $(BIN)bin.o o/testfortran.o
leftestbin: $(leftestbin.obj)
	@echo Final link for $@
	$(LD) $(LDFLAGS) -o leftestbin \
		$(leftestbin.obj) nlist.o \
		$(FORTRAN_LDLIBS) $(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) $(LDFLAGS) -o leftestbin \
		$(leftestbin.obj) nlist.o \
		$(FORTRAN_LDLIBS) $(LDLIBS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) $(LDFLAGS) -o leftestbin \
		$(leftestbin.obj) nlist.o \
		$(FORTRAN_LDLIBS) $(LDLIBS)
	echo End of link.

o/testfortran.o: ../lltest/testfortran.f
	g77 -c ../lltest/testfortran.f
	$(MV) testfortran.o o/testfortran.o

# for the tests about using C to drive Le-Lisp
fromcbin.obj=o/lelisp.o o/getgloba.o o/llstdio.o o/llfloat.o o/llfloat$(FLT).o o/cfix.o\
$(BIN)bin.o o/fromc.o
fromcbin: $(fromcbin.obj)
	@echo Final link for $@
	$(LD) $(LDFLAGS) -o fromcbin \
		$(fromcbin.obj) \
		$(LDLIBS) \
	;echo End of link.

o/fromc.o: ../lltest/fromc.c
	$(CC) $(CFLAGS) -c ../lltest/fromc.c
	$(MV) fromc.o o

################################################
# BUILDING IMAGES
#
# if nothing is indicated, store the cores in ./llcore/
# if you want to store them elsewhere, conforming to the configurator
# % make lelisp LLCORE=/tmp
LLCORE=
# # # # # # # # # # # # # # # # # # # # # # # #
# The default sizes of the data zones
################################################

# sizes of floating-point numbers for the xxxx31bin
SIZEF31= 0

# sizes of floating-point numbers for the xxxx64bin
SIZEF64= 16

# sizes of floating-point numbers for the xxxxbin
#FLOAT=`if [ "$(FLT)" = "64" ]; then echo 16; else echo 0; fi`
FLOAT=0

# normal with CONS
STACK_C=10
CODE_C=400
HEAP_C=128
NUMBER_C=0
VECTOR_C=1
STRING_C=5
SYMBOL_C=5
CONS_C=10
SZCONS=  -stack $(STACK_C) -code $(CODE_C) -heap $(HEAP_C) \
	-number $(NUMBER_C) -vector $(VECTOR_C) -string $(STRING_C) \
	-symbol $(SYMBOL_C) -cons $(CONS_C) -float $(FLOAT)

# normal with code
STACK_D=12
CODE_D=600
HEAP_D=256
NUMBER_D=0
VECTOR_D=4
STRING_D=5
SYMBOL_D=5
CONS_D=4
SZCODE=  -stack $(STACK_D) -code $(CODE_D) -heap $(HEAP_D) \
	-number $(NUMBER_D) -vector $(VECTOR_D) -string $(STRING_D) \
	-symbol $(SYMBOL_D) -cons $(CONS_D) -float $(FLOAT)

# big
STACK_P=18
CODE_P=2000
HEAP_P=1024
NUMBER_P=0
VECTOR_P=10
STRING_P=18
SYMBOL_P=15
CONS_P=15
SZ++ = -stack $(STACK_P) -code $(CODE_P) -heap $(HEAP_P) \
	-number $(NUMBER_P) -vector $(VECTOR_P) -string $(STRING_P) \
	-symbol $(SYMBOL_P) -cons $(CONS_P) -float $(FLOAT)

# small ~ 800k bytes
STACK_M=6
CODE_M=1
HEAP_M=128
NUMBER_M=0
VECTOR_M=1
STRING_M=3
SYMBOL_M=3
CONS_M=5
SZ-= -stack $(STACK_M) -code $(CODE_M) -heap $(HEAP_M) \
	-number $(NUMBER_M) -vector $(VECTOR_M) -string $(STRING_M) \
	-symbol $(SYMBOL_M) -cons $(CONS_M) -float $(FLOAT)

# ll2lm (idem complice: less code)
SIZEA=-stack $(STACK_P) -code 400 -heap $(HEAP_P) \
	-number $(NUMBER_P) -vector $(VECTOR_P) -string $(STRING_P) \
	-symbol $(SYMBOL_P) -cons $(CONS_P) -float $(FLOAT)

# caml
SIZEZ= -stack 64 -code 2000 -heap 1024 -number 0 \
        -vector 30 -string 40 -symbol 8 -cons 15 -float $(FLOAT)

# Normal sizes
SIZE=$(SZCODE)
SIZEM=$(SZ-)
SIZEH=$(SZ++)

##########################################################
# Entry points to make systems
##########################################################

### lelisp "standard modular system"
lelisp:  conf/Lelispconf.ll lelispbin llcore/lelisp.core
	./config lelisp lelispbin.exe Lelispconf.ll $(LLCORE) $(SIZE)
llcore/lelisp.core:

### lelisp- "standard interpreted system"
lelisp-:  conf/Lelisp-conf.ll lelispbin llcore/lelisp-.core
	./config lelisp- lelispbin Lelisp-conf.ll $(LLCORE) $(SIZEM)
llcore/lelisp-.core:

### lelisp++ "big standard modular system"
lelisp++:  conf/Lelispconf.ll lelispbin llcore/lelisp++.core
	./config lelisp++ lelispbin Lelispconf.ll $(LLCORE) $(SIZEH)
llcore/lelisp++.core:

### lelisps "standard compiled system"
lelisps:  conf/Lelispsconf.ll lelispbin llcore/lelisps.core
	./config lelisps lelispbin Lelispsconf.ll $(LLCORE) $(SZCONS)
llcore/lelisps.core:

### cmplc "modular complice system"
cmplc:  conf/Cmplcconf.ll lelispbin llcore/cmplc.core
	./config cmplc lelispbin Cmplcconf.ll $(LLCORE) $(SIZE)
llcore/cmplc.core:

### cmplc++ "big modular complice system"
cmplc++:  conf/Cmplcconf.ll lelispbin llcore/cmplc++.core
	./config cmplc++ lelispbin Cmplcconf.ll $(LLCORE) $(SIZEH)
llcore/cmplc++.core:

### ll2lm "analyzer system"
ll2lm: cll2lm
cll2lm:  conf/Cll2lmconf.ll lelispbin llcore/cll2lm.core
	./config cll2lm lelispbin Cll2lmconf.ll $(LLCORE) $(SIZEA)
llcore/cll2lm.core:

### ceyx "standard modular system with CEYX"
ceyx:  conf/Ceyxconf.ll lelispbin llcore/ceyx.core
	./config ceyx lelispbin Ceyxconf.ll $(LLCORE) $(SIZE)
llcore/ceyx.core:

### lelispX11 "standard modular system with VB under X11"
lelispX11:  conf/LeX11conf.ll leX11bin llcore/lelispX11.core
	./config lelispX11 leX11bin LeX11conf.ll $(LLCORE) $(SIZE)
llcore/lelispX11.core:

### lelispM11 "standard modular system with VB under Motif"
lelispM11:  conf/LeX11conf.ll leM11bin llcore/lelispM11.core
	./config lelispM11 leM11bin LeX11conf.ll $(LLCORE) $(SIZE)
llcore/lelispM11.core:

### lelisp: standard modular system with 64-bit floats

lelisp$(FLT): conf/Lelispconf.ll  lelisp$(FLT)$(EXE)bin
	./config lelisp$(FLT) lelisp$(FLT)$(EXE)bin Lelispconf.ll $(LLCORE) $(SIZE) -float $(SIZEF64)

#########################################################################
# a generic input for difficult users
# since all files are parameterized, you can rebuild your own binary
# (you can even redefine the compilo: ex: CC=/bin/f77
# ex:
# % make monlelispbin USERBIN=monlelispbin USERO="foo.o bar.o"
# to change the floating-point mode, if required
USERBINO=$(BIN)bin.o
# for the name of the binary
USERBIN=monlelispbin
# the *.o user files
USERO=
# to obtain additional flags
USERFLAGS=

# the simplest binary
USERBIN.obj=$(cobj) $(USERBINO) $(USERO)

$(USERBIN): ${USERBIN.obj}
	@echo Final link for $@
	$(LD)	-o $(USERBIN) \
		$(LDFLAGS) \
		${USERBIN.obj} \
		$(LDLIBS) \
		$(USERFLAGS) \
	;echo End of link.

USERXBIN=monlelispX11bin

# the binary that integrates X
USERXBIN.obj=$(cobj) $(x11cobj) $(USERBINO) $(USERO)

$(USERXBIN): ${USERXBIN.obj} o/def_nlist.o
	@echo Final link for $@
	$(LD) -o $(USERXBIN) \
		$(LDFLAGS) \
		$(X11_LDFLAGS) \
		$(USERXBIN.obj) o/def_nlist.o \
		$(X11_LDLIBS) $(LDLIBS) $(USERFLAGS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) -o $(USERXBIN) \
		$(LDFLAGS) \
		$(X11_LDFLAGS) \
		$(USERXBIN.obj) nlist.o \
		$(X11_LDLIBS) $(LDLIBS) $(USERFLAGS)
	@cp C/nlist.prologue nlist.c
	@nm $@ | sed -f C/nlist.sed | grep "0x0" >> nlist.c
	@cat C/nlist.epilogue >> nlist.c
	@$(CC) -c -o nlist.o nlist.c
	$(LD) -o $(USERXBIN) \
		$(LDFLAGS) \
		$(X11_LDFLAGS) \
		$(USERXBIN.obj) nlist.o \
		$(X11_LDLIBS) $(LDLIBS) $(USERFLAGS)
	@echo End of link.

# warning: this entry don't include motif C obj, just VB files for motif
USERMBIN=monM11bin

# the binary that integrates VB files for Motif
USERMBIN.obj=$(cobj) $(motifcobj) $(USERBINO) $(USERO)

$(USERMBIN): ${USERMBIN.obj}
	@echo Final link for $@
	$(LD)  -o $(USERMBIN) \
		$(MOTIF_LDFLAGS) $(X11_LDFLAGS) $(LDFLAGS) \
		${USERMBIN.obj} \
		$(MOTIF_LDLIBS) $(X11_LDLIBS) $(LDLIBS) \
		$(USERFLAGS) \
	;echo End of link.

# A generic input to compile a C file
# with the right flags
USERCFLAGS=
USERCFILE=_foo.c
USEROFILE=/tmp/_foo.o

$(USEROFILE): $(USERCFILE)
	$(CC) $(CFLAGS) $(USERCFLAGS) -c $(USERCFILE)
	@if [ `basename $(USERCFILE) .c`.o != $(USEROFILE) ] ; then \
	echo $(MV) `basename $(USERCFILE) .c`.o $(USEROFILE); \
	$(MV) `basename $(USERCFILE) .c`.o $(USEROFILE);  fi

USERXCFILE=_foox.c
USERXOFILE=/tmp/_foox.o

$(USERXOFILE): $(USERXCFILE)
	$(CC) $(CFLAGS) $(X11_CFLAGS) $(USERCFLAGS) -c $(USERXCFILE)
	@if [ `basename $(USERXCFILE) .c`.o != $(USERXOFILE) ] ; then \
	echo $(MV) `basename $(USERXCFILE) .c`.o $(USERXOFILE); \
	$(MV) `basename $(USERXCFILE) .c`.o $(USERXOFILE);  fi

# to link with retain location entries in the output file
USERRFILE=foobar.o
USERRFILES=foo.o bar.o
$(USERRFILE): $(USERRFILES)
	echo $(USERRFILES)
	rm -f $@
	$(LDR) $(LDRFLAGS) $@ $(USERRFILES)

# A generic input to help the user
#  to build cores linked to the binary
#
# The name of the command that launches the system
USERLELISP=monlelisp
#
# The configurator that indicates what to put in this core
# Warning: this file must be addressed by an absolute path
#            or be stored in lelisp/$(SYSTEM)/conf
USERCONF= $(USERLELISP)conf.ll
#
# The directory where cores are stored: by default lelisp/$(SYSTEM)/llcore/
#  Warning: if it changes, $(USERCONF) must integrate it
#  Warning: the path supplied in USERLLCORE must designate
#		  a directory, and end with /
#		  ex: USERLLCORE=/usr/ilog/lelisp/$(SYSTEM)/llcore/
USERLLCORE=
#
# The user binary to build this system
#  by default it is the ordinary USERXBIN that integrates X
#  but you can also have:
#  USERLELISPBIN=" \$(USERBIN)" to avoid integrating X
#   or
#  USERLELISPBIN=/home/me/mybin to do what you want
#
USERLELISPBIN=$(USERXBIN)
USERSIZE=$(SIZE)

$(USERLELISP):  $(USERLELISPBIN)
	./config $(USERLELISP) $(USERLELISPBIN) $(USERCONF) $(USERLLCORE) $(USERSIZE)

# DO NOT DELETE
