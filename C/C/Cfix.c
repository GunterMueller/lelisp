/*                                                           */
/* $Id: Cfix.c,v 1.2 2017/07/08 07:05:41 jullien Exp $ */
/*************************************************************/
/*                                                           */
/*       Le-Lisp C fix converters and equo functions         */
/*************************************************************/

/* includes */
#include "lelisp.h"

/* converter C FIX -> Le-Lisp FIX */

LL_OBJECT
cfix_to_lfix(long i) {
         return(LL_OBJECT)(i & 0xffff);
}

/* converter Le-Lisp FIX -> C FIX */

long
lfix_to_cfix(LL_OBJECT i) {
        long l = (long)i;
        return((l << 16) >> 16);
}

