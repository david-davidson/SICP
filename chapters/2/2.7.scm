; --------------------------------------------------------------------------------------------------
; We're presented with the notion of "interval arithmetic," where an interval (in the context of
; inexact quantities) represents the lower and upper possible bounds of a given value. Such an
; interval supports basic arithmetic.
; --------------------------------------------------------------------------------------------------

(define (make-interval a b) (cons a b))

; Simply add the lower and upper bounds
(define (add-interval x y)
    (make-interval (+ (lower-bound x) (lower-bound y))
                   (+ (upper-bound x) (upper-bound y))))

; Take the lower and upper bounds (min and max) of all the different products of bounds. (This
; doesn't strike me as completely self-explanatory; it looks like we'll write an alternate
; implementation later!)
(define (mul-interval x y)
    (let ((p1 (* (lower-bound x) (lower-bound y)))
          (p2 (* (lower-bound x) (upper-bound y)))
          (p3 (* (upper-bound x) (lower-bound y)))
          (p4 (* (upper-bound x) (upper-bound y))))
        (make-interval (min p1 p2 p3 p4)
                       (max p1 p2 p3 p4))))

; An interval's reciprocal is defined by the reciprocal of its upper bound and that of its lower
; bound, in that reverse order
(define (reciprocal-interval x)
    (make-interval (/ 1.0 (upper-bound x))
                   (/ 1.0 (lower-bound x))))

; Multiply x by the reciprocal of y
(define (div-interval x y)
    (mul-interval x (reciprocal-interval y)))

; --------------------------------------------------------------------------------------------------
; Problem: we're given the definition of `make-interval`. From there, provide `lower-bound` and
; `upper-bound`.
; (A nice softball to ease in the extended exercise!)
; --------------------------------------------------------------------------------------------------

(define (lower-bound interval) (car interval))
(define (upper-bound interval) (cdr interval))
