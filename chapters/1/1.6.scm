; Imagine a version of `if` based not on the standard special form, but on `cond`:
(define (cond-if predicate then-expression else-expression)
    (cond (predicate then-expression)
          (else else-expression)))

; Now, we use it to try to calculate square roots via Newton's method of guessing: `sqr`.

; Checks if a guess is within a "closeness threshold" (here, 0.001) of the value
(define (good-enough? guess x)
    (< (abs (- (square guess) x))
       0.001))

; Brings a guess closer to the target value
(define (improve guess x)
    (average guess (/ x guess)))

; Does what it says on the tin
(define (average x y)
    (/ (+ x y) 2))

; Loopss through successive guesses
(define (sqrt-iter guess x)
    (cond-if (good-enough? guess x); rather than `if`
             guess
             (sqrt-iter (improve guess x)
                        x)))

; Provides the initial guess (1.0). The decimal forces the result into decimals, too.
(define (sqr x)
    (sqrt-iter 1.0 x))

; --------------------------------------------------------------------------------------------------
; Q: What happens when we try to use this to compute square roots?
; --------------------------------------------------------------------------------------------------

#|
The code produces a stack overflow. The problem is that, under applicative-order evaluation, all
arguments to a function are reduced first. By replacing `if` with `cond-if`, we force both the
predicate and the return expressions (our arguments to `cond-if`) to be evaluated immediately. As a
result, `sqrt-iter` invokes itself over and over.
|#
