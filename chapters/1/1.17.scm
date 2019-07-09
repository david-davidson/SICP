; --------------------------------------------------------------------------------------------------
; 1.16 expresses exponentiation by way of repeated multiplication. Similarly, we can express
; integer multiplication by way of repeated addition. Using addition and `double`/`halve` utils,
; write a recursive multiplication procedure that's O(log(N)).
; --------------------------------------------------------------------------------------------------

; For reference, the linear recursive implementation:
(define (mult-recur a b)
    (if (= b 0)
        0
        (+ a (mult-recur a (- b 1)))))

; --------------------------------------------------------------------------------------------------

(define (even? n)
    (= (remainder n 2) 0))

(define (double n)
    (+ n n))

(define (halve n)
    (/ n 2))

(define (fast-mult-recur a b)
    (cond ((= b 0) 0)
          ((even? b) (fast-mult-recur (double a) (halve b)))
          (else (+ a (fast-mult-recur a (- b 1))))))
