
/* Maintenance:               automatic genereted file  */
/*                                                      */
/* $Id$ */
/********************************************************/

/*	Conditionnals for C compilation  :
	==================================

	systems types and sub-types :

	      __STDC__           : Ansi C (obligatory for .h)
	      _ANSI_SOURCE       : Ansi C (obligatory for .h)
	      _POSIX_SOURCE      : POSIX  (obligatory for .h)

  other options for C compilation.

	variables: [-DXXX=yyy]
	      NBSYST  :       system number.
	      FILEINI :       name of startup file.
	                         default= ../llib/startup.ll
	      LLSYSNAME:      system name.
	                         default= lelisp
	      LLPAGESIZE:     size of a memory page.
	                         default=1024
	      LLTIMEUNIT:     clock tick per seconde.
	                         default=HZ on S5
	flags: [-DXXX]
	      FILIT   :       flag for init file.
	      LLBAN   :       flag for banner.
	      LLFOREIGN :     for messages in english.
	                         default=1
	      EXECORE :       for executable lisp core (a.out).
	                         default=0
	      CLOAD   :       for dynamic link.
	                         default= CLOAD= not(S5)
	      ITINREAD:       for scanning IT during the read of a char.
	                         default=BSD
	      MULTIPLECLOAD:  for dynamic link of the same file.o
	                         default=0
	      LLRENAME:       for use of function 'rename' in standard C library.
	                         default=BSD
	      LLFOREGROUND:   for use of processes in background mode.
	                         default=BSD
	      LLVFORK :       for vfork instead of fork.
	                         default=BSD
	      LLSHARED:       for systems with shared memory.
	                         default=BSD||S5=not(OS2)
	LLGHOSTPROC:	for creating small process instead of fork/vfork.
			  default=0
	      LLWILDCARD:     for new WILDCARD writen in C and LL with no call
	                       to SHELL, (no use of internal buffer).
	                         default=1 (always true)
	LLSTACK:	for systems with a special stack Le-Lisp (all 386).
			  default= I386
	      LLPROTO:        for prototype functions.
	                         default=0
	LLELF:          for ELF format.
	                         default=SVR4
*/

/*****************************************************

                   set of definitions

 *****************************************************/
/*      system constantes
        -------------------------  */

/* initialisation file */
#ifndef FILEINI

#define FILEINI "../llib/startup.ll"

#endif	/* FILEINI */

/* 0 = initial file, 1 = core */
#define FILIT 0

/* 0 = banner,  1 = silence */
#define LLBAN 0

/* 	Parameters for multi-files system */
#ifndef  LLMAXCHAR
#define  LLMAXCHAR  1024  /* size of LLM3 buffer (1024 max) */
#endif 	/* LLMAXCHAR */

#ifndef  LLMAXCHAN
#define  LLMAXCHAN  24    /* max channels */
#endif 	/* LLMAXCHAN */

/*      specifics flags for this system
        --------------------------------------  */

/* system number */
#ifndef NBSYST

#define NBSYST 47

#endif	/* NBSYST */

/* size of a memory page (pagesize(1) or getpagesize(2) or
   documentation). have to be a power of 2 >= BIPTR */
#ifndef LLPAGESIZE

#define LLPAGESIZE	4096

#endif	/* LLPAGESIZE */

/* system name  : CAML or Le-Lisp */
#ifndef LLSYSNAME

#define LLSYSNAME	"Le-Lisp"

#endif	/* LLSYSNAME */

/*      specifics flags for this machine
        ----------------------------------------- */

#define NOCLOAD

/* # messages language default english) */
#define LLFOREIGN

/* # control of background/foreground */

#define LLFOREGROUND

/* # system see IT during a read */
#define ITINREAD

/* # syst. call:  rename */
#define LLRENAME

/* # shared memory on this system ? */
#define LLSHARED

/* # new WILDCARD */
#define LLWILDCARD

/*****************************************************

        	     declarations

 *****************************************************/

/* flag on/off for system error printing */
extern int **prtmsgs;   	/* in save-core ! */

#define LLM3VAR extern

/*****************************************************

        	        includes

 *****************************************************/

#define _ALL_SOURCE             /* for types syntaxe in a.out.h */

#define NBBY 8
#include <sys/select.h>

#include <sys/types.h>		/* for every body  */

#include <a.out.h>

#include <sys/stat.h>           /* for every body */
#include <stdio.h>              /* for ios */
#include <errno.h>              /* for perror */
#include <fcntl.h>              /* for open and fcntl */
#include <time.h>               /* for date */

#include <sys/time.h>           /* for runtime */

#include <sys/times.h>

#include <sys/param.h>

#include <termios.h>            /* for POSIX tty */

#include <dirent.h>             /* for struct DIR & opendir */

#include <unistd.h>		/* for pbs STDC/POSIX/AnsiC */
#ifndef __sys_signal_h
#include <signal.h>		/* for UNIX signals */
#endif

/*     End specials cases   */

/* ***************************************************
			C MACROS
   *************************************************** */

/* aligned adresses on LLPAGESIZE */
#define align(x) (x = ((x+LLPAGESIZE-1)&~(LLPAGESIZE-1)))

/* some adresses must be aligned */
#define _llround(x,s) ((((x)-1) & ~((s)-1)) +(s))

/*  printing system errors */
#define errreturn(M,V) { if(**prtmsgs == 0) perror(M) ; return(V); }

/* ld -A for cload function */

#ifndef BIN_LD_A
/* defaut value */
#define BIN_LD_A     "/bin/ld -A %s -N -x -T %x -o %s %s -lc"
#endif

/* default value */
#ifndef READDIR_TYPE
#define READDIR_TYPE dirent
#endif

/* O_BINARY on UNIX */
#ifndef O_BINARY
#define O_BINARY 0x0
#endif

/* # signature of signal() */

typedef void (*signal_type)();

#define SIGNAL(sig,func) signal(sig,func)

/* # extern brk() */

#define EXTERN_BRK() extern char *brk();

/* # extern sbrk() */

#define EXTERN_SBRK() extern char *sbrk();

/* # function get current directory */

#define LLGETCWD(s,l) getcwd(s,l)

/* # align bmem on LLMAXPAGESIZE or PAGESIZE */

#define LLMAXPAGESIZE 8192

#define LLBMEMALIGN(b) (char *)_llround((long)b+LLMAXPAGESIZE, LLMAXPAGESIZE)

/* current process group */

#define GETPGRP() getpgrp()

/* output length of 31bitfloats */

#define LLPRT31BITS "%.7g"

/* output length of 64bitfloats */

#define LLPRT64BITS "%.12g"

/* # max stack size on this system */

#define LLSTACKMAX 1000000

/* # mkdir function */

#define LLMKDIR(p,n) mkdir(p,n)

/* #  EVLOOP_MAXFDS variable */

#define LLEVLOOP_MAXFDS (NOFILE > 32 ? 32 : NOFILE)

/* # ptr size on this machine */
