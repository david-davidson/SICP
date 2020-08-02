(load "chapters/3/pi.scm") ; To import `pi-stream`

; --------------------------------------------------------------------------------------------------
; Euler's accelerator transformation (see ch. 3 README):
; S(n+1) = ((S(n+1) - S(n)) ^ 2) /
;          (S(n - 1) - 2(S(n)) + S(n + 1))
; --------------------------------------------------------------------------------------------------

; Scheme expression of the formula above. Note that we're running it in reverse: the original solves
; from n to n+1, but we solve for n (by subtracting the result from n+1, which, because it's part of
; the source stream, is known ahead of time).
; Note, too, that by treating `(stream-ref seq 0)` as the n-1 value and (stream-ref seq 1)
; as the n value, we start at index 1, offsetting the transformed sequence by 1. (This isn't
; the source of the transformation's acceleration, just an interesting nuance.)
(define (euler-formula s0 s1 s2)
    (- s2 (/ (square (- s2 s1))
             (+ s0 (* -2 s1) s2))))

(define (euler-transform seq)
    (cons-stream (euler-formula (stream-ref seq 0) ; S(n-1)
                                (stream-ref seq 1) ; S(n)
                                (stream-ref seq 2)) ; S(n+1)
                 (euler-transform (stream-cdr seq))))

(define euler-stream (euler-transform pi-stream))

; --------------------------------------------------------------------------------------------------
; This is remarkably better: while `pi-stream`, 10 steps in, is bound between `3.0418...` and
; `3.2323...`, the accelerated version has already converged beyond `3.141...`:
; (stream-ref euler-stream 9) => 3.141406718496503
; (stream-ref euler-stream 10) => 3.1417360992606667
; --------------------------------------------------------------------------------------------------

; Fun sidebar from the book: `euler-transform` is doing something conceptually equivalent to
; "many-to-one mapping" here, where _three_ fields from the input seq map, via `euler-formula`, to
; one field in the accelerated stream. We can generalize that via a version of `stream-map` that's
; virtually unchanged:

(define (stream-map-multi fn seq)
    (if (stream-null? seq)
        the-empty-stream
        (cons-stream (fn seq) ; Changed from `(fn (stream-car seq))`
                     (stream-map-multi fn (stream-cdr seq)))))

; Used like...
(define my-euler-stream (stream-map-multi
                            (lambda (seq)
                                (euler-formula (stream-ref seq 0)
                                               (stream-ref seq 1)
                                               (stream-ref seq 2)))
                            pi-stream))

; --------------------------------------------------------------------------------------------------
; Now: having accelerated the stream, we can go further. We can create a *stream of streams* (a
; structure called a tableau) where each stream accelerates its predecessor!
; --------------------------------------------------------------------------------------------------

; The implementation is trivial:
(define (make-tableau transform seq)
    (cons-stream seq
                 (make-tableau transform
                               (transform seq))))

; To use this structure, we map over the stream-of-streams, taking the first entry in each:
(define (accelerated-sequence transform seq)
    (stream-map stream-car
                (make-tableau transform seq)))

(define euler-stream-improved (accelerated-sequence euler-transform
                                                    pi-stream))

; --------------------------------------------------------------------------------------------------
; The super-accelerated result is, again, REMARKABLY better:
; (stream-ref euler-stream-improved 8) => 3.14159265358979...
; 8 steps in, it's accurate to 14 decimal places! In the original π sequence (notes SICP), it would
; take something like 10^13 steps to reach that accuracy.
;
; (BTW, some limit in Scheme's precision (???) creates problems computing these super-accelerated
; streams beyond a certain threshold: `(stream-ref euler-stream-improved 10)` returns `#[NaN]`)
; --------------------------------------------------------------------------------------------------

; OK, one more fun sidebar: our original accelerated stream accelerated the π stream *once*. Our
; super-accelerated tableau accelerated the π stream *n times*: this can be thought of as applying
; the tableau approach *once*. Since the result is still an ordinary stream -- still susceptible to
; further acceleration -- you can imagine "super-super-accelerating" by applying the tableau
; approach *n times*: a stream-of-streams-of-streams.
;
; The only gotcha is that, above, we extract entries from the tableau with `stream-car`, and the
; first entry is 4. With the tableau-of-tableaus approach, if we take `stream-car` of each tableau,
; we get 4, 4, 4... So, instead we take the _second_ entry of our tableaus:
(define (second-entry seq) (stream-ref seq 1))
(define (accelerated-sequence-custom transform seq)
    (stream-map second-entry
                (make-tableau transform seq)))

; With that in place, super-super-accelerating is as simple as calling `accelerated-sequence-custom`
; with a transform that accelerates each term not with the straightforward Euler transform, but with
; the tableau approach -- that is, `accelerated-sequence-custom` itself:
(define super-super (accelerated-sequence-custom
                        (lambda (seq)
                            (accelerated-sequence-custom euler-transform seq))
                        pi-stream))
; (stream-ref super-super 3) => 3.14159265358979..., accurate to 14 decimals places in 3 steps!
