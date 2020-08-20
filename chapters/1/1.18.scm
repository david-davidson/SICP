(load "chapters/1/1.17.scm") ; To import `double` and `halve`

; --------------------------------------------------------------------------------------------------
; In the spirit of 1.16, implement 1.17's O(log(N)) strategy for integer multiplication... but
; iteratively
; --------------------------------------------------------------------------------------------------
; (As a reminder, we can use addition plus `even`, `double`, and `halve` utils)

(define (fast-mult-iter x y)
    (define (iter a x y)
        (cond ((= y 0) 0)
              ((= y 1) (+ a x))
              ((even? y) (iter a
                               (double x)
                               (halve y)))
              (else (iter (+ a x)
                          x
                          (- y 1)))))
    (iter 0 x y))

#|
This one clicked thanks to 1.16's hint about structuring iterative algorithms such that the
arguments maintain a constant relationship. Starting with, say, 6 and 7, and knowing that 7 will
follow the path 7->6->3->2->1, we can fill in the argument values (in a signature `(iter <something>
6 7)`) such that, on every loop, the 3 args always correspond to the answer (42).

Opted to have the correspondence be: first arg plus the product of the second. Whenever we decrement
`y`, we add `x` to `a`:
    0 6 7
    6 6 6
    6 12 3
    18 12 2
    30 12 1 ; returns 42
|#
