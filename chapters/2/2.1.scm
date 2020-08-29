(load "chapters/1/1.20.scm") ; To import `gcd`

; --------------------------------------------------------------------------------------------------
; Given these utils for manipulating rational numbers...
; --------------------------------------------------------------------------------------------------

(define (make-rat n d)
    (let ((greatest-divisor (gcd n d)))
        (cons (/ n greatest-divisor) (/ d greatest-divisor))))

(define (numer x)
    (car x))

(define (denom x)
    (cdr x))

(define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))

(define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))

(define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))

(define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom y) (numer y))))

(define (equal-rat? x y)
    (= (* (numer x) (denom y))
       (* (numer y) (denom x))))

(define (print-rat x)
    (newline)
    (display (numer x))
    (display "/")
    (display (denom x)))

; --------------------------------------------------------------------------------------------------
; ...Implement a version of `make-rat` that handles both positive and negative arguments. When both
; args are negative, the rational number is positive and should display as such. When only one arg
; is negative, the numerator should display as negative.
; --------------------------------------------------------------------------------------------------

(define (make-rat n d)
    (define (negative? x) (< x 0))
    (let ((greatest-divisor (gcd n d)))
        (let ((n-reduced (/ n greatest-divisor))
              (d-reduced (/ d greatest-divisor)))
            (cond ((and (negative? n-reduced)
                        (negative? d-reduced))
                    (cons (- n-reduced) (- d-reduced)))
                  ((and (not (negative? n-reduced))
                        (not (negative? d-reduced)))
                    (cons n-reduced d-reduced))
                  (else
                    (cons (- (abs n-reduced)) (abs d-reduced)))))))

#|
Testing:
(define one-half (make-rat (- 1) (- 2)))
(print-rat one-half) ; => 1/2
(define negative-one-third (make-rat 1 (- 3)))
(print-rat negative-one-third) ; => -1/3
(print-rat (mul-rat one-half negative-one-third)) ; => -1/6
|#
