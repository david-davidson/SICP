; --------------------------------------------------------------------------------------------------
; We can represent pairs of nonnegative integers using only numbers and arithmetic if we represent
; `a` and `b` as the product `2^a * 3^b`. Implement `cons`, `car`, and `cdr`:
; --------------------------------------------------------------------------------------------------

(define (cons a b)
    (* (expt 2 a)
       (expt 3 b)))

(define (car n)
    (get-divisors n (lambda (even-divisor odd-divisor)
                        (log-base 2 even-divisor))))

(define (cdr n)
    (get-divisors n (lambda (even-divisor odd-divisor)
                        (log-base 3 odd-divisor))))

(define (get-divisors n next)
    (let ((odd-divisor (get-odd-divisor n)))
        (next (/ n odd-divisor)
              odd-divisor)))

(define (get-odd-divisor n)
    (define (iter x)
        (if (even? x)
            (iter (/ x 2))
            x))
    (iter n))

; Per https://en.wikibooks.org/wiki/Scheme_Programming/Further_Maths#Logarithm, Scheme's built-in
; `log` is the natural log, but we can get to an arbitrary base like this:
(define (log-base base x)
    (/ (log x)
       (log base)))

#|
(define pair (cons 7 8))
(car pair) ; => 7
(cdr pair) ; => 8
|#
