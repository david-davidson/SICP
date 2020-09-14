(load "chapters/2/2.7.scm") ; To import `make-interval`

; --------------------------------------------------------------------------------------------------
; We're given the cryptic hint that, by checking the signs of arguments, we can implement
; `mul-interval` in a way that checks nine cases, only one of which requires more than two
; multiplications. Implement this version.
; --------------------------------------------------------------------------------------------------

(define (negative-interval? interval)
    (and (negative? (lower-bound interval))
         (negative? (upper-bound interval))))

; Using `(not (negative?))`, rather than `positive?` to treat 0 (arbitrarily) as positive
(define (positive-interval? interval)
    (and (not (negative? (lower-bound interval)))
         (not (negative? (upper-bound interval)))))

(define (mul-interval x y)
    (cond ((negative-interval? x)
            (cond ((negative-interval? y)
                    ; Both negative: take upper limit of both (lowest absolute values) and multiply
                    ; for lower limit; lower limit of both (greatest abs values) for upper
                    (make-interval (* (upper-bound x) (upper-bound y))
                                   (* (lower-bound x) (lower-bound y))))
                  ((positive-interval? y)
                    ; x-, y+, result-: take lower of x and upper of y (greatest abs values) for
                    ; lower limit, reverse for upper
                    (make-interval (* (lower-bound x) (upper-bound y))
                                   (* (upper-bound x) (lower-bound y))))
                  (else
                    ; x-, y spans 0: take the greatest abs value of x (lower) and multiply by both y
                    ; values. Since we know `(lower-bound x)` is negative, `(upper-bound y)` is
                    ; positive, and `(lower-bound y)` is negative, we take y's upper bound when
                    ; calculating the lower bound (and vice versa), so that the resulting interval
                    ; has a negative lower bound and positive upper.
                    (make-interval (* (lower-bound x) (upper-bound y))
                                   (* (lower-bound x) (lower-bound y))))))
          ((positive-interval? x)
            (cond ((negative-interval? y)
                    ; x+, y-, result-: take upper of x and lower of y (greatest abs values) for
                    ; lower limit, reverse for upper
                    (make-interval (* (upper-bound x) (lower-bound y))
                                   (* (lower-bound x) (upper-bound y))))
                  ((positive-interval? y)
                    ; Both positive: straightforward, for once!
                    (make-interval (* (lower-bound x) (lower-bound y))
                                   (* (upper-bound x) (upper-bound y))))
                  (else
                    ; x+, y spans 0: take the greatest abs value of x (upper) and multiply by both y
                    ; values.
                    (make-interval (* (upper-bound x) (lower-bound y))
                                   (* (upper-bound x) (upper-bound y))))))
          (else
            (cond ((negative-interval? y)
                    ; x spans 0, y-: take y's lower limit (greatest abs value), multiply by both x
                    ; values, note that (as with x-, y spans 0) we take x's upper bound for the
                    ; lower bound (and vice versa) to keep the signs correct in the result
                    (make-interval (* (upper-bound x) (lower-bound y))
                                   (* (lower-bound x) (lower-bound y))))
                  ((positive-interval? y)
                    ; x spans 0, y+: take the greatest abs value of y (lower) and multiply by both x
                    ; values.
                    (make-interval (* (lower-bound x) (upper-bound y))
                                   (* (upper-bound x) (upper-bound y))))
                  (else
                    ; Both x and y span 0! Finally, our edge case. Because we know both values span
                    ; 0, we can avoid checking all four combinations for both min and max: for min,
                    ; we check only those combinations that'll result in a negative value; for max,
                    ; only those that'll result in a positive value.
                    (make-interval (min (* (lower-bound x) (upper-bound y))
                                        (* (upper-bound x) (lower-bound y)))
                                   (max (* (lower-bound x) (lower-bound y))
                                        (* (upper-bound x) (upper-bound y)))))))))

; Just for reference, the old version we're refactoring from. I'm by no means convinced we've made
; things better!
(define (mul-interval-old x y)
    (let ((p1 (* (lower-bound x) (lower-bound y)))
          (p2 (* (lower-bound x) (upper-bound y)))
          (p3 (* (upper-bound x) (lower-bound y)))
          (p4 (* (upper-bound x) (upper-bound y))))
        (make-interval (min p1 p2 p3 p4)
                       (max p1 p2 p3 p4))))
