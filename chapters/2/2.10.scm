(load "chapters/2/2.7.scm") ; To import interval utils

; --------------------------------------------------------------------------------------------------
; Update `div-interval` to signal an error if you try to divide by zero.
; --------------------------------------------------------------------------------------------------

(define (spans-zero? interval)
    (and (> (upper-bound interval) 0)
         (< (lower-bound interval) 0)))

(define (div-interval x y)
    (if (spans-zero? y)
        "ERROR: divide by zero"
        (mul-interval x (reciprocal-interval y))))
