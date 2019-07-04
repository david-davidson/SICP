; --------------------------------------------------------------------------------------------------
; Define a procedure that takes three numbers as arguments and returns the sum of the squares of the
; two larger numbers
; --------------------------------------------------------------------------------------------------
#|
With sorting and something like `take` available, this would be clean. But since we don't really
know any syntax yet, we can rely on a brute-force `cond` check!
|#

(define (>= x y)
    (not (< x y)))

(define (sum-of-squares x y)
    (+ (square x) (square y)))

(define (sum-of-greatest-squares x y z)
    (cond ((and (>= y x) (>= z x)) (sum-of-squares y z))
          ((and (>= x y) (>= z y)) (sum-of-squares x z))
          ((and (>= x z) (>= y z)) (sum-of-squares x y))))
