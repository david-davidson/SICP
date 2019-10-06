; --------------------------------------------------------------------------------------------------
; To get things started, SICP provides the following two definitions:
; --------------------------------------------------------------------------------------------------

(define zero (lambda (f)
    (lambda (x)
        x)))

#|
Note how this works:
* `(n f)` returns a lambda that expects a simple input, like `x`.
* `((n f) x)` invokes that lambda, calling `f` `n` times under the hood.
* `(f ((n f) x))` feeds the result into `f` one more time, adding one more function call.
|#
(define (add-one n)
    (lambda (f)
        (lambda (x)
            (f ((n f) x)))))

; --------------------------------------------------------------------------------------------------
; From there, we're asked to define `one` and `two` directly (not in terms of `zero` and`add-one`).
; (I find it helpful to think of Church numerals as adverbs, not nouns: "once," not "one.")
; --------------------------------------------------------------------------------------------------

; Both can be defined in terms of repeated execution of `f`
(define one (lambda (f)
    (lambda (x)
        (f x)))) ; One invocation

(define two (lambda (f)
    (lambda (x)
        (f (f x))))) ; Two invocations

; --------------------------------------------------------------------------------------------------
; We're also asked to define a generic `add`:
; --------------------------------------------------------------------------------------------------

#|
Note the signature here: `num -> num -> f -> x -> any` (not the more intuitive
`(num, num) -> f -> x -> any`). That's because we're choosing to follow the
constraints of the lambda calculus, where functions take just a single argument.

This works a lot like `add-one`:
* Here, we feed the results of `((n f) x)` into `(m f)`, not `f`.
* `(m f)`, just like `(n f)`, builds a lambda that calls `f` `m` times.
* So, we invoke `f` `n` times as we evalute `((n f) x)`, then call it `m` _more_ times as we pass
    that result into `(m f)`.
|#
(define (add n)
    (lambda (m)
        (lambda (f)
            (lambda (x)
                ((m f) ((n f) x))))))

#|
For testing, here's a helper to show that these numbers are really doing the right thing. We call
the Church numeral with 1.) an `f` that increments its input and 2.) an initial value of `0`,
basically mapping from the Church numeral right back to a familiar number.

Should work in the REPL:
* `(to-number two)` => 2
* `(to-number ((add one) two))` => 3
* etc.
|#
(define (to-number n)
    ((n (lambda (x) (+ x 1))) 0))

#|
I wanted to keep playing with this stuff outside of the book's exercises --
see ./more-lambda-arithmetic.scm for multiplication and subtraction, and
./more-lambda-booleans.scm for booleans and control flow.
|#
