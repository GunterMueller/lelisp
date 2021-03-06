; Le-Lisp version 15.26: compilation of virtual terminal: xterm-color

(setq #:sys-package:tty '#:tty:xterm-color)

(defvar #:tty:xterm-color:xmax 79)
(defvar #:tty:xmax 79) ;  v15 compatibility

(defvar #:tty:xterm-color:ymax 23)
(defvar #:tty:ymax 23) ;  v15 compatibility

(defun #:tty:xterm-color:tycursor (col line)
    (tyo 27 91)
    (tyod (add1 line) 0)
    (tyo 59)
    (tyod (add1 col) 0)
    (tyo 72))

(defun #:tty:xterm-color:tybeep ()
    (tyo 27 91 63 53 104 27 91 63 53 108))

(defun #:tty:xterm-color:tycls ()
    (tyo 27 91 72 27 91 50 74))

(defun #:tty:xterm-color:tycleol ()
    (tyo 27 91 75))

(defun #:tty:xterm-color:tycleos ()
    (tyo 27 91 74))

(defun #:tty:xterm-color:tydelch ()
    (tyo 27 91 80))

(defun #:tty:xterm-color:tyinsln ()
    (tyo 27 91 76))

(defun #:tty:xterm-color:tydelln ()
    (tyo 27 91 77))

(defun #:tty:xterm-color:tyattrib (x)
    (if x (tyo 27 91 55 109) (tyo 27 91 50 55 109)))

(defvar #:tty:xterm-color:tyattrib ())
(defvar #:tty:tyattrib ()) ;  v15 compatibility

(defun #:tty:xterm-color:tyattrib (x)
    (if x (tyo 27 91 52 109) (tyo 27 91 50 52 109)))

(defvar #:tty:xterm-color:tyattrib ())
(defvar #:tty:tyattrib ()) ;  v15 compatibility

(defun #:tty:xterm-color:tyinsch (arg)
    (tyo 27 91 52 104 arg 27 91 52 108))

(defun #:tty:xterm-color:typrologue ()
    (tyo 27 55 27 91 114 27 91 109 27 91 63 55 104 27 91 63 49 59 51 59 52 59 
        54 108 27 91 52 108 27 56 27 62)
    (#:tty:xterm-color:tycls))

(defun #:tty:xterm-color:tyepilogue ()
    (tycursor 0 (1- #:tty:xterm-color:ymax)))

(defun #:tty:xterm-color:tyshowcursor (x)
    (if x (tyo 27 91 63 50 53 104) (tyo 27 91 63 50 53 108)))

(defvar #:tty:xterm-color:tyshowcursor t)
(defvar #:tty:tyshowcursor t) ;  v15 compatibility
