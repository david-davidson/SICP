#|
The following straightforward algorithm tests for primality by checking whether
[2, 3, 4...] divide cleanly into the target number. We can stop at (sqrt target-
num), because if target-num is _not_ prime, it must have a divisor less than or
equal to its square root.
|#

(define (smallest-divisor n)
    (find-divisor n 2))

(define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
          ((divides? test-divisor n) test-divisor)
          (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
    (= (remainder b a) 0))

(define (prime? n)
    (= n (smallest-divisor n)))

; --------------------------------------------------------------------------------------------------
; Using `smallest-divisor`, what are the smallest divisors of the following numbers?
; --------------------------------------------------------------------------------------------------
#|
(smallest-divisor 199) => 199
(smallest-divisor 1999) => 1999
(smallest-divisor 19999) => 7
|#
