(load "chapters/2/2.7.scm") ; To import interval utils

(define (parallel-one interval-one interval-two)
    (div-interval (mul-interval interval-one interval-two)
                  (add-interval interval-one interval-two)))

(define (parallel-two interval-one interval-two)
    (let ((one (make-interval 1 1)))
        (div-interval one
                      (add-interval (div-interval one interval-one)
                                    (div-interval one interval-two)))))
; --------------------------------------------------------------------------------------------------
; Picking up on 2.14: it's asserted that `parallel-two` is more accurate (has tigher error bounds)
; than the algebraically equivalent `parallel-one`. Is this the case?
;
; Yes, it is: as discussed in 2.14, each *instance* of an interval reduces the precision of the
; result. In the case of `parallel-one`, the two intervals arguments each appear twice in the body,
; each time contributing to the uncertainty of the result. On the other hand, in `parallel-two`,
; each argument is used only once--and the only other interval, `one`, is perfectly precise.
; --------------------------------------------------------------------------------------------------
