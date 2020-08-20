(load "chapters/3/3.55.scm") ; To import `partial-sums`

; --------------------------------------------------------------------------------------------------
; In chapter 1, we saw that we can approximate pi with the following sequence:
; π/4 = 1 - 1/3 + 1/5 - 1/7 + ...
; Well, we can express that as a stream!
; --------------------------------------------------------------------------------------------------

; `pi-summands` expresses the `1 - 1/3 + 1/5 - ...` pattern. The hard part is "flipping" the +/-
; sign -- it's not hard to do, just hard to understand the example implementation!
; Basically, with each step's use of `stream-map`, each step adds an _additional_ call to `-`:
; - The first entry, 1, is not mapped against `-`: it's positive
; - The second, 1/3, is mapped against `-` once (when n is 3): negative
; - The third, 1/5, is mapped against `-` _twice_ (n=3, n=5): positive again
; ...and so on!
(define (pi-summands n)
    (cons-stream (/ 1.0 n)
                 (stream-map - (pi-summands (+ n 2)))))

; Far be it from me to code-review SICP, but I'd make a couple changes here:
; - For the stream to be *π's* summands, it is tightly coupled to that initial value of 1. `n`
;   should not (initially) be an argument -- `(pi-summands 2)` is meaningless!
; - The use of `stream-map` to toggle sign is too clever for its own good: both hard (for me) to
;   intuit, and unperformant. (Note that, for the 10th summand alone, it calls `-` 9 times, almost
;   all of them redundant.)
; Instead, I'd write something like this, with the sign-toggling explicit and the initial 1
; hard-coded:
(define (my-pi-summands)
    (define (iter n is-positive)
        (let ((next-summand (/ 1.0 n)))
            (cons-stream (if is-positive next-summand (- next-summand))
                         (iter (+ n 2) (not is-positive)))))
    (iter 1 true))

; Simply multiplies each entry by `factor`
(define (scale-stream seq factor)
    (stream-map (lambda (x) (* x factor))
                seq))

; Now we can use `partial-sums` to add the summands and `scale-stream` to multiply by 4:
(define pi-stream (scale-stream (partial-sums (pi-summands 1))
                                4))

; --------------------------------------------------------------------------------------------------
; `pi-stream` is a stream whose entries are successively better and better approximations of pi.
; By the 10th and 11th entries, we're converging between 3.0418396189294032 and 3.232315809405594:
; (stream-ref pi-stream 9) => 3.0418396189294032
; (stream-ref pi-stream 10) => 3.232315809405594
; --------------------------------------------------------------------------------------------------
