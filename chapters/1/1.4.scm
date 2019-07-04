; --------------------------------------------------------------------------------------------------
; Q: Given that operators can be compound expressions, what is the behavior of this procedure?
; --------------------------------------------------------------------------------------------------
#|
A: The `if` expressions evaluates to `+` when b is positive and `-` when it's negative. That is:
    (a-plus-abs-b 1 2) => (+ 1 2) => 3
    (a-plus-abs-b 1 -2) => (- 1 -2) => 3
|#

(define (a-plus-abs-b a b)
    ((if (> b 0) + -) a b))
