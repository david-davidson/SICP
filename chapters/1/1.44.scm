(load "chapters/1/1.43.scm") ; To import `repeated`

;---------------------------------------------------------------------------------------------------
; Smoothing, from signal processing, involves taking a function `f` and some small number `dx`, and
; building a smoothed function whose value at `x` is the average of `f(x - dx)`, `f(x)`, and
; `f(x + dx)`. Write a function `smooth` to implement this.
;---------------------------------------------------------------------------------------------------

(define dx 0.00001)

; Cheating a little and using variadic syntax...
(define (average . args)
    (/ (apply + args)
       (length args)))

(define (smooth fn)
    (lambda (x)
        (average (fn (- x dx))
                 (fn x)
                 (fn (+ x dx)))))

;---------------------------------------------------------------------------------------------------
; Sometimes it's necessary to repeatedly smooth a function, generating an *n-fold smoothed
; function*. Use `repeated` (from 1.43.scm) and `smooth` to do so.
;---------------------------------------------------------------------------------------------------

(define (n-fold-smoothed fn n)
    ((repeated smooth n) fn))

;---------------------------------------------------------------------------------------------------
; How does this work?
;   * The return value of `(repeated smooth n)` is a unary function that'll call `smooth` `n` times
;   * The return value of `((repeated smooth n) fn)` is _another_ unary function (just like that of
;   `(smooth fn)`) that'll be called with an actual value `x`
;
; So, invoking `n-fold-smoothed` invokes two higher-order functions before we enter the familiar
; averaging logic!
;---------------------------------------------------------------------------------------------------
