; --------------------------------------------------------------------------------------------------
; Given this whimsical implementation of `cons`...
; --------------------------------------------------------------------------------------------------

(define (cons x y)
    (lambda (selector)
        (selector x y)))

; --------------------------------------------------------------------------------------------------
; ...and this implementation of `car`...
; --------------------------------------------------------------------------------------------------

(define (car pair)
    (pair (lambda (x y) x)))

; --------------------------------------------------------------------------------------------------
; ...implement the corresponding `cdr`:
; --------------------------------------------------------------------------------------------------

(define (cdr pair)
    (pair (lambda (x y) y)))

; --------------------------------------------------------------------------------------------------
; A neat little problem, reminiscent of the lambda calculus in 2.6! I believe this is basically the
; canonical LC representation for pairs? The selector for `car` is the K combinator; for `cdr`, KI;
; `cons` is the V combinator. Only real difference is the curried signature:
; --------------------------------------------------------------------------------------------------

(define (V x)
    (lambda (y)
        (lambda (z)
            ((z x) y))))
(define (K x)
    (lambda (y) x))
(define (I x) x)
(define KI (K I))

#|
(define pair ((V 1) 2))
(pair K) ; => 1
(pair KI) ; => 2
|#
