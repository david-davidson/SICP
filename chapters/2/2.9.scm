(load "chapters/2/2.7.scm") ; To import interval utils

; --------------------------------------------------------------------------------------------------
; The width of an interval is one-half of the distance between its upper and lower bounds. For some
; arithmetic operations (addition and subtraction), the width of the result is determined ONLY by
; the width of the component intervals. For others (multiplication and subtraction), it's determined
; by other factors as well.
;
; Explain why this is the case!
; --------------------------------------------------------------------------------------------------

(define (width interval)
    (/ (- (upper-bound interval) (lower-bound interval))
       2))

; All have width 5:
(define ten (make-interval 5 15))
(define twenty (make-interval 15 25))
(define thirty (make-interval 25 35))

; In the case of addition, note how ~40 and ~50 have the same width because their terms have
; the same widths (even though they have different magnitudes)
; (width (add-interval ten thirty)) ; => 10
; (width (add-interval twenty thirty)) ; => 10

; But in the case of multiplication, the magnitudes of terms matter too:
; (width (mul-interval ten twenty)) ; => 150
; (width (mul-interval ten thirty)) ; => 200

; --------------------------------------------------------------------------------------------------
; Why?
;
; In the simple case of addition, consider the intervals [5, 15] and [1005, 1015]. You can think of
; the second interval as the first plus an interval with *perfect* tolerance: [1000, 1000]. That
; means the magnitude difference between the two doesn't matter: that difference, perfectly
; accurate, doesn't add any uncertainty to the results of addition/subtraction. In terms of
; uncertainty, the extra magnitude is "invisible."
;
; In the case of multiplication, it's useful to think of the operation as *repeated* addition. ~10 x
; ~1 is the same as ~1 + ~1 + ~1 + ... (~10x). That's why the magnitude of the terms matters: we
; already know that each arithmetic operation increases inaccuracy, and greater magnitude therefore
; results in more underlying addition/subtraction operations, each increasing the width of the
; result.
; --------------------------------------------------------------------------------------------------
