;;; $Id: create.ll,v 1.1 2006/12/09 11:22:07 jullien Exp $
;;;
;;; to fabricate makefile : prjname.make
;;;

(setq #:sys-package:colon 'rtproject)

;; analyzer command
(defvar :analyze-command
  (if (boundp ':analyze-command) :analyze-command "ll2lm"))
;; make command
(defvar :make-command
  (if (boundp ':make-command) :make-command "make"))
;; extension
(defvar :extension ())
;; to save date of files
(defvar :permute-lc ())
;; cdos config file extension
(defvar :config-ext ".lcf")

(defun :build-init (output prj)
  (let ((file (or output (:init-makefile prj)))
	(:verbose-makefile (gt #:crunch:verbose 0))
	)
    (#:crunch:save-file file)
    (with ((outchan (openo file))
	   (rmargin (add1 (slen (outbuf)))) )
	  (protect (:print-init-makefile file prj)
		   (close (outchan)))
    )))

#|===========================================================================
   Make modules & analyzer
---------------------------------------------------------------------------|#

(defun :print-init-makefile (makefile project)
   (let ((all-modules (:all-files project))
         (targetdir (get-system-directory project))
         (lodir (get-main-ll-object-directory project))
         (lmdir (get-main-ll-module-directory project))
         ;?!?! I prefer  deel path with STEP1-BIS
         ;(#:system:path (nconc1 (list-rt-directories project) ""))
	 lcd
         )

     ;; eventualy we play with save-extension
     (setq :extension (:module-extension project))

     
     ;; header...
     (print "# This makefile was generated by the ILOG Analyzer.")
     (print "# Version     : " #:crunch:version "         Date : " (date))
     (print "# SubVersion  : " #:crunch:subversion)
     (print "# It enables to build modules from Lisp source files for ")
     (print "# - project : " (:name project))
     (print "#")

     (when (gt #:crunch:verbose 1)
	   (let ((#:sys-package:itsoft (cons ':makefile:comment
					     #:sys-package:itsoft)))
	     (prin "# ")
	     (terpri)
	     (terpri)
	     (pprint project))
	   (terpri))
     
     (print "######")
     (print "# Directories")
     (print "######")
     (terpri)
     (:print-env "ROOTDIR" (or (namestring (:root-directory project))
			       (namestring #u"./")))
     (:print-env "CRUNCHDIR" (or (namestring (:crunch-directory project))
				 (namestring #u"./")))
     (:print-env "LLDIR" (namestring rt-lelisp-directory))
     (terpri)

     (print "######")
     (print "# Makefile's environment")
     (print "######")
     (terpri)
     (:print-env "SYSTEM" (string (system)))
     (:print-env "MAKE" (catenate :make-command " -f " (namestring makefile)))
     (:print-env "PROJECTNAME" (:name project))
     (:print-env "PROJECTFILE" (or (namestring (:project-file project))
				   (catenate "$(CRUNCHDIR)"
					     (:name project)
					     ".prj")))
     (:print-env "RM" (cond (#:system:dosp "del")
			    (#:system:vmsp "delete")
			    (t "rm -f")))
     (:print-env "CP" (cond (#:system:dosp "copy")
			    (#:system:vmsp "copy")
			    (t "cp")))
     (:print-env "MV" (cond (#:system:dosp "ren")
			    (#:system:vmsp "rename")
			    (t "mv")))
     (:print-env "TOUCH" (cond (#:system:dosp "echo")
			       (#:system:vmsp "write sys$output")
			       (t "touch")))
     (:print-env "ECHO" (cond (#:system:dosp "echo")
			      (#:system:vmsp "write sys$output")
			      (t "echo")))
     (terpri)
     
     (print "######")
     (print "# Analyzer's options")
     (print "######")
     (terpri)
     (:print-env "ANALYZER" :analyze-command)
     (:print-env "OUTPUT" "")
     (:print-env "FILEOPTION" (cond (#:system:dosp "-update ""$@""")
				    (#:system:vmsp "-update ""$@""")
				    (t "-update \|$@\|")) )
     (:print-env "USEROPTIONS" "")
     (:print-env "ANALYZEOPTIONS" "-load $(PROJECTFILE) -p $(PROJECTNAME) $(OUTPUT)")

     ;; now printing all modules .lo for that project
     (print "######")
     (print "# LL Objects involved")
     (print "######")
     (terpri)
     (prin "LLOBJS=")
     (:prinf (mapcar (lambda(x)(namestring (:make-module-filename x lmdir)))
		     all-modules))
     (terpri 2)

     ;; print module dependancy
     (print "######")
     (print "# Generic entries")
     (print "######")
     (terpri)
     (print "all : $(LLOBJS)")
     (terpri)
     (when #:system:unixp
     (print "scratch : init1 init2 update make")
     (terpri)
     (print "init1 : clean")
     (princn #\TAB)
     (print "$(MAKE) all FILEOPTION=""-r -defmodule \|\$$\$$MODNAME\| -o \|\$$@\|""")
     (princn #\TAB)(print "@$(TOUCH) init1")
     (terpri)
     (print "init2 : ")
     (princn #\TAB)
     (print "$(MAKE) all FILEOPTION=""-r -defmodule \|\$$\$$MODNAME\| -o \|\$$@\|""")
     (princn #\TAB)(print "@$(TOUCH) init2")
     (terpri)
     (print "update : ")
     (princn #\TAB)
     (print "$(MAKE) all FILEOPTION=""-r -update \|\$$@\|""")
     (princn #\TAB)(print "@$(TOUCH) update")
     (terpri)
     (print "make : " (namestring (:make-file project)))
     (terpri)
     (print (namestring (:make-file project)) " : $(LLOBJS)")
     (princn #\TAB)(print "$(ANALYZER) $(ANALYZEOPTIONS) -makefile $(USEROPTIONS)")
     (terpri)
     (print "cleanobj :")
     (princn #\TAB)(print "$(RM) $(LLOBJS)")
     (terpri)
     (print "cleanfiles :")
     (princn #\TAB)(print "$(RM) " (namestring (:ref-file project)))
     (princn #\TAB)(print "$(RM) " (namestring (:make-file project)))
     (terpri)
     (print "clean : cleanobj cleanfiles")
     (princn #\TAB)(print "@$(RM) init1 init2 update")
     (terpri 2)
     )
     (print "info :")
     (terpri)
     (print "work :")
     (terpri)
     (print ".PRECIOUS : $(LLOBJS)")
     (terpri)
     
     ;; 
     ;; ANALYZER dependencies
     ;; 
     (print "######")
     (print "# ANALYZER dependencies")
     (print "######")
     (terpri)
     (mapc (lambda (x)
	     ;(setq x (pathname-name (pathname x)))
	     (:print-analyzer-command x (:print-lm-dependencies x lmdir)))
	   all-modules)
     (terpri)
     ))

(defun :print-analyzer-command (mod (lm lc . ll))
  ;; mod = name of module [STRING]
  ;; lm = path of module(.lm) [PATHNAME]
  ;; lc = path of source module(.lc) if exists [PATHNAME]
  ;; ll = path of files(.ll) [LIST of PATHNAMES]
  (let ((fn (file-namestring lm))
	(m (namestring lm))
	(cf (catenate mod :config-ext))
	s c)

    (princn #\TAB)(:prinf `("@$(ECHO) ""+++++ ANALYZE : """ ,m))
    (terpri)

    (when (and :extension lc)
	  (setq c (namestring lc))
	  (cond
	   (:permute-lc
	    (setq s (namestring (merge-pathnames
				 (make-pathname ()()()()"sav"())
				 lm)))
	    (princn #\TAB) (:prinf `("@" "$(RM) -f" ,s))(terpri)
	    (princn #\TAB) (:prinf `("@" "if [ -f " ,m "]; then"
				     "$(MV)" ,m ,s ";fi"))
	    (terpri)
	    (princn #\TAB) (:prinf `("@" "$(MV)" ,c ,m))(terpri)
	    (princn #\TAB) (:prinf `("@" "$(CP)" ,m ,c))(terpri)
	    )
	   (t
	    (princn #\TAB) (:prinf `("@" "$(CP)" ,c ,m))(terpri)
	    )))

    (when (and #:system:dosp :config-ext)
	  (princn #\TAB)
	  (:prinf `("$(ECHO) -load "
		    ,(or (namestring (:project-file #:crunch:current-project))
			 (catenate
			  """"
			  (or (namestring
			       (:crunch-directory #:crunch:current-project))
			      (namestring #u"./"))
			  (:name #:crunch:current-project)
			  ".prj"
			  """"))
		    " > " ,cf))
	  (terpri)(princn #\TAB)
	  (:prinf `("$(ECHO) -p " ,(:name #:crunch:current-project)
		    " >> " ,cf))
	  (terpri)(princn #\TAB)
	  (:prinf `("$(ECHO) $(FILEOPTION) >> " ,cf))
	  (mapcar (lambda(f)
		    (terpri)(princn #\TAB)
		    (:prinf `("$(ECHO) " ,f " >> " ,cf)))
		  (or (cassq (concat mod)
			     (:analyzer-options
			      #:crunch:current-project))
		      (cassoc "all"
			      (:analyzer-options
			       #:crunch:current-project))))
	  (terpri))
    (princn #\TAB)
    (cond
     (#:system:dosp
      (:prinf `(
		"$(ANALYZER) -config " ,cf
		"$(USEROPTIONS)"
		))
      (terpri)(princn #\TAB)
      (:prinf `("$(RM) " ,cf))
      )
     (t
      (:prinf `(
		,(if :verbose-makefile "(" "@(")
		,(catenate "MODNAME=" mod "; ")
		"$(ANALYZER) $(FILEOPTION) $(ANALYZEOPTIONS)"
		,@(or (cassq (concat mod)
			     (:analyzer-options #:crunch:current-project))
		      (cassoc "all"
			      (:analyzer-options #:crunch:current-project)))
		"$(USEROPTIONS)"
		")"
		))
      ))
    (terpri)

    (if (and :extension lc)
        (cond
	 (:permute-lc
	  (princn #\TAB) (:prinf `("@" "$(MV)" ,m ,c))(terpri)
	  (princn #\TAB) (:prinf `("@" "if [ -f " ,s "]; then"
				   "$(MV)" ,s ,m ";fi"))
	  (terpri)
	  (:prinf `(,m "::" ,c))(terpri)
	  (princn #\TAB) (:prinf `("@" "$(CP)" ,c ,m ))(terpri)
	  )
	 (t
	  (princn #\TAB) (:prinf `("@" "$(CP)" ,m ,c))(terpri)
	  (princn #\TAB) (:prinf `("@" "$(TOUCH)" ,m))(terpri)
	  ))
      (princn #\TAB) (:prinf `("@" "$(TOUCH)" ,m))(terpri))

    (terpri))
  )

(defun :print-lm-dependencies(name lmdir)
  (let ((#:crunch:keep-old t)); don't write in .lm
    (let ((lm (:build-module name
			     (when lmdir
				   (combine-pathnames lmdir (pathname name)))
			     ()))
	  (ll (:build-files name ()()))
	  (lc (when :extension
		    (let ((#:system:mod-extension (catenate "." :extension)))
		      (probepathm name))) )
	  )
      (setq ll (mapcan (lambda(f)(when (probepathf f)(ncons f))) ll))

      (let ((plm (namestring lm))
	    (flm (catenate name #:system:mod-extension)) )
	(when (nequal plm flm)
	      (:prinf `(,flm ":" ,plm))
	      (terpri))
	(:prinf `(,plm ,(if (and :extension lc :permute-lc) "::" ":"))) )
      (if (gt #:crunch:dependancy 1)
	  (progn (when (and :extension lc)
		       ; if exists, .lc is considerate as source for .lm
		       ; so .lm depends of .lc
		       (:prinf (list (namestring lc))))
		 ; .lm depends of .ll
	         (:prinf (mapcar (lambda(f)(namestring (probepathf f))) ll))
		 (cond
		  ; if already exists,.lm depends of all imported modules
		  ((probepathm lm)
		   (:prinf (:list-import lm #:system:mod-extension)) )
; non non et non: on ne peux pas engendrer le .mki avec les dependances
; sans avoir les .lm: on ne peut pas faire dependre des .lc car
; les points d'entree de makefile sont les .lm; et on ne peut pas non
; plus remplacer bestialement .lc par .lm car les paths ne sont pas
; forcement les bons!
;		  ; else, imported modules are taking in .lc
;		  ((and :extension lc)
;		   (:prinf (mapcar (lambda(i)
;				     (set-pathname-type i
;							(substring #:system:mod-extension 1))
;				     (namestring i))
;				   (:list-import lc
;						 (catenate "." :extension)))) )
		  ; else , no module found
;silent mode because bootstrap
;		  (t
;		   (:warning 26 lm))
		  ))
	(when (gt #:crunch:dependancy 0)(:prinf (list "work")))
	(let ((#:sys-package:itsoft (cons ':makefile:comment
					  #:sys-package:itsoft)))
	  (terpri)
	  (:prinf (mapcar (lambda(f)(namestring (probepathf f))) ll))))
      (terpri)
      (mcons lm lc ll)
      )))

;;; return list of <mod>'s imported modules pathnames
(defun :list-import (mod ext)
  (let ((#:system:mod-extension ext))
    (mapcan (lambda(i)
	      (if (setq i (probepathm i))
		  (ncons (namestring i))
;silent mode because bootstrap
;		(:warning 26 i)()
		))
	    (getdefmodule (readdefmodule mod) 'import)) ))

;;; fabricate first instance of module mod
;;; with DEFMODULE & FILES fields
(defun :build-module (mod output files)
  (let ((out (if output
		 (pathname output)
	       (pathname mod))))
    (set-pathname-type out (substring #:system:mod-extension 1))
    (let ((files (:build-files mod out files))
	  lf)
      (unless (or #:crunch:keep-wrong output)
	      (setq lf files)
	      (while (null (setq output (probepathf (nextl lf)))))
	      (setq output (combine-pathnames (pathname output) out))
	      )
      (unless #:crunch:keep-old
	      (with ((outchan (openo output)))
		    (protect
		     (let ((#:system:print-for-read ()))
		       (print "defmodule " mod)
		       (print "files " files))
		     (close (outchan)))))
      ))
  output)

;;; calculate list of files names
(defun :build-files (name output files)
  (let (ofiles)
    (setq ofiles (:b-m name))
    (when files (setq ofiles (union ofiles files)))
    (or ofiles
	(error 'build-module "no file in module" name))))

;;; fabricate files name of module mod with DEFINE-RT-PROJECT spec.
(defun :b-m (mod)
  (let (n)
    (cond
     ; case of DEFINE-RT-PROJECT MODULES-FILES definition
     ((cassq (symbol () mod)
	     ({rtproject}:modules-files #:crunch:current-project)))
     ; case of .lc
     ((let ((#:system:mod-extension (if :extension
					(catenate "." :extension)
				      #:system:mod-extension)))
	(and (setq n (probepathm mod))
	     (getdefmodule (readdefmodule n) 'files))) )
     ; case of DEFINE-RT-PROJECT EXTENSIONS-LIST definition
     (({rtproject}:extensions-list #:crunch:current-project)
      (setq n (pathname mod))
      (mapcan (lambda(e)
		(set-pathname-type n e)
		(when (probepathf (setq e (file-namestring n)))
		      (ncons e)))
	      ({rtproject}:extensions-list #:crunch:current-project)))
     ; default case: file of <mod>.lm is <mod>.ll
     (t (set-pathname-type (setq n (pathname mod)) "ll")
	(ncons (file-namestring n))))))

;;;
;;; return all root-name of files with EXT extention or any extention,
;;; in project's directories but excluded modules.
;;;
(defun :all-files (prj . ext)
  (setq ext (or ext
		(:extensions-list prj)
		(list "ll")))
  (cond
   ;; all files found in :directories
   ((or (and (consp (:modules prj))
	     (member "all" (:modules prj)))
	(and (consp (:modules-lists prj))
	     (member "all" (:modules-lists prj))))
    (let (lf)
      (mapc (lambda(d)
	      (setq lf (:merge (:filenames d ext)
			       lf
			       (:name prj))))
	    (:directories prj))
      (setq lf (:simplify-list-of-strings (mapcar 'pathname-name lf)))
      (setq lf (:excl-mod lf prj))
      lf))
   ;; exhaustive list of modules
   ((:modules prj)
    (:short-list-name (:modules prj)))
   ;; lists of modules in each directories
   ((:modules-lists prj)
    (let ((ml (:modules-lists prj))
	  lf)
      (mapc (lambda(d)
	      (setq lf (:merge (tag empty (:read-modules-lists d ml))
			       lf
			       (:name prj))))
	    (:directories prj))
      (setq lf (:simplify-list-of-strings (mapcar 'pathname-name lf)))
      (setq lf (:excl-mod lf prj))
      lf))
   ;; oooups
   (t
    (error '-init "no file specified for project" (:name prj)))
   ))

;;; merge lists of files with verification of doublet
(defun :merge (l1 l2 prjname)
  (let ((l l1) x)
    (while l
      (when (member (setq x (nextl l)) l2)
	    (#:crunch:warning 9 prjname x)
	    (setq l1 (delete x l1))))
    (nconc l1 l2)))
    
;;; exlude excluded modules
(defun :excl-mod (l prj)
  (nset-difference l
		   (:short-list-name (:exclude-modules prj))
		   'equal))

;;; return all filenames  in DIR directory with EXT extention
(defun :filenames (dir ext)
  (mapcan (lambda(typ)
	    (with ((current-directory dir))
		  (expand-pathname
		     (make-pathname ()()()
				    "*" typ ()))) )
	  ext)
  )

;;; return list of PATHNAME-NAME without redundance
(defun :short-list-name (l)
  (:simplify-list-of-strings
   (mapcar (lambda(x) (pathname-name (pathname x))) l)))

;;; physicaly modify list to avoid redundance
(defun :simplify-list-of-strings (l)
  (when l
        (rplacd l (:simplify-list-of-strings (delete (car l)(cdr l))))
        l))

;;; return all files describe by LISTS files, in DIR directory
(defun :read-modules-lists (dir lists)
  (mapcan (lambda(x)(:read-one-modules-list dir x)) lists))

(defun :read-one-modules-list (dir f)
  (with ((current-directory dir))
	(let ((#:system:path '(""))
	      l)
	  (ifn (probefile f)
	       (progn (#:crunch:advise NOLST dir f) ())
	       (with ((inchan (#:crunch:openi f)))
		     (untilexit eof
				(newl l (pathname (read))))
		     )
	       (if l (nreverse l)(exit empty ()))
	       ))))


