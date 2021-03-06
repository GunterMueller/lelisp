
;;; Configuration file for: lelisps  (regular compiled Le-Lisp system)

(defvar :load-runtime (runtime))

(load-std () t t t t t)
(progn (print ";; load time: " (- (runtime) :load-runtime) " secs.") ())
;(debug t)

(add-feature (if (eq 0.0 0.0)
                 '31bitfloats
                 '64bitfloats))
(llcp-std #:system:name)

