
;;.EnTete "Le_Lisp V15" "CPFNT.LL" "Deuxie`me passe du compilateur"
;;.sp 4
;;.SuperTitre "Le Compilateur Le_Lisp"
;;.Titre "Les fonctions ouvertes"
;;.Auteur "Bernard Serpette"

;;.Section "CPFNT.LL"
;;.SSection "Contenu"
;;     Contient toutes les fonctions directement compilables.

;;.SSection "Les variables globales"
; le package du compilateur
(defvar #:sys-package:colon 'complice)

;;.SSection " Les fonctions que l'on connait bien."
(de :cpfnt (fnt larg)
   (or (:cpfnt-open fnt larg)
      (selectq fnt
         (progn    (:progn larg))
         (if       (:cpfnt:if larg))
         (setq     (:cpfnt:setq larg))
         (quote    (if (car larg) `',.larg 'nil))
         ((lambda flambda) (:cpfnt:funarg larg))
         (selectq  (:cpfnt:selectq larg))
         (while    (:cpfnt:while larg))
         (until    (:cpfnt:until larg))
         (repeat   (ifn larg ''t (:cpfnt:repeat larg)))
         (or       (:comp-or-and larg 'bfnil 'nil))
         (and      (:comp-or-and larg 'btnil ''t))
         (prog1    (ifn larg 'nil (:prog1-not-empty (car larg) (cdr larg))))
         (arg      (:cpfnt:arg larg))
         (tag      (:cpfnt:tag larg))
         (evtag    (:cpfnt:evtag larg))
         (exit     (:cpfnt:exit larg))
         (evexit   (:cpfnt:evexit larg))
         (protect  (:cpfnt:protect larg))
         (lock     (:cpfnt:lock larg))
         (block    (:cpfnt:block larg))
         (return-from (:cpfnt:return (car larg) (cdr larg)))
         (schedule (:cpfnt:schedule (car larg) (cdr larg)))
         (with-interrupts (:cpfnt:with-interrupts larg))
         (without-interrupts (:cpfnt:without-interrupts larg))
         (tagbody  (:cpfnt:tagbody larg))
         (go       (:cpfnt:go (car larg)))
         (identity (:with-no-tail (setq larg (:exp (car larg))))
                   (:code (list 'jcall 'identity))
                   larg )
         (letv     (:cpfnt:letv larg))
         (declare  (mapc ':cpfnt:declare1 larg) fnt)
         (precompile (:cpfnt:precomp larg))
         (not      (:cpfnt:not larg))
         (deset    (:cpfnt:deset larg))
         (t ()) )))

(de :cpfnt-open (fnt larg)
   (when #:compiler:open-p
      (selectq fnt
         (car         (:op-mget     'car   (car larg)))
         (cdr         (:op-mget     'cdr   (car larg)))
         (rplaca      (:op-mset     'car   (car larg) (cadr larg) t))
         (rplacd      (:op-mset     'cdr   (car larg) (cadr larg) t))
         (symeval     (:op-mget     'cval  (car larg)))
         (set         (:op-mset     'cval  (car larg) (cadr larg) ()))
         (plist       (:op-mget-set 'plist (car larg) (cdr larg) ()))
         (objval      (:op-mget-set 'oval  (car larg) (cdr larg) ()))
         (packagecell (:op-mget-set 'pkgc  (car larg) (cdr larg) ()))
         (typestring  (:op-mget-set 'cdr   (car larg) (cdr larg) ()))
         (typevector  (:op-mget-set 'cdr   (car larg) (cdr larg) ()))
         ((vlength slen)
                   (:with-no-tail (setq larg (:read-op (:exp (car larg)))))
                   (when :return?
                      (:code `(hgsize ,larg ,:return?))
                      (:write-op () :return?))
                   (or :return? t) )
         (comment  ''comment)
         (vref     (:mcop2 (car larg) (cadr larg) 'hpxmov))
         (sref     (:mcop2 (car larg) (cadr larg) 'hbxmov))
         (vset     (:mcop3 (nextl larg) (nextl larg) (car larg) 'hpmovx))
         (sset     (:mcop3 (nextl larg) (nextl larg) (car larg) 'hbmovx))
         (add1     (:mcopar (car larg) ''1 'plus))
         (sub1     (:mcopar (car larg) ''1 'diff))
         (add      (:mcopar (car larg) (cadr larg) 'plus))
         (sub      (:mcopar (car larg) (cadr larg) 'diff))
         (mul      (:mcopar (car larg) (cadr larg) 'times))
         (div      (:mcopar (car larg) (cadr larg) 'quo))
         (rem      (:mcopar (car larg) (cadr larg) 'rem))
         (fadd     (:mcopar (car larg) (cadr larg) 'fplus))
         (fsub     (:mcopar (car larg) (cadr larg) 'fdiff))
         (fmul     (:mcopar (car larg) (cadr larg) 'ftimes))
         (fdiv     (:mcopar (car larg) (cadr larg) 'fquo))
         (logand   (:mcopar (car larg) (cadr larg) 'land))
         (logor    (:mcopar (car larg) (cadr larg) 'lor))
         (logxor   (:mcopar (car larg) (cadr larg) 'lxor))
         (logshift (:mcopar (car larg) (cadr larg) 'lshift))
 )))

;;.SSection "Les fonctions ge'ne'rant des ope'randes"
;;.SSSection ":OP-MGET  -  :OP-MGET-SET  -  :OP-MSET"
(de :op-mget (cop l)
   (:with-no-tail (setq l (:exp l)))
   (if :return? (:make-op cop l) t) )

(de :op-mset (cop l nl flag)
   (:with-no-tail-and-return (:alloc-reg () ())
      (setq l (:protect-op (:exp l)))
      (setq :return? (:alloc-reg l ()) nl (:exp nl)) )
   (if (:protected-op? l)
      (unless (:reg? l) (setq l (:mov l (:alloc-reg nl ()))))
      (when (and (consp nl) (fixp (car nl)))
         (setq nl (:read-op (cons (car nl) (cdr nl)))) )
      (setq l (:pop2 (:alloc-reg nl ()) nl)) )
   (:mov nl (:make-op cop l))
   (if :return? (if flag l nl) t) )

(de :op-mget-set (cop l set? flag)
   (ifn set?
      (:op-mget cop l)
      (:op-mset cop l (car set?) flag) ))

;;.SSection "Les fonctions ge'ne'rant un code ope'ration"
(defmacro :peephole-bug ()
   '(:code '(eval ())) )

(de :mcop2 (x y cop)
   (:with-no-tail-and-return (or :return? (:alloc-reg () ()))
      (setq x (:protect-op (:exp x)))
      (setq :return? (:alloc-reg x ()) y (:exp y)) )
   (when (and (consp y) (fixp (car y)))
      (setq y (:read-op (cons (car y) (cdr y)))) )
   (unless (:protected-op? x) (setq x (:pop2 (:alloc-reg y ()) y)))
   (ifn :return? t
      (:code `(,cop ,(:read-op x) ,(:read-op y) ,:return?))
      (:write-op () :return?)
      :return? ))

(de :mcopar (x y cop)
   (:with-no-tail-and-return (or :return? (:alloc-reg () ()))
      (setq x (:protect-op (:exp x)))
      (setq :return? (:alloc-reg x ()) y (:exp y)) )
   (when (and (consp y) (fixp (car y)))
      (setq y (:read-op (cons (car y) (cdr y)))) )
   (unless (:protected-op? x) (setq x (:pop2 (:alloc-reg y ()) y)))
   (ifn :return? t
      (:write-op () :return?)
; (or :return? (:alloc-reg ..))
      (unless (:reg? x) (setq x (:mov x (:alloc-reg y ()))))
      (:write-op () x)
      (:code `(,cop ,(:read-op y) ,(:read-op x)))
      x ))

(de :mcop3 (x y z cop)
   (:with-no-tail-and-return (:alloc-reg () ())
      (setq x (:protect-op (:exp x)))
      (setq :return? (:alloc-reg x ()) y (:protect-op (:exp y)))
      (setq :return? (:alloc-reg x y) z (:exp z)) )
   (when (and (consp y) (fixp (car y)))
      (setq y (:read-op (cons (car y) (cdr y)))) )
   (when (and (consp z) (fixp (car z)))
      (setq z (:read-op (cons (car z) (cdr z)))) )
   (unless (:protected-op? y) (setq y (:pop2 (:alloc-reg x z) z)))
   (unless (:protected-op? x) (setq x (:pop3 (:alloc-reg y z) y z)))
   (:code `(,cop ,(:read-op z) ,(:read-op x) ,(:read-op y)))
   z )

; (defcomp vlength ((x))
;    (:with-no-tail (setq x (:exp x)))
;    (:code `(hgsize ,x ,:return?))
;    :return? ))

;;.SSSection ":PROG1-NOT-EMPTY"
(de :prog1-not-empty (op corps)
   (:with-no-tail (setq op (:protect-op (:exp op))))
   (:with-no-tail-and-return () (while corps (:exp (nextl corps))))
   (:unprotect-op op (or :return? (:alloc-reg () ()))) )

;;.SSection "Les fonctions manipulant l'environnement"
;;.SSSection ":LETV"
(de :cpfnt:letv ((lvar lval . corps))
   (ifn (and (consp lvar) (eq (car lvar) 'quote))
      (:set-error)
      (:exp `((lambda (,(cadr lvar)) ,@corps) ,lval)) ))

;;.SSection "Les fonctions de contro^le de base"
;;.SSSection "IF"
(de :cpfnt:if ((test oui . non))
   (let ( (et1 (:genlab)) (et2 (:genlab)) (lsr) (lr) )
      (:pred test () et1)
      (setq lsr (:get-all-reg))
      (setq oui (:exp oui))
      (when :return? (:mov oui :return?))
      (unless :tail? (setq lr (:get-all-reg)))
      (when (or :tail? :return? non) (:code-last `(bra ,et2)))
      (:code et1) (:set-all-reg lsr) (when :tail? (setq :tail? t))
      (setq non (:progn non))
      (when :return? (:mov non :return?))
      (unless :tail? (:adjust-reg lr))
      (:code-last et2)
      (or :return? t) ))

;;.SSSection ":COMP-OR-AND"
(de :comp-or-and (l cop nret)
   (ifn l
      (when :return? nret)
      (let ( (etiq (:genlab)) (lr ()) (ret) )
         (setq nret :return?)
         (:with-no-tail-and-return (or (:reg? nret) (:alloc-reg () ()))
            (while (consp (cdr l))
               (setq ret (:read-op (:exp (nextl l))))
               (when nret (setq ret (:mov ret :return?)))
               (:code `(,cop ,ret ,etiq))
               (if lr (:adjust-saved-reg lr) (setq lr (:get-all-reg))) )
            (setq nret :return?) )
         (setq ret (:exp (car l)))
         (when :return? (setq ret (:mov ret nret)))
         (when lr (:adjust-saved-reg lr) (:adjust-reg lr))
         (:code etiq)
         (when :tail? (setq :tail? t))
         ret )))

;;.SSSection "SELECTQ"
(de :cpfnt:selectq ((a . l))
   (let ( (lr ()) (lsr) (etq) (pat) (fin (:genlab)) )
      (:with-no-tail-and-return 'a1 (setq a (:mov (:exp a) 'a1)))
      (while (consp l)
         (ifn (car l)
            (setq l (cdr l))
            (setq etq (:genlab))
            (cond
               ((atom (car l))
                  (:error 9 (car l)) )
               ((eq (setq pat (caar l)) 't))
               ((or (symbolp pat) (fixp pat)) (:code `(cabne a1 ',pat ,etq)))
               ((and (consp pat)
                     (every (lambda (m) (or (symbolp m) (fixp m))) pat) )
                  (:memq-p 'a1 pat () etq) )
               (t (:push 'a1)
                  (:mov `',pat 'a2)
                  (:code `(jcall ,(if (atom pat) 'equal 'member)))
                  (:clear-all-reg)
                  (:mov 'a1 'a2)
                  (:pop 'a1)
                  (:code `(btnil a2 ,etq)) ))
            (if lsr (:adjust-saved-reg lsr) (setq lsr (:get-all-reg)))
            (setq :x (:progn (cdar l)))
            (when :return? (:mov :x :return?))
            (unless :tail?
               (if lr (:adjust-saved-reg lr) (setq lr (:get-all-reg))) )
            (if (eq pat 't)
               (progn (:code-last fin) (setq l 'done))
               (setq l (cdr l))
               (:code-last `(bra ,fin)) (:code etq)
               (:set-all-reg lsr)
               (when :tail? (setq :tail? t)) )))
      (:adjust-reg lr)
      (unless l
         (when :return? (:mov 'nil :return?))
         (:code-last fin) )
      (or :return? t) ))

;;.SSSection "WHILE"
(de :cpfnt:while ((test . corps))
   (:clear-all-reg)
   (let ( (et1 (:genlab)) (et2 (:genlab)) (lcr) )
      (:with-no-tail-and-return (:alloc-reg () ())
         (:code et1)
         (:pred test () et2)
         (setq :return? ())
         (setq lcr (:get-all-reg))
         (while corps (:exp (nextl corps))) )
      (:code `(bra ,et1))
      (:code et2)
      (mapc ':set-reg lcr '(a1 a2 a3 a4))
      (if :return? 'nil t) ))

;;.SSSection "UNTIL"
(de :cpfnt:until ((test . corps))
   (:clear-all-reg)
   (let ( (et1 (:genlab)) (et2 (:genlab)) (lcr) (ret :return?) )
      (:with-no-tail-and-return (:alloc-reg () ())
         (:code et1)
         (if ret
            (:code `(bfnil ,(setq ret (:read-op (:exp test))) ,et2))
            (:pred test t et2) )
         (setq lcr (:get-all-reg) :return? ())
         (:progn corps) )
      (:code `(bra ,et1))
      (:code et2)
      (mapc ':set-reg lcr '(a1 a2 a3 a4))
      (if :return?  ret t) ))

;;.SSSection "REPEAT"
(de :cpfnt:repeat ((n . corps))
   (let ( (et1 (:genlab)) (et2 (:genlab)) (op) (lr) )
      (:with-no-tail-and-return (:alloc-reg () ())
         (setq op (:exp n))
         (unless (:reg? op) (setq op (:mov op (:alloc-reg () ()))))
         (setq lr (:get-all-reg))
         (:code `(bra ,et2))
         (:code et1)
         (:push op)
         (:clear-all-reg)
         (:progn corps)
         (:pop op)
         (:code et2)
         (:code `(sobgez ,op ,et1)) )
      (:adjust-reg lr)      
      (if :return? ''t t) ))

;;.SSSection "ARG"
(defvar :lhack-for-arg ())
(de :cpfnt:arg (n)
   (when :return?
      (let ( (ind (:read-op (:get-env '&nobind))) (op) )
         (ifn n
            ind
            (setq op (:read-op (:exp (car n))))
            (when (eq op 'a4)
               (:mov 'a4 (setq op (:alloc-reg 'a4 ()))) )
            (:mov ind 'a4)
            (:write-op () 'a4)
            (if (and (consp op) (eq (car op) 'quote) (fixp (cadr op)))
               (progn
                  (newl :lhack-for-arg
                     (list `',(- (car ind) (cadr op)) (car ind) ind) )
                  (:code `(plus ,(caar :lhack-for-arg) a4)) )
               (:code `(plus ',(car ind) a4))
               (:code `(diff ,op a4)) )
            (:code `(xspmov a4 ,:return?))
            :return? ))))

(defun :hack-for-arg ()
   (mapc
      (lambda ((qfix oind ind))
         (rplaca (cdr qfix) (add (sub (car ind) oind) (cadr qfix))) )
      :lhack-for-arg )
   (setq :lhack-for-arg ()) )

;;.SSection "Les fonctions de contro^le non locales"
;;.SSSection "TAG  -  EVTAG"
(de :*tag (tag corps)
   (let ( (et1 (:genlab)) )
      (:push `(|@| ,et1))
      (:push tag) (:push-top-block 'tag)
;     (:close-env)
      (setq tag (if (and (consp tag) (eq (car tag) 'quote)) (cadr tag) t))
      (newl :lframe `(tag ,tag ,:v-stack ,et1))
      (:with-no-tail-and-return 'a1 (setq corps (:progn corps)))
      (when :return? (:mov corps 'a1))
      (:code '(mov (& 1) dlink)) (:adjstk 4)
      (nextl :lframe)
      (:code et1)
      (:peephole-bug)
;     (:reset-env :env () ())
      (:clear-all-reg)
      'a1 ))

(de :cpfnt:tag ((tag . corps))
   (:*tag `',tag corps) )

(de :cpfnt:evtag ((tag . corps))
   (:push-value)
   (:with-no-tail-and-return (:alloc-reg () ())
      (setq tag (:exp tag)) )
   (:pop-value)
   (:*tag tag corps) )

;;.SSSection "EXIT  -  EVEXIT"
; Pourquoi Je'ro^me bouzille-t-il les registres apre's l'exit????
(de :cpfnt:exit ((tag . corps))
   (:with-no-tail-and-return 'a1 (:mov (:progn corps) 'a1))
   (:mov `',tag 'a2)
   (:code '(jmp #:llcp:exit))
   (or :return? t) )

(de :cpfnt:evexit ((tag . corps))
   (:with-no-tail-and-return 'a2
      (setq tag (:protect-op (:exp tag)))
      (setq :return? 'a1)
      (:mov (:progn corps) 'a1) )
   (:mov (:unprotect-op tag 'a2) 'a2)
   (:code '(jmp #:llcp:exit))
   (or :return? t) )

;;.SSSection "PROTECT"
(de :cpfnt:protect ((prot . corps))
   (let ( (et1 (:genlab)) (et2 (:genlab)) )
      (:push `(|@| ,et1)) (:push-top-block 'prot)
      (:with-no-tail-and-return 'a1 (setq prot (:exp prot)))
      (unless (:reg? prot) (setq prot (:mov prot (:alloc-reg () ()))))
      (:code '(mov (& 1) dlink)) (:adjstk 3)
      (:push prot)
      (:mov `(|@| ,et2) 'a3)
      (:code et1)
      (:clear-all-reg)
      (:protect-op 'a3) (:protect-op 'a2)
      (:with-no-tail-and-return () (while corps (:exp (nextl corps))))
      (:unprotect-op 'a2 'a2) (:unprotect-op 'a3 'a3)
      (:pop 'a1)
      (:code '(bri a3))
      (:code et2)
      (:peephole-bug)
      'a1 ))

;;.SSSection "LOCK"
(de :cpfnt:lock ((f . corps))
   (let ( (protlab (:genlab)) (contlab (:genlab)) rep direct-f )
      ;; Is it a direct function?
      (cond
         ((not (consp f)) (setq direct-f ()))
         ((eq (car f) 'lambda) (setq direct-f f))
         ((eq (car f) 'quote) (setq direct-f (cadr f)))
         (t (setq direct-f ())) )
      ;; Save the result of f if it is not a direct function.
      (unless direct-f (:with-no-tail-and-return 'a1 (:push (:exp f))))
      ;; Make a block "protect"
      (:push `(|@| ,protlab))
      (:push-top-block 'prot)
      ;; Compile the body.
      (:with-no-tail-and-return 'a1 (:mov (:progn corps) 'a1))
      ;; Set register and stack as the handler specification.
      (:code '(mov (& 1) dlink))
      (:adjstk 3)
      (:push 'a1)
      (:mov 'nil 'a2)
      (:mov `(|@| ,contlab) 'a3)
   (:code protlab)
      ;; Forget the contents of registers.
      (:clear-all-reg)
      ;; Save registers (even if I don't need!).
      (:push 'a2)
      (:push 'a3)
      (let ( (et (:genlab)) )
         ;; When return-from occur we have a fixnum in a2...
         (:code `(bffix a2 ,et))
         (:mov 'nil 'a2)
         (:code et) )
      (if direct-f
         ;; We can open the code.
         (let ( (a1 (gensym)) (a2 (gensym)) (et (:genlab)) )
            (:mov 'a2 'a1)
            (:mov '(& 2) 'a2)
            (:set-reg a1 'a1) (:set-reg a2 'a2)
            (:with-no-tail (setq rep (:exp `(,direct-f ,a1 ,a2)))) )
         ;; We have to make an funcall
         (let ( (et (:genlab)) )
            (:push `(|@| ,et))
            (:push '(& 4))
            (:push 'a2)
            (:push '(& 5))
            (:mov ''3 'a4)
            (:code '(jmp funcall))
            (:code et)
            (:pop-value 4)
            (setq rep 'a1) ))
      ;; If we have a dandling exit we break it.
      (:code `(btsymb (& 1) ,contlab))
      ;; Go to the saved a3.
      (:code '(mov (& 2) a1))
      (:code '(mov (& 1) a2))
      (:code '(bri (& 0)))
  (:code contlab)
      ;; Clean the stack.
      (:adjstk (if direct-f 3 4))
      rep ))

#|
(de :cpfnt:lock ((f . corps))
   (let ( (et1 (:genlab)) (et2 (:genlab)) (et3 ()) )
      (unless (and (consp f) (memq (car f) '(lambda quote)))
         (:push `(|@| ,(setq et3 (:genlab))))
         (:push (:exp f)) )
      (:push `(|@| ,et1))
      (:push-top-block 'prot)
      (:with-no-tail-and-return 'a1 (:mov (:progn corps) 'a1))
      (:code '(mov (& 1) dlink)) (:adjstk 3)
      (:push 'a1)  (:mov 'nil 'a2) (:code et1)
      (:clear-all-reg)
      (ifn et3
         (let ( (a1 (gensym)) (a2 (gensym)) )
            (:mov 'a2 'a1) (:pop 'a2)
            (:set-reg a1 'a1) (:set-reg a2 'a2)
            (when (eq (car f) 'quote) (setq f (cadr f)))
            (:exp `(,f ,a1 ,a2)) )
         (:pop 'a1) (:code '(jcall ncons)) (:code '(jcall xcons))
         (:push 'a1) (:mov ''2 'a4) (:code '(jmp apply))
         (:pop-value 3) (:code et3)
         (:peephole-bug)
         'a1 )))
|#

;;.SSSection "BLOCK"
; (de :cpfnt:block ((targ . corps))
;    (:close-env)
;    (let ( (ad (:genlab)) )
;       (newl :lframe `(block ,targ ,ad ,:v-stack))
;       (:mov (:progn corps) 'a1)
;       (nextl :lframe)
;       (:code ad)
;       (:reset-env :env () ())
;       'a1 ))

(de :cpfnt:block ((targ . corps))
   (let ( (ad (:genlab)) )
      (:push `(|@| ,ad))
      (:mov `',targ 'a1)
      (:code '(jcall #:llcp:block))
      (:push-value 3)
      (:clear-all-reg)
      (:with-no-tail-and-return 'a1 (:mov (:progn corps) 'a1))
      (:clear-all-reg)
      (:code '(return))
      (:code ad)
      (:pop-value 4)
      (:peephole-bug)
      'a1 ))

;;.SSSection "RETURN   -   RETURN-FROM"
; (de :cpfnt:return (targ corps)
;    (:with-no-tail-and-return 'a1 (:mov (:progn corps) 'a1))
;    (:cpfnt:return-aux targ :lframe)
;    (or :return? 'a1) )

; (de :cpfnt:return-aux (targ l)
;    (cond
;       ((null l) (:error 0 targ))
;       ((or (neq (caar l) 'block) (neq (cadar l) targ))
;          (:cpfnt:return-aux targ (cdr l)) )
;       (t (let ( ((ad stk) (cddar l)) (op) )
;             (newl :l-readjust (setq op (:read-op (:index-vstack stk))))
;             (:code `(adjstk ,op))
;             (:code `(bra ,ad)) ))))

(de :cpfnt:return (targ corps)
   (:with-no-tail-and-return 'a1 (:mov (:progn corps) 'a1))
   (:mov `',targ 'a2)
   (:code '(jmp #:llcp:retfrom))
   'a1 )

;;.SSSection "SCHEDULE  - WITH-INTERRUPTS  -  WITHOUT-INTERRUPTS"
(de :cpfnt:schedule (fnt corps)
   (let ( (ad (:genlab)) )
      (:with-no-tail-and-return 'a1
         (:mov (:exp fnt) 'a1)
         (:push `(|@| ,ad))
         (:code '(jcall #:llcp:schedule))
         (:push-value 3)
         (:clear-all-reg)
         (:mov (:progn corps) 'a1)
         (:clear-all-reg)
         (:code '(return))
         (:code ad)
         (:pop-value 4)
         (:peephole-bug) )
      'a1 ))

(de :cpfnt:with-interrupts (corps)
   (let ( (ad (:genlab)) )
      (:with-no-tail-and-return 'a1
         (:push `(|@| ,ad))
         (:code '(jcall #:llcp:with-interrupts))
         (:push-value 4)
         (:clear-all-reg)
         (:mov (:progn corps) 'a1)
         (:clear-all-reg)
         (:code '(return))
         (:code ad)
         (:pop-value 5)
         (:peephole-bug) )
      'a1 ))

(de :cpfnt:without-interrupts (corps)
   (let ( (ad (:genlab)) )
      (:with-no-tail-and-return 'a1
         (:push `(|@| ,ad))
         (:code '(jcall #:llcp:without-interrupts))
         (:push-value 4)
         (:clear-all-reg)
         (:mov (:progn corps) 'a1)
         (:clear-all-reg)
         (:code '(return))
         (:code ad)
         (:pop-value 5)
         (:peephole-bug) )
      'a1 ))

;;.SSSection "TAGBODY"
(de :cpfnt:tagbody (corps)
   (let ( (ad (:genlab)) (lad) (n 0) (l corps) )
      (:push `(|@| ,ad))
      (mapc
         (lambda (ad)
            (unless (consp ad)
               (:push `(|@| ,(car (newl lad (:genlab)))))
               (:push `',ad)
               (setq n (add1 n)) ))
         l )
      (setq lad (nreverse lad))
      (:push `',n)
      (:code '(jcall #:llcp:tagbody))
      (:push-value 3)
      (:clear-all-reg)
      (:with-no-tail-and-return ()
         (mapc
            (lambda (ad)
               (if (consp ad)
                  (:exp ad)
                  (:code (nextl lad))
                  (:clear-all-reg) ))
            corps ))
      (:peephole-bug)
      (:code '(return))
      (:code ad)
      (:pop-value (add (mul 2 n) 5))
      (:peephole-bug)
      'nil ))

(de :cpfnt:go (et)
   (:mov `',et 'a1)
   (:code '(jmp #:llcp:go))
   'a1 )
         
;;.SSection "Les autres petits trucs"
;;.SSSection "DECLARE"
(de :cpfnt:declare1 (type . larg)
   ''comment )

(de :cpfnt:precomp ((int lap ev . dest))
   (while (consp lap) (:code (copy (nextl lap))))
   (eval ev)
   (or (car dest) 'a1) )

;;.SSSection "NOT"
(de :cpfnt:not ((l))
   (let ( (et1 (:genlab)) (et2 (:genlab)) )
      (:with-no-tail (setq l (:read-op (:exp l))))
      (ifn :return? t
         (:code `(btnil ,l ,et1))
         (:mov 'nil :return?)
         (:code `(bra ,et2))
         (:code et1)
         (:mov ''t :return?)
         (:code et2)
         :return? )))

;;.SSSection "LAMBDA  -  FLAMBDA"
(de :cpfnt:funarg (corps)
   (let ( (fnt (symbol :f (gensym))) (ad) (g :genlab) (save ())
          (type (car (nextl :bind))) (bind (car (nextl :bind))) (lap :lap) )
      (setq save (list :a1 :a2 :a3 :a4 :stack :v-stack :env :protect :op-stack
            :l-adjust :tail? :return? :lframe :bind :&nobind :funarg?))
      (:initall fnt)
      (setq :lap lap :bind bind :genlab g ad (:genlab) :funarg? t)
      (:code `(bra ,ad))
      (setq bind (:make-header fnt type (car corps)))
      (:mov (:progn (cdr corps)) 'a1)
      (:reset-env () bind t)
      (:code-last '(return))
      (:final-adjust)
      (while :op-stack
         (rplacd (car :op-stack) (ncons (caar :op-stack)))
         (rplaca (nextl :op-stack) '&) )
      (:code ad)
      (deset
         '(:a1 :a2 :a3 :a4 :stack :v-stack :env :protect :op-stack
            :l-adjust :tail? :return? :lframe :bind :&nobind :funarg?)
         save )
      `',fnt ))

;;.SSSection "SETQ  -  DESET"
(de :cpfnt:setq (l)
   (let ( (rep 'nil) op )
      (:with-no-tail-and-return (:alloc-reg () ())
         (while l
            (ifn (symbolp (car l))
               (:error 8 (car l))
               (setq op (:read-op (:get-env (car l))))
               (:mov (setq rep (:exp (cadr l))) op)
               (:clear-var-in-all-reg (car l))
               (when (:reg? rep) (:set-reg (car l) rep)))
           (setq l (cddr l)) ))
      rep ))

(de :cpfnt:deset ((lvar lval))
   (if (and (consp lvar) (eq (car lvar) 'quote))
      (let ( (nlvar (:copy-gensym (cadr lvar))) )
         (:exp
            `((lambda (,nlvar) (setq ,@(:peigne (cadr lvar) nlvar)))
               ,lval ))
         ''t )
      (:with-no-tail-and-return 'a1 (:subr2 (cons lvar (ncons lval))))
      (:call 'deset) ))
