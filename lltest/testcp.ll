;;;
;;; testcp.ll:  Compiled functions tests
;;;
;;; $Source: /usr/cvs/lelisp/lltest/testcp.ll,v $
;;; $Date: 2016/05/21 10:36:07 $
;;; $Revision: 1.2 $
;;;
;;; ------------------------------------------------------------
;;; This file is part of Le-Lisp version 15, developped by INRIA
;;;
;;;
;;; (c) 1987-1993  Le-Lisp is a trademark of INRIA.
;;; ------------------------------------------------------------


(unless (>= (version) 15.2)
        (error 'load 'erricf 'testcp))
 
(unless (featurep 'testcomm)
        (libload testcomm))

(testcp ()
   (catenate #:system:lltest-directory
	     "fn.lt"))
