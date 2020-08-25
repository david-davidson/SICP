;---------------------------------------------------------------------------------------------------
; Define a procedure `double` that takes a unary function as its argument and returns a function
; that applies the original function _twice_:
;---------------------------------------------------------------------------------------------------

(define (double fn)
    (lambda (x)
        (fn (fn x))))

; (((double (double double)) inc) 5) => 21
