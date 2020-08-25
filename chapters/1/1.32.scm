;---------------------------------------------------------------------------------------------------
; Show that `sum` and `product` can be generalized yet further, to `accumulate`
;---------------------------------------------------------------------------------------------------

(define (accumulate combiner null-value a b term next)
    (if (> a b)
        null-value
        (combiner (term a)
                  (accumulate combiner
                              null-value
                              (next a)
                              b
                              term
                              next))))

; Now, `sum` and `product` differ only in their arguments:
(define (sum a b term next)
    (accumulate + 0 a b term next))
(define (product a b term next)
    (accumulate * 1 a b term next))

;---------------------------------------------------------------------------------------------------
; Then, rewrite `accumulate` as an iterative process
;---------------------------------------------------------------------------------------------------

(define (accumulate-iter combiner null-value a b term next)
    (define (iter-helper total a)
        (if (> a b)
            total
            (iter-helper (combiner total (term a))
                         (next a))))
    (iter-helper null-value a))
