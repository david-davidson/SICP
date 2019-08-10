#|
Fermat's test for primality, unlike the test in 1.21.scm, is **probabilistic**: it delivers an
answer that is _probably_ correct (much more quickly than the deterministic algorithm: O(log(N))).

It goes:
* Two numbers are said to be congruent modulo `n` if they both have the same remainders when divided
    by `n`.
* If `n` is a prime number and `a` is any positive integer less than `n`, then `a` to the `nth`
    power is congruent to `a modulo n`.
* If `n` is not prime, then _most_ of the numbers `a < n` will not satisfy the above relation.
* The algorithm: pick a random number `a < n` and test it. Now pick another. The more you pick, the
    more confidence in the result.
|#

;---------------------------------------------------------------------------------------------------
; Update 1.22.scm to import _this_ `prime?` predicate and re-run the `search-for-primes` test. We
; should observe faster runtimes: O(log(N)), not O(sqrt(N))
;---------------------------------------------------------------------------------------------------

; Computes the exponential of one number modulo another
(define (expmod base exp m)
    (cond ((= exp 0) 1)
          ((even? exp) (remainder (square (expmod base (/ exp 2) m))
                                  m))
          (else (remainder (* base (expmod base (- exp 1) m))
                           m))))

(define (fermat-test n)
    (define (test-expmod a)
        (= (expmod a n n) a))
    (test-expmod (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
    (cond ((= times 0) true)
          ((fermat-test n) (fast-prime? n (- times 1)))
          (else false)))

(define (prime? n)
    (fast-prime? n 10))
