;;;
;;; TAKR:  The Le-Lisp Benchmarks (6)
;;;
;;; $Source: /usr/cvs/lelisp/benchmarks/takr.ll,v $
;;; $Date: 2016/05/21 16:28:02 $
;;; $Revision: 1.2 $
;;;
;;; ------------------------------------------------------------
;;; This file is part of Le-Lisp version 15, developped by INRIA
;;;
;;;
;;; (c) 1987-1993  Le-Lisp is a trademark of INRIA.
;;; ------------------------------------------------------------


;;; (6) TAKR
;;; TAKR  -- 100 function (count `em) version of TAK that tries to defeat cache
;;; memory effects.  Results should be the same as for TAK on stack machines.
;;; Distribution of calls is not completely flat.


(defun check-takr ()
   (check-value '(test-takr 1) 7))

(defun meter-takr ()
   (perform-meter (takr 18 12 6)))

(defun test-takr (n)
   (if (eq n 1)
       (takr 18 12 6)
       (repeat n (takr 18 12 6))))


;;; ------------------------------------------------------------


(defun takr (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak1 (tak37 (sub1 x) y z)
		  (tak11 (sub1 y) z x)
		  (tak17 (sub1 z) x y)))))
(defun tak1 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak2 (tak74 (sub1 x) y z)
		  (tak22 (sub1 y) z x)
		  (tak34 (sub1 z) x y)))))
(defun tak2 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak3 (tak11 (sub1 x) y z)
		  (tak33 (sub1 y) z x)
		  (tak51 (sub1 z) x y)))))
(defun tak3 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak4 (tak48 (sub1 x) y z)
		  (tak44 (sub1 y) z x)
		  (tak68 (sub1 z) x y)))))
(defun tak4 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak5 (tak85 (sub1 x) y z)
		  (tak55 (sub1 y) z x)
		  (tak85 (sub1 z) x y)))))
(defun tak5 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak6 (tak22 (sub1 x) y z)
		  (tak66 (sub1 y) z x)
		  (tak2 (sub1 z) x y)))))
(defun tak6 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak7 (tak59 (sub1 x) y z)
		  (tak77 (sub1 y) z x)
		  (tak19 (sub1 z) x y)))))
(defun tak7 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak8 (tak96 (sub1 x) y z)
		  (tak88 (sub1 y) z x)
		  (tak36 (sub1 z) x y)))))
(defun tak8 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak9 (tak33 (sub1 x) y z)
		  (tak99 (sub1 y) z x)
		  (tak53 (sub1 z) x y)))))
(defun tak9 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak10 (tak70 (sub1 x) y z)
		   (tak10 (sub1 y) z x)
		   (tak70 (sub1 z) x y)))))
(defun tak10 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak11 (tak7 (sub1 x) y z)
		   (tak21 (sub1 y) z x)
		   (tak87 (sub1 z) x y)))))
(defun tak11 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak12 (tak44 (sub1 x) y z)
		   (tak32 (sub1 y) z x)
		   (tak4 (sub1 z) x y)))))
(defun tak12 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak13 (tak81 (sub1 x) y z)
		   (tak43 (sub1 y) z x)
		   (tak21 (sub1 z) x y)))))

(defun tak13 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak14 (tak18 (sub1 x) y z)
		   (tak54 (sub1 y) z x)
		   (tak38 (sub1 z) x y)))))
(defun tak14 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak15 (tak55 (sub1 x) y z)
		   (tak65 (sub1 y) z x)
		   (tak55 (sub1 z) x y)))))
(defun tak15 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak16 (tak92 (sub1 x) y z)
		   (tak76 (sub1 y) z x)
		   (tak72 (sub1 z) x y)))))
(defun tak16 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak17 (tak29 (sub1 x) y z)
		   (tak87 (sub1 y) z x)
		   (tak89 (sub1 z) x y)))))
(defun tak17 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak18 (tak66 (sub1 x) y z)
		   (tak98 (sub1 y) z x)
		   (tak6 (sub1 z) x y)))))
(defun tak18 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak19 (tak3 (sub1 x) y z)
		   (tak9 (sub1 y) z x)
		   (tak23 (sub1 z) x y)))))
(defun tak19 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak20 (tak40 (sub1 x) y z)
		   (tak20 (sub1 y) z x)
		   (tak40 (sub1 z) x y)))))
(defun tak20 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak21 (tak77 (sub1 x) y z)
		   (tak31 (sub1 y) z x)
		   (tak57 (sub1 z) x y)))))
(defun tak21 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak22 (tak14 (sub1 x) y z)
		   (tak42 (sub1 y) z x)
		   (tak74 (sub1 z) x y)))))
(defun tak22 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak23 (tak51 (sub1 x) y z)
		   (tak53 (sub1 y) z x)
		   (tak91 (sub1 z) x y)))))
(defun tak23 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak24 (tak88 (sub1 x) y z)
		   (tak64 (sub1 y) z x)
		   (tak8 (sub1 z) x y)))))
(defun tak24 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak25 (tak25 (sub1 x) y z)
		   (tak75 (sub1 y) z x)
		   (tak25 (sub1 z) x y)))))
(defun tak25 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak26 (tak62 (sub1 x) y z)
		   (tak86 (sub1 y) z x)
		   (tak42 (sub1 z) x y)))))
(defun tak26 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak27 (tak99 (sub1 x) y z)
		   (tak97 (sub1 y) z x)
		   (tak59 (sub1 z) x y)))))
(defun tak27 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak28 (tak36 (sub1 x) y z)
		   (tak8 (sub1 y) z x)
		   (tak76 (sub1 z) x y)))))
(defun tak28 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak29 (tak73 (sub1 x) y z)
		   (tak19 (sub1 y) z x)
		   (tak93 (sub1 z) x y)))))
(defun tak29 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak30 (tak10 (sub1 x) y z)
		   (tak30 (sub1 y) z x)
		   (tak10 (sub1 z) x y)))))
(defun tak30 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak31 (tak47 (sub1 x) y z)
		   (tak41 (sub1 y) z x)
		   (tak27 (sub1 z) x y)))))
(defun tak31 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak32 (tak84 (sub1 x) y z)
		   (tak52 (sub1 y) z x)
		   (tak44 (sub1 z) x y)))))
(defun tak32 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak33 (tak21 (sub1 x) y z)
		   (tak63 (sub1 y) z x)
		   (tak61 (sub1 z) x y)))))
(defun tak33 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak34 (tak58 (sub1 x) y z)
		   (tak74 (sub1 y) z x)
		   (tak78 (sub1 z) x y)))))
(defun tak34 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak35 (tak95 (sub1 x) y z)
		   (tak85 (sub1 y) z x)
		   (tak95 (sub1 z) x y)))))
(defun tak35 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak36 (tak32 (sub1 x) y z)
		   (tak96 (sub1 y) z x)
		   (tak12 (sub1 z) x y)))))
(defun tak36 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak37 (tak69 (sub1 x) y z)
		   (tak7 (sub1 y) z x)
		   (tak29 (sub1 z) x y)))))
(defun tak37 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak38 (tak6 (sub1 x) y z)
		   (tak18 (sub1 y) z x)
		   (tak46 (sub1 z) x y)))))
(defun tak38 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak39 (tak43 (sub1 x) y z)
		   (tak29 (sub1 y) z x)
		   (tak63 (sub1 z) x y)))))
(defun tak39 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak40 (tak80 (sub1 x) y z)
		   (tak40 (sub1 y) z x)
		   (tak80 (sub1 z) x y)))))
(defun tak40 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak41 (tak17 (sub1 x) y z)
		   (tak51 (sub1 y) z x)
		   (tak97 (sub1 z) x y)))))
(defun tak41 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak42 (tak54 (sub1 x) y z)
		   (tak62 (sub1 y) z x)
		   (tak14 (sub1 z) x y)))))
(defun tak42 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak43 (tak91 (sub1 x) y z)
		   (tak73 (sub1 y) z x)
		   (tak31 (sub1 z) x y)))))
(defun tak43 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak44 (tak28 (sub1 x) y z)
		   (tak84 (sub1 y) z x)
		   (tak48 (sub1 z) x y)))))
(defun tak44 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak45 (tak65 (sub1 x) y z)
		   (tak95 (sub1 y) z x)
		   (tak65 (sub1 z) x y)))))
(defun tak45 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak46 (tak2 (sub1 x) y z)
		   (tak6 (sub1 y) z x)
		   (tak82 (sub1 z) x y)))))
(defun tak46 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak47 (tak39 (sub1 x) y z)
		   (tak17 (sub1 y) z x)
		   (tak99 (sub1 z) x y)))))
(defun tak47 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak48 (tak76 (sub1 x) y z)
		   (tak28 (sub1 y) z x)
		   (tak16 (sub1 z) x y)))))
(defun tak48 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak49 (tak13 (sub1 x) y z)
		   (tak39 (sub1 y) z x)
		   (tak33 (sub1 z) x y)))))
(defun tak49 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak50 (tak50 (sub1 x) y z)
		   (tak50 (sub1 y) z x)
		   (tak50 (sub1 z) x y)))))
(defun tak50 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak51 (tak87 (sub1 x) y z)
		   (tak61 (sub1 y) z x)
		   (tak67 (sub1 z) x y)))))
(defun tak51 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak52 (tak24 (sub1 x) y z)
		   (tak72 (sub1 y) z x)
		   (tak84 (sub1 z) x y)))))
(defun tak52 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak53 (tak61 (sub1 x) y z)
		   (tak83 (sub1 y) z x)
		   (tak1 (sub1 z) x y)))))
(defun tak53 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak54 (tak98 (sub1 x) y z)
		   (tak94 (sub1 y) z x)
		   (tak18 (sub1 z) x y)))))
(defun tak54 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak55 (tak35 (sub1 x) y z)
		   (tak5 (sub1 y) z x)
		   (tak35 (sub1 z) x y)))))
(defun tak55 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak56 (tak72 (sub1 x) y z)
		   (tak16 (sub1 y) z x)
		   (tak52 (sub1 z) x y)))))
(defun tak56 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak57 (tak9 (sub1 x) y z)
		   (tak27 (sub1 y) z x)
		   (tak69 (sub1 z) x y)))))
(defun tak57 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak58 (tak46 (sub1 x) y z)
		   (tak38 (sub1 y) z x)
		   (tak86 (sub1 z) x y)))))
(defun tak58 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak59 (tak83 (sub1 x) y z)
		   (tak49 (sub1 y) z x)
		   (tak3 (sub1 z) x y)))))
(defun tak59 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak60 (tak20 (sub1 x) y z)
		   (tak60 (sub1 y) z x)
		   (tak20 (sub1 z) x y)))))
(defun tak60 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak61 (tak57 (sub1 x) y z)
		   (tak71 (sub1 y) z x)
		   (tak37 (sub1 z) x y)))))
(defun tak61 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak62 (tak94 (sub1 x) y z)
		   (tak82 (sub1 y) z x)
		   (tak54 (sub1 z) x y)))))
(defun tak62 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak63 (tak31 (sub1 x) y z)
		   (tak93 (sub1 y) z x)
		   (tak71 (sub1 z) x y)))))
(defun tak63 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak64 (tak68 (sub1 x) y z)
		   (tak4 (sub1 y) z x)
		   (tak88 (sub1 z) x y)))))
(defun tak64 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak65 (tak5 (sub1 x) y z)
		   (tak15 (sub1 y) z x)
		   (tak5 (sub1 z) x y)))))
(defun tak65 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak66 (tak42 (sub1 x) y z)
		   (tak26 (sub1 y) z x)
		   (tak22 (sub1 z) x y)))))
(defun tak66 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak67 (tak79 (sub1 x) y z)
		   (tak37 (sub1 y) z x)
		   (tak39 (sub1 z) x y)))))
(defun tak67 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak68 (tak16 (sub1 x) y z)
		   (tak48 (sub1 y) z x)
		   (tak56 (sub1 z) x y)))))
(defun tak68 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak69 (tak53 (sub1 x) y z)
		   (tak59 (sub1 y) z x)
		   (tak73 (sub1 z) x y)))))
(defun tak69 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak70 (tak90 (sub1 x) y z)
		   (tak70 (sub1 y) z x)
		   (tak90 (sub1 z) x y)))))
(defun tak70 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak71 (tak27 (sub1 x) y z)
		   (tak81 (sub1 y) z x)
		   (tak7 (sub1 z) x y)))))
(defun tak71 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak72 (tak64 (sub1 x) y z)
		   (tak92 (sub1 y) z x)
		   (tak24 (sub1 z) x y)))))
(defun tak72 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak73 (tak1 (sub1 x) y z)
		   (tak3 (sub1 y) z x)
		   (tak41 (sub1 z) x y)))))
(defun tak73 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak74 (tak38 (sub1 x) y z)
		   (tak14 (sub1 y) z x)
		   (tak58 (sub1 z) x y)))))
(defun tak74 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak75 (tak75 (sub1 x) y z)
		   (tak25 (sub1 y) z x)
		   (tak75 (sub1 z) x y)))))
(defun tak75 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak76 (tak12 (sub1 x) y z)
		   (tak36 (sub1 y) z x)
		   (tak92 (sub1 z) x y)))))
(defun tak76 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak77 (tak49 (sub1 x) y z)
		   (tak47 (sub1 y) z x)
		   (tak9 (sub1 z) x y)))))
(defun tak77 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak78 (tak86 (sub1 x) y z)
		   (tak58 (sub1 y) z x)
		   (tak26 (sub1 z) x y)))))
(defun tak78 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak79 (tak23 (sub1 x) y z)
		   (tak69 (sub1 y) z x)
		   (tak43 (sub1 z) x y)))))
(defun tak79 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak80 (tak60 (sub1 x) y z)
		   (tak80 (sub1 y) z x)
		   (tak60 (sub1 z) x y)))))
(defun tak80 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak81 (tak97 (sub1 x) y z)
		   (tak91 (sub1 y) z x)
		   (tak77 (sub1 z) x y)))))
(defun tak81 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak82 (tak34 (sub1 x) y z)
		   (tak2 (sub1 y) z x)
		   (tak94 (sub1 z) x y)))))
(defun tak82 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak83 (tak71 (sub1 x) y z)
		   (tak13 (sub1 y) z x)
		   (tak11 (sub1 z) x y)))))
(defun tak83 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak84 (tak8 (sub1 x) y z)
		   (tak24 (sub1 y) z x)
		   (tak28 (sub1 z) x y)))))
(defun tak84 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak85 (tak45 (sub1 x) y z)
		   (tak35 (sub1 y) z x)
		   (tak45 (sub1 z) x y)))))
(defun tak85 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak86 (tak82 (sub1 x) y z)
		   (tak46 (sub1 y) z x)
		   (tak62 (sub1 z) x y)))))
(defun tak86 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak87 (tak19 (sub1 x) y z)
		   (tak57 (sub1 y) z x)
		   (tak79 (sub1 z) x y)))))
(defun tak87 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak88 (tak56 (sub1 x) y z)
		   (tak68 (sub1 y) z x)
		   (tak96 (sub1 z) x y)))))
(defun tak88 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak89 (tak93 (sub1 x) y z)
		   (tak79 (sub1 y) z x)
		   (tak13 (sub1 z) x y)))))
(defun tak89 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak90 (tak30 (sub1 x) y z)
		   (tak90 (sub1 y) z x)
		   (tak30 (sub1 z) x y)))))
(defun tak90 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak91 (tak67 (sub1 x) y z)
		   (tak1 (sub1 y) z x)
		   (tak47 (sub1 z) x y)))))
(defun tak91 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak92 (tak4 (sub1 x) y z)
		   (tak12 (sub1 y) z x)
		   (tak64 (sub1 z) x y)))))
(defun tak92 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak93 (tak41 (sub1 x) y z)
		   (tak23 (sub1 y) z x)
		   (tak81 (sub1 z) x y)))))
(defun tak93 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak94 (tak78 (sub1 x) y z)
		   (tak34 (sub1 y) z x)
		   (tak98 (sub1 z) x y)))))
(defun tak94 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak95 (tak15 (sub1 x) y z)
		   (tak45 (sub1 y) z x)
		   (tak15 (sub1 z) x y)))))
(defun tak95 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak96 (tak52 (sub1 x) y z)
		   (tak56 (sub1 y) z x)
		   (tak32 (sub1 z) x y)))))
(defun tak96 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak97 (tak89 (sub1 x) y z)
		   (tak67 (sub1 y) z x)
		   (tak49 (sub1 z) x y)))))
(defun tak97 (x y z) 
   (cond ((not (lt y x)) z)
	 (t (tak98 (tak26 (sub1 x) y z)
		   (tak78 (sub1 y) z x)
		   (tak66 (sub1 z) x y)))))
(defun tak98 (x y z) 
   (cond ((not (lt y x)) z)
	(t (tak99 (tak63 (sub1 x) y z)
		  (tak89 (sub1 y) z x)
		  (tak83 (sub1 z) x y)))))
(defun tak99 (x y z) 
  (cond ((not (lt y x)) z)
	(t (takr (takr (sub1 x) y z)
		 (takr (sub1 y) z x)
		 (takr (sub1 z) x y)))))
