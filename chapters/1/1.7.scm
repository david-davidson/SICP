; --------------------------------------------------------------------------------------------------
; Q: Why doesn't 1.6.scm's implementation of successive guesses work with very large or very small
; numbers?
; Another guessing approach is to watch the change between guesses and stop when it's a tiny
; fraction of the guess—how might this work?
; --------------------------------------------------------------------------------------------------

#|
A: Most computers perform arithmetic operations with limited precision; very large numbers may not
be able to hit the threshold of .001 hard-coded in 1.6.scm. On the other hand, with very small
numbers, .001 may not be close at all.
An alternative implementation might look like this:
|#

; Checks if the latest guess is within .001 of the previous one:
(define (good-enough? guess prev-guess target)
    (< (abs (- guess prev-guess))
       0.001))

(define (improve guess target)
    (average guess (/ target guess)))

(define (average x y)
    (/ (+ x y) 2))

(define (sqrt-iter guess prev-guess target)
    (if (good-enough? guess prev-guess target)
        guess
        (sqrt-iter (improve guess target)
                   guess
                   target)))

(define (sqr target)
    (sqrt-iter 1.0 0 target))
