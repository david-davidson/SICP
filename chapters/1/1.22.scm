; (load "chapters/1/1.21.scm")
(load "chapters/1/1.24.scm") ; To use the probabilistic Fermat method

;---------------------------------------------------------------------------------------------------
; `timed-prime-test` uses the `runtime` helper (prints time Scheme has been executing) to time
; checks for primality. Use it to check the order of time growth for large numbers, using the
; `search-for-primes` helper.
;---------------------------------------------------------------------------------------------------

; We know even numbers (other than 2) aren't prime, so we can iterate over them
(define (search-for-primes first last)
    (define (search-iter cur last)
        (if (<= cur last) (timed-prime-test cur))
        (if (<= cur last) (search-iter (+ cur 2) last)))
    (search-iter (if (even? first) (+ first 1) first)
                (if (even? last) (- last 1) last)))

(define (timed-prime-test n)
    (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
    (let ((val (prime? n)))
        (report-elapsed-time val (- (runtime) start-time))))

(define (print-with-newline message)
    (display message)
    (newline))

(define (report-elapsed-time is-prime elapsed-time)
    (print-with-newline "*****")
    (print-with-newline "prime?")
    (print-with-newline (if is-prime "true" "false"))
    (print-with-newline "*****")
    (print-with-newline "time to calculate:")
    (print-with-newline elapsed-time))
