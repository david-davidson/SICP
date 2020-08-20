;---------------------------------------------------------------------------------------------------
; Write a function called `product` (in the spirit of the book's example `sum`) that returns the
; product of the values of a function at points over a given range.
;---------------------------------------------------------------------------------------------------

(define (product a b term next)
    (if (> a b)
        1
        (* (term a)
           (product (next a)
                    b
                    term
                    next))))

;---------------------------------------------------------------------------------------------------
; Next, define `factorial` in terms of `product`:
;---------------------------------------------------------------------------------------------------

(define (inc x) (+ x 1)) ; Also used by `pi-approx`

(define (factorial n)
    (define (id x) x)
    (product 1 n id inc))

;---------------------------------------------------------------------------------------------------
; Next, use `product` to compute an approximation of pi, using this formula:
; π/4 = 2 * 4 * 4 * 6 * 6 * 8...
;       ------------------------
;       3 * 3 * 5 * 5 * 7 * 7...
;
; I struggled with this one, first trying to compute the series `2 * 4 * 4...` and `3 * 3 * 5 ...`
; separately, and next (closer!) trying to get the product of the series `2/3 * 4/3 * 4/5...`. The
; latter would work _except_ that `product` relies on a simple `a > b` check to terminate, and if
; `a` is a fraction, that check gets messy.
; After referencing someone's answer online, ended up with this solution, where the series itself
; is made up of integers (supporting the `a > b` check), but `term` maps the integer to the right
; fraction.
;---------------------------------------------------------------------------------------------------

(define (pi-approx n)
    (define (term n)
        (if (even? n)
            (/ (+ 2 n) (+ 3 n))
            (/ (+ 3 n) (+ 2 n))))
    (* 4.0 (product 0 n term inc)))

;---------------------------------------------------------------------------------------------------
; Finally, rewrite `product` iteratively.
;---------------------------------------------------------------------------------------------------

(define (product-iter a b term next)
    (define (iter-helper a sum)
        (if (> a b)
            sum
            (iter-helper (next a)
                         (* sum (term a)))))
    (iter-helper a 1))
