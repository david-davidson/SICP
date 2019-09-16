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
; From there, we're asked to define `one` and `two` directly (not in terms of `zero` and`add-one`):
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

; --------------------------------------------------------------------------------------------------
; In addition to the book's exercises, two more: first, multiplication
; --------------------------------------------------------------------------------------------------

#|
While addition boils down to "invoke `f` `n` times and then `m` more times," multiplication boils
down to  "invoke `f` `n` times, then take that whole process and repeat it `m` times."  Since our
whole notion of numbering is based on repeated function calls, we can easily achieve that second-
order repetition:
* `(n f)` returns a lambda that'll invoke `f` `n` times.
* `(m (n f))` returns _another_ lambda that'll invoke `(n f)` `m` times.
* `((m (n f)) x)` kicks off the second lambda, invoking `f` `n * m` times.
|#
(define (multiply n)
    (lambda (m)
        (lambda (f)
            (lambda (x)
                ((m (n f)) x)))))

; --------------------------------------------------------------------------------------------------
; Finally, a tough one: subtraction
; --------------------------------------------------------------------------------------------------

#|
In a world where counting takes place through repeated function calls, addition is straightforward,
but subtraction is challenging: we need to somehow execute `f` _fewer_ times. The only approach I
can see is to track state from previous invocations, then grab a previous state entry.

I find this easiest to reason about by starting with the simpler problem of decrementing, then
building up from there. When decrementing, we don't need _that_ much state: just the current value
and the previous one. That's easy to express in pairs of the shape `(current, previous)`.

So, we define a inner function that builds successive pairs by 1.) calling `f` with the first entry,
and 2.) setting the second entry to the first. Assuming a hypothetical initial value of `0`, and an
`f` that simply increments, that looks like: `(0, 0)` -> `(1, 0)` -> `(2, 1)` -> etc. The effect is
the equivalent of the `(f (f (f...)))` sequence from other numbers, but with a handle on the
previous value.

Having defined that inner function (`iter`), and having defined an initial pair with `(cons x x)`,
we pass both into our number function, `n`. As always, `n` executes `iter` multiple times,
producing a final pair. We return the pair's second entry, for `n - 1`.
|#
(define (decrement n)
    (lambda (f)
        (lambda (x)
            (define (iter pair)
                (cons (f (car pair))
                      (car pair)))
            (let ((initial-pair (cons x x)))
                (let ((final-pair ((n iter) initial-pair)))
                    (cdr final-pair))))))

#|
Now that we have a `decrement` helper to work with, the problem of subtraction is a lot less
complicated: rather than trying to invoke a function _fewer_ times, we're back to invoking
`decrement` once for each value we're subtracting.
* `(m decrement)` returns a function that calls `decrement` `m` times.
* `((m decrement) n)` starts from the initial value `n` and decrements `m` times, passing each
    result into the next `decrement` call.
|#
(define (minus n)
    (lambda (m)
        ((m decrement) n)))

#|
Note that `minus` is quite computationally expensive: to calculate `((minus 10) 9)`, we first build
up from 0 to 10, then decrement to 9. Then we build up _again_ from 0 to 9, decrement to 8, and so
on all the way down to 1.

Here's a better version that builds up once, then counts down once. Rather than tracking pairs, it
tracks a complete list of intermediate values up to `n`. Then it pops values off the list `m`
times, and finally returns the head of the list.

Now that we're dealing with named helper functions and Lisp-specific data structures, we're no
longer in the land of pure lambda calculus, where the only primitive is the function. But these
abstractions just make things easier to follow: the named functions could be inlined, and you can
make pairs (and therefore lists) out of functions. At the end of the day, we're still doing
arithmetic with nothing but functions!
|#
(define (minus-better n)
    (lambda (m)
        (lambda (f)
            (lambda (x)
                (define (build-list nums)
                    (cons (f (car nums))
                          nums))
                (define (tail-list nums)
                    (cdr nums))
                (let ((initial-list (list x)))
                    (let ((full-list ((n build-list) initial-list)))
                        (let ((remaining-list ((m tail-list) full-list)))
                            (car remaining-list))))))))

#|
For testing, here's a helper to show that these numbers are really doing the right thing. We call
the Church numeral with 1.) an `f` that increments its input and 2.) an initial value of `0`,
basically mapping from the Church numeral right back to a familiar number.

Should work in the REPL:
* `(to-number two)` => 2
* `(to-number ((add one) two))` => 3
* `(to-number ((multiply two) ((add one) two)))` => 6
* `(to-number ((multiply three) ((minus four) one)))` => 9
* etc.
|#
(define (to-number n)
    ((n (lambda (x) (+ x 1))) 0))
