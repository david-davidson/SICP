;---------------------------------------------------------------------------------------------------
; An *infinite continued fraction* follows the pattern N1 / (D1 + (N2 / (D2 + (N3 ...)))). We can
; truncate the fraction after k terms, creating a *k-term finite continued fraction*.
; If all values of N(k) are 1, this will produce 1/Θ, where Θ is the golden ratio.
;
; Write a function `continued-fraction` that produces such a continued fraction:
;---------------------------------------------------------------------------------------------------

(define (continued-fraction n d k)
    (define (iter total idx)
        (if (< idx 1)
            total
            (iter (/ (n idx)
                     (+ (d idx) total))
                  (- idx 1))))
    (iter 0 k))

;---------------------------------------------------------------------------------------------------
; What value of k do we need to return an approximation of 1/Θ accurate to four decimal places?
;---------------------------------------------------------------------------------------------------

(define (k-term-golden-ratio k)
    (continued-fraction (lambda (i) 1.0)
                        (lambda (i) 1.0)
                        k))

; (k-term-golden-ratio 11) => .6180...

;---------------------------------------------------------------------------------------------------
; Now, write a recursive version:
;---------------------------------------------------------------------------------------------------

(define (continued-fraction-recur n d k)
    (define (recur idx)
        (/ (n idx)
           (if (>= idx k)
               (d idx)
               (+ (d idx) (recur (+ idx 1))))))
    (recur 1))

;---------------------------------------------------------------------------------------------------
; I spent a long time trying to come up with a recursive version that _doesn't_ require a helper and
; simply decrements `k`. No luck: something like this looks _plausible_ (and happens to give the
; correct answer when `n` and `d` are constant functions, as in the golden-ratio example), but is
; incorrect because it runs the sequence in reverse: N(k) / (D(k) + (N(k -1) / (D(k -1)...))).
; To the best of my knowledge, the recursive version requires a helper and an increasing sequence.
;---------------------------------------------------------------------------------------------------

(define (continued-fraction-recur-wrong n d k)
    (/ (n k)
       (if (< k 1)
           (d k)
           (+ (d k) (continued-fraction-recur-wrong n d (- k 1))))))
