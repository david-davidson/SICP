;---------------------------------------------------------------------------------------------------
; A function f is defined by the rule that f(n) = n if n < 3 and f(n) = f(n - 1) + 2f(n-2) +
; 3f(n - 3) if n>= 3. Implement f in two functions, one recursive and one iterative.
;---------------------------------------------------------------------------------------------------

(define (f-recur n)
    (if (< n 3)
        n
        (+ (f-recur (- n 1))
           (* 2 (f-recur (- n 2)))
           (* 3 (f-recur (- n 3))))))

; The iterative form is a headache! We track the previous values at n-1, n-2, and n-3, relying on
; fact that (from the base case) we can initialize those to 2, 1, and 0.
(define (f-iter n)
    (define (iter counter prev-val-1 prev-val-2 prev-val-3)
        (let ((next-val (+ prev-val-1
                           (* 2 prev-val-2)
                           (* 3 prev-val-3))))
             (if (= counter n)
                 next-val
                 (iter (+ counter 1)
                       next-val ; next prev-val-1
                       prev-val-1
                       prev-val-2))))
    (if (< n 3)
        n
        (iter 3 2 1 0)))
