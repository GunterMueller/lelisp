# Interface Le-Lisp / KerN
#
# 1/ check the variable KERN for dependant version of bnkern.o :
# for example in a SUN  : KERN=sun
#             in a IBMRT: KERN=c
#             in a machine without C compiler: KERN=lisp
#
# 2/ check that variables LLDIR and SYSTEM have good values. 
#
# 3/ Install all the files in your Le-Lisp package :
#	$ make Install

# Paths for the `Install` key.
LLDIR=/usr/ilog/lelisp
KERN=c
SYSTEM=linux
LD=ld

# Flags for ld in C configuration
LDFLAGS=-r # -x
#special case on DG(m88k)
# LDFLAGS=-r -x -F 0555

# Flags for the Lisp Compiler Complice
COMPF=-callext t -parano nil -w t -o llobj -p llib/ -p llmod/

# List of modules
FILES=bngen bnn bnq bnz

# make Le-Lisp modules:
all: $(KERN) gen kern n z q

Install: all
	for i in $(FILES) ; do			\
		cp llib/$$i.ll $(LLDIR)/llib;	\
		cp llobj/$$i.lo $(LLDIR)/llobj;	\
		cp llmod/$$i.lm $(LLDIR)/llmod;	\
		done
	cp o/$(KERN)kern.o $(LLDIR)/$(SYSTEM)/kern.o
	cp system/bnkern.* $(LLDIR)/$(SYSTEM)
	cp lltest/*.ll $(LLDIR)/lltest

# Machines specifications (680x0, Vax, portable C, portable Le-Lisp)
# Make your choice with makefile's variable KERN
sun:	Dosun kern llkern

Dosun:	o/sunkern.o
	rm -f system/bnkern.* o/kern.o
	ln -s sunkern.o o/kern.o
	ln -s ../llmod/bnkern.lm system/bnkern.lm
	ln -s ../llobj/llkern.lo system/bnkern.lo
	ln -s ../llib/llkern.ll system/bnkern.ll

vax:	Dovax kern llkern

Dovax:	o/vaxkern.o
	rm -f system/bnkern.* o/kern.o
	ln -s vaxkern.o o/kern.o
	ln -s ../llmod/bnkern.lm system/bnkern.lm
	ln -s ../llobj/llkern.lo system/bnkern.lo
	ln -s ../llib/llkern.ll system/bnkern.ll

mips:	Domips kern llkern

Domips:	o/mipskern.o
	rm -f system/bnkern.* o/kern.o
	ln -s mipskern.o o/kern.o
	ln -s ../llmod/bnkern.lm system/bnkern.lm
	ln -s ../llobj/llkern.lo system/bnkern.lo
	ln -s ../llib/llkern.ll system/bnkern.ll

sparc:	Dosparc kern llkern

Dosparc:	o/sparckern.o
	rm -f system/bnkern.* o/kern.o
	ln -s sparckern.o o/kern.o
	ln -s ../llmod/bnkern.lm system/bnkern.lm
	ln -s ../llobj/llkern.lo system/bnkern.lo
	ln -s ../llib/llkern.ll system/bnkern.ll

rs6000:	Dors6000 kern llkern

Dors6000:	o/rs6000kern.o
	rm -f system/bnkern.* o/kern.o
	ln -s rs6000kern.o o/kern.o
	ln -s ../llmod/bnkern.lm system/bnkern.lm
	ln -s ../llobj/llkern.lo system/bnkern.lo
	ln -s ../llib/llkern.ll system/bnkern.ll

lisp:	kern
	rm -f system/bnkern.* o/lispkern.o
	touch o/lispkern.o
	ln -s ../llmod/bnkern.lm system/bnkern.lm
	ln -s ../llobj/bnkern.lo system/bnkern.lo
	ln -s ../llib/bnkern.ll system/bnkern.ll

c:	Doc kern ckern

Doc:	o/ckern.o
	rm -f system/bnkern.* o/kern.o
	ln -s ckern.o o/kern.o
	ln -s ../llmod/bnkern.lm system/bnkern.lm
	ln -s ../llobj/ckern.lo system/bnkern.lo
	ln -s ../llib/ckern.ll system/bnkern.ll

# making the .o
o/sunkern.o:	s/sunkern.s
	as s/sunkern.s -o o/sunkern.o

o/vaxkern.o:	s/vaxkern.s
	as s/vaxkern.s -o o/vaxkern.o

o/mipskern.o:	s/mipskern.s
	as -w s/mipskern.s -o o/mipskern.o

o/sparckern.o:	s/sparckern.s
	as s/sparckern.s -o o/sparckern.o

o/rs6000kern.o:	s/rs6000kern.s
	as s/rs6000kern.s -o o/rs6000kern.o

o/ckern.o: o/llkern.o ../o/KerN.o
	$(LD) $(LDFLAGS) o/llkern.o ../o/KerN.o -o o/ckern.o

CFLAGS=-DDIGITon32BITS -I../h -O
o/llkern.o: 
	$(CC) $(CFLAGS) -c common/llkern.c
	mv llkern.o o

# Le-Lisp Modules
kern:	llobj/bnkern.lo
llkern:	llobj/llkern.lo
ckern:	llobj/ckern.lo
gen:	llobj/bngen.lo
n:	llobj/bnn.lo
z:	llobj/bnz.lo
q:	llobj/bnq.lo

# Le-Lisp compilation
CMDDIR=/usr/local/bin

llobj/bnkern.lo:	llmod/bnkern.lm llib/bnkern.ll
	$(CMDDIR)/complice $(COMPF) bnkern

llobj/llkern.lo:	llmod/llkern.lm llib/llkern.ll
	$(CMDDIR)/complice $(COMPF) -p o/ llkern

llobj/ckern.lo:	llmod/ckern.lm llib/ckern.ll
	$(CMDDIR)/complice $(COMPF) -p o/ ckern

llobj/bngen.lo:	llmod/bngen.lm llib/bngen.ll
	$(CMDDIR)/complice $(COMPF) bngen

llobj/bnn.lo:	llmod/bnkern.lm llmod/bnn.lm llib/bnn.ll
	$(CMDDIR)/complice $(COMPF) bnn

llobj/bnz.lo:	llmod/bngen.lm llmod/bnkern.lm \
		llmod/bnn.lm llmod/bnz.lm llib/bnz.ll
	$(CMDDIR)/complice $(COMPF) bnz

llobj/bnq.lo:	llmod/bngen.lm llmod/bnz.lm llmod/bnq.lm llib/bnq.ll
	$(CMDDIR)/complice $(COMPF) bnq
