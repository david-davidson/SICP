(load "chapters/2/2.9.scm") ; To import interval utils

; --------------------------------------------------------------------------------------------------
; Define a constructor that takes a percentage tolerance, and a selector `percent` that produces
; that same tolerance.
; --------------------------------------------------------------------------------------------------

; For simplicity, I'm treating `tolerance` as a decimal value: 10% as .1, not 10
(define (make-center-percent center tolerance)
    (let ((width (abs (* center tolerance))))
        (make-interval (- center width) (+ center width))))

(define (center interval)
    (/ (+ (lower-bound interval) (upper-bound interval))
       2))

(define (percent interval)
    (/ (width interval)
       (center interval)))

(define ten (make-center-percent 10 .1))
(upper-bound ten) ; => 11
(lower-bound ten) ; => 9
(center ten) ; => 10
(percent ten) ; => .1
