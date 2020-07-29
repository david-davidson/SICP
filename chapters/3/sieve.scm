(define (divisible? x y)
    (= (remainder x y) 0))

(define (integers-starting-from n)
    (cons-stream n (integers-starting-from (+ n 1))))

; --------------------------------------------------------------------------------------------------
; A really cool use case for streams: the Sieve of Eratosthenes. This algorithm starts with the
; first prime, 2, and filters out all numbers that are multiples of it. It moves to the next integer
; left after filtering, which is 3: another prime. Now it filters out all multiples of 3. 4 has been
; filtered, so it's on to 5 (and filter all its multiples). And so on...
;
; This algorithm lends itself to stream evaluation; below, `primes` is the infinite stream of all
; primes. As the book notes, not only is the stream infinite; the _sieve itself_ is too, as each
; `sieve` call constructs a further sieve.
; --------------------------------------------------------------------------------------------------

(define (sieve seq)
    (cons-stream
        (stream-car seq)
        (sieve (stream-filter
            (lambda (x)
                (not (divisible? x (stream-car seq))))
            (stream-cdr seq)))))

(define primes (sieve (integers-starting-from 2)))
; For the 10th prime: (stream-ref primes 10) => 31
