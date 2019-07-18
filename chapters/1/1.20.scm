#|
*Euclid's algorithm* for finding greatest common divisors: if `r` is the remainder of dividing `a`
by `b`, then the common divisors of `a` and `b` are the same as the common divisors of `b` and `r`.
(It's O(log(N)).)
|#

(define (greatest-common-divisor a b)
    (if (= b 0)
        a
        (greatest-common-divisor b (remainder a b))))

; --------------------------------------------------------------------------------------------------
; Illustrate the expansion of `(greatest-common-divisor 206 40)` under *normal-order evaluation*
; (and remember, this is *not* how Scheme actually behaves!)
; --------------------------------------------------------------------------------------------------

#|
Recall that, while applicative-order evaluation reduces function arguments before evaluating
function bodies, normal-order evaluation substitutes variables (deferring reduction) until primitive
operators are left, then reduces everything.
So we have the steps:
    (gcd 206 40)
    (if (= 40 0) ...)
    (gcd 40 (remainder 206 40))
    (if (= (remainder 206 40) 0) ...)
    (if (= 6 0) ...)
    (gcd (remainder 206 40) (remainder 40 (remainder 206 40)))
    (if (= (remainder 40 (remainder 206 40)) 0) ...)
    (if (= 4 0) ...)
    (gcd (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))
    ...until b is 0
Notice that each tail call piles up more and more deferred operations, while each `=` expression
resolves them. The normal-order version certainly performs `remainder` more than we would under
applicative-order evaluation!
|#
