; This is a mathematical function called Ackermann's function:
(define (A x y)
    (cond ((= y 0) 0)
          ((= x 0) (* 2 y))
          ((= y 1) 2)
          (else (A (- x 1)
                   (A x (- y 1))))))

;---------------------------------------------------------------------------------------------------
; What are the values of the following expressions?
;---------------------------------------------------------------------------------------------------

(A 1 10) ; 1024
(A 2 4) ; 65536
(A 3 3) ; 65536

;---------------------------------------------------------------------------------------------------
; Now consider the following functions, defined in terms of `A`.
; What are their mathematical equivalents?
;---------------------------------------------------------------------------------------------------

(define (f n) (A 0 n)) ; 2n
#|
With x bound to 0, this one immediately hits the `((= x 0) (* 2 y))` `cond` case.
|#

(define (g n) (A 1 n)); 2^n
#|
Hits `else`:
```
(A 0
   (A 1 (- n 1)))
```
Eventually `(- n 1)` counts down to 1, returns 2:
```
(A 0
    (A 0
        (A 0
            ...
            (A 0 2))))
```
(A 0 x) => 2x; doubles each time it recurses
Thus, 2^n!
|#

(define (h n) (A 2 n)); 2^(2^(2^2)) (to depth n)
#|
Hits `else`:
```
(A 1
   (A 2 (- n 1)))
```
Eventually `(- n 1)` counts down to 1, returns 2:
```
(A 1
    (A 1
        (A 1
            ...
            (A 1 2))))
```
(A 1 2) => 2^2: raises to 2nd power every time it recurses
Thus, 2^(2^(2^2)) (to depth n)
|#
