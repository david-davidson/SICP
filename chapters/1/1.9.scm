;---------------------------------------------------------------------------------------------------
; These two toy functions implement adding with the help of `inc` (increments by 1) and `dec`
; (decrements by 1). Are they iterative or recursive?
;---------------------------------------------------------------------------------------------------

(define (inc x) (+ x 1))

(define (dec x) (- x 1))

(define (add-one a b)
    (if (= a 0)
        b
        (inc (add-one (dec a) b))))

(define (add-two a b)
    (if (= a 0)
        b
        (add-two (dec a) (inc b))))

#|
`add-one` is recursive and `add-two` is iterative. `add-one` relies on deferred operations to track
its state; `add-two` captures all state in `a` and `b`.
|#
