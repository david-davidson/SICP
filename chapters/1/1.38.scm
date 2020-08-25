(load "chapters/1/1.37.scm") ; To import `continued-fraction`

;---------------------------------------------------------------------------------------------------
; Euler uses a continued fraction to approximate `e-2`, where `e` is the base of the natural
; logarithms. In his fraction, the N(k) values are all 1, and the D(k) values are 1, 2, 1, 1, 4, 1,
; 1, 6, 1, 1, 8...
; Use `continued-fraction` to approximate `e`:
;---------------------------------------------------------------------------------------------------

(define (n k) 1.0)

(define (d k)
    (define (is-meaningful? k)
        (= 2 (modulo k 3)))
    (define (transform k)
        (* 2 (ceiling (/ k 3))))
    (if (is-meaningful? k)
        (transform k)
        1))

(define (euler-e k)
    (+ 2 (continued-fraction n d k)))

; (euler-e 10) => 2.718281...

;---------------------------------------------------------------------------------------------------
; Note that the sequence of k => D(k) pairs looks like:
;   1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11...
;   1, 2, 1, 1, 4, 1, 1, 6, 1, 1,  8...
;
; The "meaningful" k's are 2, 5, 8, 11..., with a clear 3-based pattern. From there, the definition
; of `is-meaningful?` is straightforward.
; In turn, mapping meaningful k's to their values requires mapping 2=>2, 5=>4, 8=>6, 11=>8, ...
; The pattern is again 3-based, so `transform` boils down to dividing by 3 and transforming the
; result to fit Euler's pattern.
;---------------------------------------------------------------------------------------------------
