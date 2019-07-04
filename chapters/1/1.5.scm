; Given the following two procedures...

(define (p) (p))

(define (test x y)
    (if (= x 0)
        0
        y))

; --------------------------------------------------------------------------------------------------
; What behavior will we observe under applicative-order evaluation?
; What about normal-order evaluation?
; --------------------------------------------------------------------------------------------------

(test 0 (p))

#|
With applicative order, we fully evaluate each operand before applying the operator. That means we
have to evaluate `0` and `(p)`. The latter returns the invocation of itself, endlessly, so the
program doesn't terminate and the call stack overflows.

With normal order, we substitute variables until _only_ primitive operators are left, then reduce
the expression. The effect is that we proceed lazily: inside `test`, the `if` expression matches
`(= x 0)` before ever attempting to evaluate `y`, and the expression returns `0`.
|#

