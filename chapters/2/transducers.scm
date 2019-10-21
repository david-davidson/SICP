#|
As a starting point, note that it's straightforward to implement `map` and `filter` in terms of
`reduce`--or, more accurately, `fold`. (The core different is that `reduce` uses the first list
entry as the initial value for the accumulator, while `fold` lets us explicitly set that initial
value.) In both cases, we accumulate entries into a new list--in `map`, with a transformation first;
in `filter`, with a boolean check.
|#
(define (map-DIY fn data)
    (fold (lambda (current total)
            (append total (list (fn current))))
          '()
          data))

(define (filter-DIY fn data)
    (fold (lambda (current total)
            (if (fn current)
                (append total (list current))
                total))
          '()
          data))

#|
The first argument to `fold`/`reduce` is a "reducer": a function with the signature `current,
total -> total`, where `total` is built up by each successive invocation.

A _transducer_ is a "higher-order reducer": a function with the signature `reducer -> reducer`. Now
that we know how to implement mapping and filtering in terms of reducers, we can modify them into
transducers. Then the signatures will line up in a way we can compose: `reducer -> reducer`,
`reducer -> reducer`.

To turn these operations into transducers, we want to:
*  Take a "next reducer" as an argument
* Rather than building up `total` directly, simply call that next reducer with the transformed value
|#

; (Curried to accept an iteratee function ahead of time, for convenience)
(define (map-transducer fn)
        ; The transducer signature begins here: we accept a reducer...
        (lambda (next-reducer)
            ; ... And return a reducer...
            (lambda (current total)
                ; ...That calls the next reducer after performing the `map` operation
                (next-reducer (fn current)
                              total))))

(define (filter-transducer fn)
    (lambda (next-reducer)
        (lambda (current total)
            ; Filter is similar, except we bail (when the predicate fails) by returning `total`, not
            ; passing `current` in to the next reducer
            (if (fn current)
                (next-reducer current total)
                total))))

; Let's add a `compose` util as well:
(define (compose . fns)
    (lambda (initial-val)
        (fold-right (lambda (fn intermediate-val)
                        (fn intermediate-val))
                    initial-val
                    fns)))

#|
How do we use these transducers? We can start by composing them, which lines up the output from each
into the `next-reducer` argument expected by the next one. The return value is still itself a
transducer, which means it's not _quite_ ready to use on lists.

The last step to make it useful is to invoke the composed function with an initial value for
`next-reducer`. Each transducer will pass its `lambda (current total)` return value into the next
one (as `next-reducer`). Our "initial" reducer will actually be the final step in the pipeline: the
steps in `composed-transducer` execute top-to-bottom, then feed into `initial-reducer`.
|#

; Define a handful of map/filter transformations to compose:
(define (times-two x) (* x 2))
(define (is-even? x) (= (remainder x 2) 0))
(define (is-greater-than-10? x) (> x 10))

; Compose individual transducers into a single transducer:
(define composed-transducer (compose (filter-transducer is-even?)
                                     (map-transducer times-two)
                                     (filter-transducer is-greater-than-10?)))

; Invoke it with initial reducer, building final, usable reducer:
(define (initial-reducer current total) (append total (list current)))
(define composed-reducer (composed-transducer initial-reducer))
; (fold composed-reducer '() '(1 2 3 4 5 6 7 8 9 10)) => (12 16 20)

#|
We're up and running!

Note how this works: we _seem_ to be filtering down to even numbers (`2, 4, 6, 8, 10`), multiplying
each times two (`4, 8, 12, 16, 20`), and filtering again to keep only those entries greater than 20.
But unlike regular `map` and `filter` operations, we're not building up intermediate lists for each
step. Instead, we're doing everything in a _single_ `fold` pass over the list!
|#
