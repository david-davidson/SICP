; --------------------------------------------------------------------------------------------------
; Implement Newton's method for finding cube roots (defined in the book)
; --------------------------------------------------------------------------------------------------

; The heart of the method: returns a closer approximation of the cube root
(define (improve guess target)
    (/ (+ (/ target (square guess))
          (* 2 guess))
       3))

(define (good-enough? guess prev-guess target)
    (< (abs (- guess prev-guess))
       0.001))

(define (cube-root-iter guess prev-guess target)
    (if (good-enough? guess prev-guess target)
        guess
        (cube-root-iter (improve guess target)
                        guess
                        target)))

(define (cube-root target)
    (cube-root-iter 1.0 0 target))
