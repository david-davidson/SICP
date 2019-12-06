; --------------------------------------------------------------------------------------------------
; Using constructors and selectors for both points and segments, write a function `midpoint-segment`
; that takes a segment as an argument and returns its midpoint.
; --------------------------------------------------------------------------------------------------

(define (make-segment point-one point-two) (cons point-one point-two))

(define (start-segment segment) (car segment))

(define (end-segment segment) (cdr segment))

(define (make-point x y) (cons x y))

(define (x-point point) (car point))

(define (y-point point) (cdr point))

(define (halfway a b) (/ (+ a b) 2))

(define (midpoint-segment segment)
    (let ((start-point (start-segment segment))
          (end-point (end-segment segment)))
        (let ((start-x (x-point start-point))
              (end-x (x-point end-point))
              (start-y (y-point start-point))
              (end-y (y-point end-point)))
            (make-point (halfway start-x end-x)
                        (halfway start-y end-y)))))

#|
Testing:
(define start (make-point 2 2))
(define end (make-point 10 8))
(define segment (make-segment start end))
(midpoint-segment segment) => 6, 5
|#
