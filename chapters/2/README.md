# Notes

### 2.1.3
Church numerals, from the lambda calculus, represent numbers via functions. (Indeed, the lambda calculus can express _all computation_ via functions.) A church numeral has the signature `f -> x -> any`, where `f` is an arbitrary function and `x` is an arbitrary value. A numeral representing the value `n` simply invokes `f` `n` times, starting with `x` as the input and passing the result through the remaining calls to `f`. (The final return value is `any` because we have no notion of what `(f x)` returns in the first place, let alone `(f (f x))` or larger numbers.)

For example:
```scm
(define zero (lambda (f)
    (lambda (x)
        x))) ; No calls to `f`

(define one (lambda (f)
    (lambda (x)
        (f x)))) ; One call to `f`

(define two (lambda (f)
    (lambda (x)
        (f (f x))))) ; Two calls to `f`
```
See [2.6.scm](2.6.scm) for the book's code challenges, plus [more-lambda-arithmetic.scm](more-lambda-arithmetic.scm) for multiplication/subtraction and [more-lambda-booleans.scm](more-lambda-booleans.scm) for booleans and control flow.

### 2.2.3
SICP uses the term "transducer," from [signal processing](https://en.wikipedia.org/wiki/Transducer), as a metaphor for how `map` transforms elements of a list. This is interesting, because "transducer" has picked up additional meaning over the years. I detoured from the book a little to implement transducers (in the modern sense) in Scheme.

In large parts _thanks_ to Scheme and other Lisps, we're all familar with `map`:
```scm
(define (square x) (* x x))
(map square '(1 2 3 4 5)) ; (1 4 9 16 25)
```
and `filter`:
```scm
(define (is-even? x) (= (remainder x 2) 0))
(filter is-even? '(1 2 3 4 5)) ; (2 4)
```
One of the interesting things about `map` is that you can express a pipeline of _successive_ `map` operations (say, first multiplying all entries by ten, then adding one) as a _single_ `map` operation that combines all operations. Here we feed the result of the first `map` into the second:
```scm
(map plus-one (map times-ten '(1 2 3))) ; (11 21 31)
```
And here (with the help of a `compose` utility that feeds the result of one function into the next) we perform a single `map` pass:
```scm
(map (compose plus-one times-ten) '(1 2 3)); (11 21 31)
```
That guarantee comes from category theory, which states that, given transformations `a -> b` and `b -> c`, the single transformation `a -> c` is equivalent. All you need is to make sure the types line up.

But what if you want to compose `map` and `filter` operations?
```scm
(map (compose plus-one is-even?) '(1 2 3))
```
This breaks immediately, because `is-even?` returns a boolean and `plus-one` expects an integer. The types can't be chained: `integer -> boolean`, `integer -> integer`.

That's where transducers come in: they express `map` and `filter` in terms of `reduce`, in a way that lets you compose _all_ the operations into a single pass over the list. As a result, transducers are a good fit for lists that are extremely large, or even asynchronous/lazy. Check out [transducers.scm](transducers.scm) to see how they work.
