(load "chapters/2/2.12.scm") ; To import percent utils

; --------------------------------------------------------------------------------------------------
; Show that, in general, one can approximate the percentage tolerance of the product of two
; intervals in terms of the tolerances of the component intervals. What is the formula for this
; approximation?
; --------------------------------------------------------------------------------------------------

; 10% tolerance, varying magnitude:
(define ten (make-center-percent 10 .1))
(define twenty (make-center-percent 20 .1))
(define forty (make-center-percent 40 .1))

; 20% tolerance:
(define fifty (make-center-percent 50 .2))

; Various products:
(define one-hundred (mul-interval ten ten))
(define two-hundred (mul-interval ten twenty))
(define eight-hundred (mul-interval twenty forty))
(define one-thousand (mul-interval twenty fifty))

(percent one-hundred) ; => .1980...
(percent two-hundred) ; => .1980...
(percent eight-hundred) ; => .1980...
(percent one-thousand) ; => .2941...

; --------------------------------------------------------------------------------------------------
; The approximation, then, is simply the addition of the two component tolerances, regardless of
; magnitude. This calls back to exercise 2.9, and the question of whether the width resulting from
; addition (yes) and multiplication (no) is a function solely of the width of the components, not
; their magnitudes. Now we see that in the case of multiplication, the pattern again holds, but with
; percent tolerance instead of width!
; --------------------------------------------------------------------------------------------------
