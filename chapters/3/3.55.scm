#|
Problem: define a procedure `partial-sums` that takes a stream S and returns the stream whose
elements are S0, S0 + S1, S0 + S1 + S2...
e.g., the stream of integers should return 1, 1 + 2, 1 + 2 + 3... (that is, 1, 3, 6...)
|#

; --------------------------------------------------------------------------------------------------
; Couple helpers:
; --------------------------------------------------------------------------------------------------

(define (integers-starting-from n)
    (cons-stream n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))

(define (add-streams seq1 seq2)
    (stream-map + seq1 seq2))

; --------------------------------------------------------------------------------------------------
; The trick here is that a given item in the response -- say, `S0 + S1 + S2` -- is basically the
; _previous item_ in the response (here, `S0 + S1`) plus `S2`. We don't have to do all those
; additions for each entry; we just have to add the _previous_ entry in the response stream and the
; _latest_ entry in the input stream.
;
; This lets us use the `add-streams` trick, plus a response stream defined in terms of itself. Note
; that for the element-wise addition to work, we need to offset the input stream by one (with
; `(stream-cdr seq)`): that way, we get the latest + previous pairing, not latest + latest.
; --------------------------------------------------------------------------------------------------

(define (partial-sums seq)
    (define sums (cons-stream (stream-car seq)
                              (add-streams sums (stream-cdr seq))))
    sums)
; (stream-ref (partial-sums integers) 0) => 1
; (stream-ref (partial-sums integers) 1) => 3
; (stream-ref (partial-sums integers) 2) => 6
