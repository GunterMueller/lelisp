;;;
;;; STARTUP:  The Le-Lisp initialization file.
;;;
;;; $Source: /usr/cvs/lelisp/llib/startup.ll.in,v $
;;; $Date: 2017/10/07 13:54:52 $
;;; $Revision: 1.6 $
;;;
;;; ------------------------------------------------------------
;;; This file is part of Le-Lisp version 15, developped by INRIA
;;;
;;;
;;; (c) 1987-1993  Le-Lisp is a trademark of INRIA.
;;; ------------------------------------------------------------


;;; This file has to be loaded before any use of Le-Lisp in order to get
;;; the new definition of the toplevel loop.

(if (>= (version) 15.26)
    (catenate "Version: " (version))
    (error 'load 'erricf 'startup))

(progn				; a mute evaluation

  ;;; These two following functions have to be updated for any new version

  (defun subversion ()
    ;; returns the sub-version number.
    13)

  (defun herald ()
    ;; prints in the tty channel the name of the system
    ;; and the version number.
    (with ((outchan ()))
	  (print "; Le-Lisp (by INRIA) version 15.26  "
		 "(01/Jan/2020)  [" (system) "]"))
    ())

  (catenate "Subversion: " (subversion)) )



(progn				; another mute evaluation
  
  ;;
  ;; The global dynamic variables used internally
  ;;

  (defvar #:system:loaded-from-file     'startup)
  (defvar #:system:loaded-from-file     'startup)
  (defvar #:system:in-read-flag         #:system:in-read-flag)
  (defvar #:system:print-for-read       #:system:print-for-read)
  (defvar #:system:print-package-flag   #:system:print-package-flag)
  (defvar #:system:print-case-flag      #:system:print-case-flag)
  (defvar #:system:real-terminal-flag   #:system:real-terminal-flag)
  (defvar #:system:line-mode-flag       #:system:line-mode-flag)
  (defvar #:system:gensym-counter       #:system:gensym-counter)
  (defvar #:system:gensym-string        #:system:gensym-string)
  (defvar #:system:read-case-flag       #:system:read-case-flag)

  ;;
  ;; Can be changed for different configurations.
  ;;

  (defvar #:system:foreign-language t)  ; messages in english.
  (defvar #:system:print-with-abbrev-flag t)


  ;;
  ;; Dynamically compute the type of the system
  ;;

  (defvar #:system:unixp ())             ; =t for all UN*X    systems.
  (defvar #:system:winp  ())             ; =t for all Windows systems.
  (defvar #:system:vmsp  ())             ; =t for all VMS     systems.
  (defvar #:system:dosp  ())             ; =t for all DOS     systems.
  (defvar #:system:gellp ())             ; =t for all GELL    portages.
   
   
  #.(defvar gell			; list of GELL portages
      '(|Csun4| |Chp9700| |Calphaosf| |Calphavms| |Ciris4d| |C|))
      
  #.(defvar unix			; list of UN*X systems
      '(vaxunix vme pe32unix bell sps9 sm90 unigraph cetia
	micromega metheus apollo cadmus sun hp9300
	metaviseur ibmrt pyramid sequent gouldpn
	|tektronix 43xx| |C| dpx1000 sun4 solaris convex
	macaux decstation mips magnum sony sonyr3000 m88k
	linux aix386 ix386 sco386 solaris386 unixware386 x86macos svr4i386
        cygwin rs6000 hp9400 hp9700 hp11 iris4d irix5 cetia88k alphaosf
	|Csun4| |Chp9700| |Calphaosf| |Ciris4d| linuxsparc freebsd netbsd
	))

  #.(defvar vms				; list of VMS systems
      '(vaxvms alphavms |Calphavms|))

  #.(defvar dos				; list of DOS systems
      '(msdos os2 nt386 win32 win64 win95))

  #.(defvar win				; list of Windows systems
      '(win32 win64 win95))

  (selectq (system)

     (#.unix
	(defvar #:system:directory "/home/jullien/lelisp/")
	(defvar #:system:unixp t)
	(defvar #:system:vmsp  ())
	(defvar #:system:dosp  ())
	(defvar #:system:winp  ())
	"unix system")

     (#.vms
	(defvar #:system:directory "lelisp$disk:")
	(defvar #:system:unixp ())
	(defvar #:system:vmsp  t)
	(defvar #:system:dosp  ())
	(defvar #:system:winp  ())
	"vms system")

     (#.dos
	(defvar #:system:directory "c:/usr/ilog/lelisp/")
	(defvar #:system:unixp ())
	(defvar #:system:vmsp  ())
	(defvar #:system:dosp  t)
        (let ((dir (getenv "LELISP")))
             (when dir
                   (setq #:system:directory (catenate dir "/"))))
	(cond
	      ((memq (system) win)
	       (defvar #:system:winp t)
	      "windows system")
	      (t
	       (defvar #:system:winp ())
	      "dos system")))

     (t (defvar #:system:unixp ())
        (defvar #:system:vmsp  ())
        (defvar #:system:dosp  ())
        (defvar #:system:winp  ())
        "Not a unix, vms or dos system"
        ))
  ))

(progn				; another mute evaluation

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; I - setup of all the system dependant global variables
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; for systems able to perform a cload

  (defvar #:system:cloadp
    (and #:system:unixp
         (memq (system)
	       '(vaxunix sun sun4 sequent gouldpn sony sonyr3000
		 mips magnum iris4d decstation hp9300 hp9400 hp9700))))

  ;; for systems able to perform external calls in shared libraries

  (defvar #:system:getinlibp
     (memq (system)
        '(msdos nt386 win32 win64 win95
          vaxvms alphavms
          solaris solaris386 unixware386 linux x86macos freebsd netbsd
	  rs6000 alphaosf irix5)))

  ;; directory of the standard library

  (unless (boundp '#:system:llib-directory)
	  (defvar #:system:llib-directory
	    #.(selectq (system)
		       (#.unix   (catenate #:system:directory "llib/"))
		       (#.vms    "lelisp$disk:[LLIB]")
		       (#.dos    (catenate #:system:directory "llib\"))
		       (t        ""))))

  ;; directory of the user library.

  (unless (boundp '#:system:llub-directory)
	  (defvar #:system:llub-directory
	    #.(selectq (system)
		       (#.unix   (catenate #:system:directory "llub/"))
		       (#.vms    "lelisp$disk:[LLUB]")
		       (#.dos    (catenate #:system:directory "llub\"))
		       (t        ""))) )
  
  ;; directory of the test library.

  (unless (boundp '#:system:lltest-directory)
	  (defvar #:system:lltest-directory
	    #.(selectq (system)
		       (#.unix   (catenate #:system:directory "lltest/"))
		       (#.vms    "lelisp$disk:[LLTEST]")
		       (#.dos    (catenate #:system:directory "lltest\"))
                       (t        ""))) )

  ;; directory of the description module.

  (unless (boundp '#:system:llmod-directory)
	  (defvar #:system:llmod-directory
	    #.(selectq (system)
		       (#.unix   (catenate #:system:directory "llmod/"))
		       (#.vms    "lelisp$disk:[LLMOD]")
		       (#.dos    (catenate #:system:directory "llmod\"))
		       (t        ""))) )
  
  ;; directory of the object modules.

  (unless (boundp '#:system:llobj-directory)
	  (defvar #:system:llobj-directory
	    #.(selectq (system)
		       (#.unix   (catenate #:system:directory "llobj/"))
		       (#.vms    "lelisp$disk:[LLOBJ]")
		       (#.dos    (catenate #:system:directory "llobj\"))
		       (t        ""))) )

  ;; directory of the virtty descriptions.

  (unless (boundp '#:system:virtty-directory)
	  (defvar #:system:virtty-directory
	    #.(selectq (system)
		       (#.unix   (catenate #:system:directory "virtty/"))
		       (#.vms    "lelisp$disk:[VIRTTY]")
		       (#.dos    (catenate #:system:directory "virtty\"))
		       (t        ""))) )
  
  ;; directory of the virbitmap descriptions.

  (unless (boundp '#:system:virbitmap-directory)
	  (defvar #:system:virbitmap-directory
	    #.(selectq (system)
		       (#.unix   (catenate #:system:directory "virbitmap/"))
		       (#.vms    "lelisp$disk:[VIRBITMAP]")
		       (#.dos    (catenate #:system:directory "virbitmap\"))
		       (t        ""))) )

  ;; directory of the system library.

  (unless (boundp '#:system:system-directory)
	  (defvar #:system:system-directory
	    #.(selectq (system)
		       (#.unix   (catenate #:system:directory
					   (let ((name (car (memq (system)
								  '#.unix))))
					     (selectq name
						   (|tektronix 43xx| "tektro")
						   (t name)))
					   "/"))
		       (#.vms    (catenate "lelisp$disk:"
                                                    "[" (string (system)) "]"))
		       (#.dos    (catenate #:system:directory
					   (car (memq (system) '#.dos))
					   "\"))
		       (t        ""))) )
  
  ;; directory of the standard core-images.

  (unless (boundp '#:system:core-directory)
	  (defvar #:system:core-directory
	    #.(selectq (system)
		       (#.unix   (catenate #:system:directory
					   (let ((name (car (memq (system)
								  '#.unix))))
					     (selectq name
						 (|tektronix 43xx| "tektro")
						 (t name)))
					   "/llcore/"))
		       (#.vms    (catenate "lelisp$disk:[" (system) ".LLCORE]"))
		       (#.dos    (catenate #:system:directory
					   (car (memq (system) '#.dos))
					   "\llcore\"))
		       (t        ""))) )

  ;; optional directory for the GELL implementations.

  (when (memq (system) '#.gell)
        (setq #:system:gellp t)
        (unless (boundp '#:system:gell-directory)
	        (defvar #:system:gell-directory
	          #.(selectq (system)
			     (#.unix   (catenate #:system:directory "Celab/"))
			     ))))

  ;; The standard path list

  (defvar #:system:path `(""
			  ,#:system:system-directory
			  ,#:system:llib-directory
			  ,#:system:llub-directory
			  ,#:system:llmod-directory
			  ,@(unless (boundp '#:system:gell-directory)
				    (list #:system:llobj-directory))
			  ,#:system:lltest-directory
			  ,#:system:virtty-directory 
			  ,#:system:virbitmap-directory
			  ,@(when (boundp '#:system:gell-directory)
				  (list #:system:gell-directory))
			  ))

  ;; standard extension for the source Le-Lisp files.

  (defvar #:system:lelisp-extension
    #.(selectq (system)
	       (#.unix   ".ll")
	       (#.vms    ".ll")
	       (#.dos    ".ll")
	       (t        "")))

  ;; standard extension for the module description files.

  (defvar #:system:mod-extension
    #.(selectq (system)
	       (#.unix   ".lm")
	       (#.vms    ".lm")
	       (#.dos    ".lm")
	       (t        "")))

  ;; standard extension for the object module files.
  
  (defvar #:system:obj-extension
    #.(selectq (system)
	       (#.unix   ".lo")
	       (#.vms    ".lo")
	       (#.dos    ".lo")
	       (t        "")))

  ;; standard extension of the core-image files.

  (defvar #:system:core-extension
    #.(selectq (system)
	       (#.unix   ".core")
	       (#.vms    ".cor")
	       (#.dos    ".cor")
	       (t        "")))

  ;; data base of the "termcap" descriptions.

  (defvar #:system:termcap-file
    #.(selectq (system)
	       (#.unix   "/etc/termcap")
	       (#.vms    "lelisp$disk:[VIRTTY]termcap.db")
	       (#.dos    "\")
	       (t        "")))

  ;; directory of the "terminfo" data bases.

  (defvar #:system:terminfo-directory
    #.(selectq (system)
	       (#.unix   "/usr/lib/terminfo/")
	       (#.vms    "lelisp$disk[terminfo]")
	       (#.dos    "\")
	       (t        "")))

  ;; The editor's name called by ^F.

  (defvar #:system:editor
    #.(selectq (system)
	       (pe32unix "emin")
	       (bell     "vi")
	       (sps9     "redit")
	       ((sm90 micromega metheus apollo pe32unix)
		"emin")
	       (#.unix   "emacs")
	       (#.vms    "edit")
               (#.dos    "emacs")
	       (t        "")))

  ;; Variable for length of outbuf (use with rmargin if need)

  (defvar #:system:line-length-max 255)


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; II - characters setup for the #\ macro character
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (mapc
   (lambda (x y) (putprop x y '#:sharp:value))
   '(null bell bs  tab lf  return cr  esc sp  del rubout)
   '(#^@  #^G  #^H #^I #^J #^M    #^M #^[ #/  127 127))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; IV - standard macro character
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (dmc ^L ()
       ;; to load oa file with #:system:lelisp-extension extension.
       (list 'libloadfile (readstring) t))

  (dmc ^A ()
       ;; to load a module
       (list 'loadmodule (readstring)))
 
  (dmc ^E ()
       ;; to edit an expression
       (cond ((eq (peekcn) 13) 
	      ;; ^E followed by 'return'
              '(pepefile ()))
	     ((memq (peekcn) '(#/( #^P))
	      ;; an expression : starting with ( or ^P)
		    (list 'pepefile (kwote (read))))
	      (t ; a file name (symbol)
	       (list 'pepefile (kwote (concat (readstring)))))))

  (dmc ^F ()
       ;; to edit a file
       (let ((lu (readline)))
	 (ifn lu
	      (list 'comline #:system:editor)
	      (lets ((fct (implode lu))
		     (file (getprop fct '#:system:loaded-from-file))
		     ;; take care of "resetfn"
		     (type (or (car (getprop fct 'resetfn)) (typefn fct))))
		    (ifn (memq type '(expr fexpr macro dmacro))
			 (list 'pretty fct)
			 (if file
			     (list 'progn
				   (list 'comline
					 (catenate #:system:editor " " file))
				   (list 'load file t))
			   (setq file
				 (catenate 
				  (gensym) #:system:lelisp-extension))
			   (list 'progn
				 (list 'prettyf file fct)
				 (list 'comline
				       (catenate #:system:editor " " file))
				 (list 'load file t)
				 (list 'remprop
				       (kwote fct)
				       ''#:system:loaded-from-file)
				 (kwote fct))))))))

  (dmc ^P ()
       ;; to pretty print a function definition
       (cons 'pretty 
	     (implode (pname (catenate "(" (readstring) ")")))))
  
  (dmc |!| ()
       ;; to call a shell
       (let ((l (readstring)))
	 (comline (if (equal l "")
		      #.(selectq (system)
				 (#.unix "$SHELL")
				 (#.vms  "spawn")
				 (#.dos  (string (getenv "COMSPEC")))
				 (t "not implemented..."))
		    l))))


  (defsharp u ()
    ;; proto definition before the loading of the "path" module
    (list (read)))

  (defsharp p () 
    ;; proto definition before the loading of the "path" module
    (list (read)))


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; V - primitive loadfile
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defvar  #:system:redef-flag ()) ; to allow redefinitions

  (defun loadfile (file redef?)
    (let ((#:system:loaded-from-file file)
	  (#:system:redef-flag redef?)
	  (#:sys-package:colon #:sys-package:colon)
	  (#:system:in-read-flag ())
	  (inchan (inchan)) )
      (inchan (openi file))
      (protect
       (untilexit eof (eval (read)))
       (let ((in (inchan))) (when in (close in)))
       (inchan inchan) )
      file ))


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; VI - list of the files for the various environements
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defun all-the-files ()
    '(;;
      ;; 0 - mandatory modules (the order is VERY important)
      ;;
      (toplevel llpboot messages path files module defs genarith)
      ;;
      ;; 1 - minimal system
      ;;
      (virtty virbitmap)
      ;;
      ;; 2 - with an editor
      ;;
      (pepe)
      ;;
      ;; 3 - standard environement
      ;;
      (setf defstruct sort array callext trace date
       pretty debug ttywindow abbrev microceyx)
      ;;
      ;; 4 - the loader/assembler
      ;;
      (loader)
      ;;
      ;; 5 - the compiler
      ;;
      (cpmac llcp peephole)))


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; VII - build an environement
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; If this flag = T, an INITTY is performed after each
  ;; RESTORE-CORE done using SAVE-STD

  (defvar #:system:initty-after-restore-flag t)

  ;; If this flag = T, an INIBITMAP is performed after each
  ;; RESTORE-CORE done using SAVE-STD

  (defvar #:system:inibitmap-after-restore-flag t)

  (defun core-init-std (msg)
    ;; initialization sequence after a RESTORE-CORE.
    ;; "msg" is the greeting message.
    (when #:system:initty-after-restore-flag 
          (initty))
    (when #:system:inibitmap-after-restore-flag 
          (inibitmap))
    (herald)
    (if (featurep 'path)
	(let ((f (control-file-pathname 'lelisp)))
	  (when (probefile f)
		(loadfile f t)))
        #.(selectq (system)
		   (#.unix
		    '(let ((f (catenate (getenv "HOME") "/.lelisp")))
		       (when (probefile f)
			     (loadfile f t))))
		   (#.vms
		    '(let ((f "sys$login:startup.ll"))
		       (when (probefile f)
			     (loadfile  f t))))
		   (#.dos
		    '(let ((home (or (getenv "HOME")
				     (getenv "LELISP")
				     "")))
		       (let ((f (catenate home "\lelisp.ini")))
			 (when (probefile f)
			       (loadfile f t)))))
		   (t ()))
	)
    (print "; " msg " : " #:system:save-std-date)
    (sortl (list-features)))

  ;; This variable contains the values of GCINFO done
  ;; for each SAVE-STD

  (defvar #:system:save-std-gcinfo-list (list (cons 'initial (gcinfo t))))

  (defvar #:system:save-std-date ())

  (defun save-std (nom msg . user-functions)
    ;; Save a core-image named "nom". "msg" is the greeting string.
    ;; USER-FUNCTIONS are functions to be applied after each SAVE-CORE and
    ;; RESTORE-CORE. If no functions are given, CORE-INIT-STD is used.
    (print "Wait, I am saving : " msg)
    (unless (featurep 'date)
	    (if (featurep 'module)
		(loadmodule 'date)
	        (libload "date")))
    (setq #:system:save-std-date (date))
    (gc)
    (newl #:system:save-std-gcinfo-list (cons nom (gcinfo)))
    (setq #:system:real-terminal-flag t 
	  #:system:line-mode-flag ())
    (prompt |? |)
    (let* ((save-fn (or (car user-functions) 'core-init-std))
	   (restore-fn (or (cadr user-functions) save-fn 'core-init-std)))
      (if (save-core (catenate #:system:core-directory 
			       nom
			       #:system:core-extension))
	  (funcall save-fn msg)
	  (funcall restore-fn msg))))

  (defun load-std (nom . load-std)
    ;; load a standard environement. "nom" is the name
    ;; of the core-image. If nom=(), no core-image is produced.
    ;; "load-std" is a list of flags.
    (let (loaded-list)
      (let ((#:module:interpreted-list ()))
	(mapc (lambda (lf i)
		(when i
		      (mapc (lambda (x)
			      (print "Loading " (probepathf x))
			      (libloadfile x t)
			      (newl #:module:interpreted-list x))
			    (or (consp i) lf))))
	      (all-the-files)
	      (cons t load-std))
	(setq loaded-list #:module:interpreted-list))
      (setq #:module:interpreted-list loaded-list))
    ;; print how to compile this environment.
    (when (featurep 'compiler)
	  (if #:system:foreign-language
	      (print
	       " (llcp-std '<name>)  to compile standard environment")
	    (print
	     " (llcp-std '<nom>)  pour compiler l'environnement standard")))
    ;; Save a core-image if needed.
    (when nom
	  (save-std nom
		    (if #:system:foreign-language
			"Standard interpreted System"
		        "Syste`me standard interpre'te'")))
    'load-std
    )


  (defun llcp-std (nom . flags)
    ;; How to compile the standard environement and generate
    ;; a core-image if needed.
    (when (featurep 'compiler)
	  ;; try to save space before the COMPILE-ALL-IN-CORE
	  (mapc (lambda(f)
		  (and (eq (typefn f) 'expr)
		       (print "I compile " f)
		       (let ((#:ld:special-case-loader t))
			 (compiler f t (car flags) (cadr flags)))) )
		'(pprint #:symbol:prin #:compiler:peephole
		  #:compiler:macroexpand loader compiler
		  pepefile #:system:cached-getglobal) )
          (print "I compile everything else.")
          (compile-all-in-core (car flags) (cadr flags)))
    (mapc 'remob symb-to-rem)
    (when nom
	  (save-std nom
		    #- #:system:foreign-language "Syste`me standard compile'"
		    #+ #:system:foreign-language "Compiled standard system"
		    )))


  (defun rm-before-compile (compil interp)
    ;; remove functions which are in "interp" and not in "compil"
    (mapc (lambda (symb)
	    (unless (memq symb compil)
		    ;;(print "I remfn "
		    ;;       (typefn symb)
		    ;;       " "
		    ;;       symb)
		    (remprop symb '#:system:loaded-from-file)
		    (remfn symb)))
	  interp))


  (defun list-interp-func ()
    ;; When the loader is loaded, computes the list of interpreted functions
    ;; and in the imported modules.
    (let ((loader-imports (mapcar (lambda (mod)
				    (catenate #:system:llib-directory
					      mod
					      #:system:lelisp-extension))
				  #:module:interpreted-list))
	  res)
      ;; The loading of an interpreted loader leaves properties
      ;; of type: /xxxxxx/llib/lapxxx.ll and not: /xxxxxx/llib/loader.ll.
      (nsubst (getprop 'loader '#:system:loaded-from-file)
	      (catenate #:system:llib-directory 'loader
			#:system:lelisp-extension)
	      loader-imports)
      ;;
      (mapoblist (lambda (symb)
		   (and (memq (typefn symb) '(expr fexpr macro dmacro))
			(member (getprop symb '#:system:loaded-from-file)
				loader-imports)
			(newl res symb))))
      res))


  (defun list-compil-func ()
    (mapcan (lambda (symb)
	      (getdefmodule (readdefmodule symb) 'export))
	    #:module:compiled-list))

  (defvar symb-to-rem
    '(all-the-files load-std load-stm load-cpl load- loadmsg
      list-compil-func list-interp-func
      rm-before-compile symb-to-rem))

  (defun load- (compilo nom . load-stm)
    ;; "nom" is the name of a core-image (no core image will be produced
    ;; if "nom"=().
    ;; 'load-stm' is the flags list in this order:
    ;;            (min editor environment loader compilater)
    ;;
    ;; The module "module" has to be loaded.
    (let ((#:system:error-flag ()))
      (libload module t))     ; llib/module.ll
    (let ((load (cdddr load-stm))
	  (comp (cdr (cdddr load-stm)))
	  (list-interpreted-functions ())
	  (necessary (cdar (all-the-files))) ; TOPLEVEL is done after
	  )
      (when load-stm
	    (setq load (when (car load)      ;  LOADER is done specifically
			     (rplaca load ())
			     t))
	    (setq comp (when (car comp)      ; COMPILER is done specifically
			     (rplaca comp ())
			     t))
	    )
      (setq load-stm (cons comp load-stm))   ;
      ;; if the compiler has to be loaded
      (when comp
	    (let ((l (last (all-the-files))))
	      (rplaca (all-the-files)
		      (if (eq (car compilo) 'complice)
			  '(complice)
			  (car l)))
	      (rplaca l ()))
	    ;;     ... so the loader has to be loaded ...
	    (when (not load)
		  (printerror 'loader "I need the loader to compile!"
			      (cdr load-stm))
		  (setq load t)) )
      ;; if the compiler has to be loaded
      (ifn load (setq list-interpreted-functions (list-interp-func))
	   (let ((#:system:error-flag ()))
	     (loadmodule 'loader))   ; <system>/loader.lm --> llib/lapxxx.ll
	   (setq list-interpreted-functions (list-interp-func))
	   (if (consp load) (libload fxld t)
	     (let ((#:ld:special-case-loader t)) (loadmsg 'loader t))
	     ))
      ;; Loading of the mandatory files
      (mapc (lambda (m) (if (memq m #:module:compiled-list)
			    (loadmsg m "already loaded.")
			    (loadmsg m) ))
	    necessary)
      (let ((#:ld:special-case-loader t)) (loadmsg 'toplevel))
      ;; And the remaining modules
      (mapc (lambda (lf i)
	      (when (and i lf)
		    (mapc (lambda (m)
			    (if (or (memq m #:module:compiled-list)
				    (memq m #:module:interpreted-list) )
				(loadmsg m "already loaded.")
			        (loadmsg m) ))
			  (or (consp i) lf))))
	    (all-the-files)
	    load-stm)
      ;; remove all the unecessary functions
      (unless (and comp (consp load))
	      (rm-before-compile (list-compil-func)
				 list-interpreted-functions))
      (mapc 'remob symb-to-rem)
      (when (featurep 'compiler) (compile-all-in-core))
      (when nom (save-std nom (cdr compilo)))
      ))

  (defmacro load-stm (nom . load-stm)
    ;; load a standard modular environment
    `(load- '(llcp . ,(if #:system:foreign-language
			  "Standard modular system"
			  "Syste`me standard modulaire"))
	    ,nom ,@load-stm))

  (defmacro load-cpl (nom . load-cpl)
    ;; load complice and a modular environment.
    `(load- '(complice . ,(if #:system:foreign-language
			      "Complice modular System"
			      "Syste`me Complice modulaire"))
	    ,nom ,@load-cpl))


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; VIII - The mandatory modules
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (loadfile
   (catenate #:system:llib-directory 'files #:system:lelisp-extension)
   () )

  (loadfile
   (catenate #:system:llib-directory 'messages #:system:lelisp-extension)
   () )

  (loadfile
   (catenate #:system:llib-directory 'toplevel #:system:lelisp-extension)
   () )

  (loadfile
   (catenate #:system:llib-directory 'defs #:system:lelisp-extension)
   () )

  (loadfile
   (catenate #:system:llib-directory 'genarith #:system:lelisp-extension)
   () )


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; IX - The last functions
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defmacro loadmsg (name . flg)
    `(progn
       (prin "Loading " (probepathm ,name) " ... ")(flush)
       (if (stringp ,(car flg))
	   (prin ,(car flg))
	   (loadmodule ,name ,@flg)
	   (prin "done."))
       (terpri)
       ))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; X - The autoload functions
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; 0 - standard functions

  (libautoload virtty initty)
  (libautoload topwin topwindow)

  ;; 1 - utilities

  (libautoload module loadmodule readdefmodule)
  (libautoload defstruct defstruct)
  (libautoload array makearray aref aset)
  (libautoload sort sort sortl sortn sortp)
  (libautoload callext defextern cload defextern-cache
	       load-shared-lib unload-shared-lib loaded-shared-libs
	       #:system:cached-getglobal)
  (libautoload trace trace untrace step)
  (libautoload debug debug)
  (libautoload schedule parallel parallelvalues tryinparallel)
  (libautoload pretty pretty pprint prettyf)
  (libautoload format format prinf)
 
  ;; 2 - editors

  (libautoload minimore more morend)
  (libautoload edlin edlin edlinend)
  (libautoload pepe pepe pepefile)
 
  ;; 3 - demos

  (libautoload hanoi hanoi)
  (libautoload whanoi whanoi)
  (libautoload vdt vdt)


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; XI - The real end of startup
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defvar #:system:loaded-from-file ())
  (remob 'unix)
  (remob 'vms)
  (remob 'dos)
  (remob 'win)
  (remob 'gell)
  (rmargin 78)

  (print " (load-std sav min pepe env ld llcp)  to load standard environment,")
  (print " (load-stm sav min pepe env ld llcp)  to load modular  environment,")
  (print " (load-cpl sav min meme env ld cmpl)  to load complice environment.")

  (input ())

  (probepathf 'startup)

)  ; of the mute PROGN


