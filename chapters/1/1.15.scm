#|
SICP sez: The sine of an angle (in radians) can be computed by making use of the approximation
`sin x ≈ x` when x is sufficiently small, and `sin r = 3sin(r / 3) - 4sin(3(r / 3))` to reduce the
size of the argument of `sin`. (Here, we define "sufficiently small" as 0.1.)
|#

(define (cube x) (* x x x))

(define (p x)
    (- (* 3 x)
       (* 4 (cube x))))

(define (sine angle)
    (if (not (> (abs angle) 0.1))
        angle
        (p (sine (/ angle 3.0)))))

; --------------------------------------------------------------------------------------------------
; How many times is `p` called when `(sine 12.15)` is evaluated?
; What is the time/space complexity of `sine`?
; --------------------------------------------------------------------------------------------------

#|
Here is the expansion of `(sine 12.15)`, as far as it _adds_ calls to `p`:
(sine 12.15)
(p (sine 4.05))
(p (p (sine 1.35)))
(p (p (p (sine .45))))
(p (p (p (p (sine .15)))))
(p (p (p (p (p (sine .05)))))) ; Now under the threshold!

So, `p` is called 5 times.

Both the number of calls and the memory consumption are governed by recursive division by 3, so this
isn't linear: handling a number 10x larger isn't 10x as expensive. For both time and space, this is
O(log(N)).
|#
