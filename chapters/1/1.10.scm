; This is a mathematical function called Ackermann's function:
(define (A x y)
    (cond ((= y 0) 0)
          ((= x 0) (* 2 y))
          ((= y 1) 2)
          (else (A (- x 1)
                   (A x (- y 1))))))

;---------------------------------------------------------------------------------------------------
; What are the values of the following expressions?
;---------------------------------------------------------------------------------------------------

(A 1 10) ; 1024
(A 2 4) ; 65536
(A 3 3) ; 65536

; Now consider the following functions, mostly defined in terms of `A`...
(define (f n) (A 0 n))

(define (g n) (A 1 n))

(define (h n) (A 2 n))

;---------------------------------------------------------------------------------------------------
; What are the mathematical equivalents of these functions?
;---------------------------------------------------------------------------------------------------

; (f n) => 2n

; (g n) => 2^n

; (h n) => 2^(2^)(2^(...n - 1 times))
