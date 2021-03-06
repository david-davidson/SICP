# Notes

### 2.1.0
**Data abstraction** enables us to separate how data is used from the particulars of how it is constructed and represented. Our programs can operate on "abstract data," with the concrete data implementation hidden. **Selectors** and **constructors** read from and write to the concrete data representation. They form **abstraction barriers**, beyond which implementation details can be ignored.

**Compound data** ("glued" together as a conceptual unit) relies on the **closure property**, in which the results of an operation can themselves be combined using the same operation (e.g., a `cons` pair can be an element in another pair). (Here, "closure" is unrelated to the more familiar scope-related term.)

### 2.1.3
Church numerals, from the lambda calculus, represent numbers via functions. (Indeed, the lambda calculus can express _all computation_ via functions.) A church numeral has the signature `f -> x -> any`, where `f` is an arbitrary function and `x` is an arbitrary value. A numeral representing the value `n` simply invokes `f` `n` times, starting with `x` as the input and passing the result through the remaining calls to `f`. (The final return value is `any` because we have no notion of what `(f x)` returns in the first place, let alone `(f (f x))` or larger numbers.)

For example:
```scm
(define zero (lambda (f)
    (lambda (x) x))) ; No calls to `f`

(define one (lambda (f)
    (lambda (x)
        (f x)))) ; One call to `f`

(define two (lambda (f)
    (lambda (x)
        (f (f x))))) ; Two calls to `f`
```
See [2.6.scm](2.6.scm) for the book's code challenges, plus [more-lambda-arithmetic.scm](more-lambda-arithmetic.scm) for multiplication/subtraction and [more-lambda-booleans.scm](more-lambda-booleans.scm) for booleans and control flow.

SICP notes—and the lambda calculus demonstrates—that higher-order functions (and closures, in the modern sense) are enough of a basis to model compound data.

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

### 2.3.3
This section implements sets first as unordered lists, then as ordered lists, then as binary search trees—each time with an improvement in performance. The tree implementation is particularly cool because (as a footnote mentions) we're implementing sets in terms of trees, and trees in terms of lists—a testament to the power of data abstraction. See problems [2.61](2.61.scm) through [2.65](2.65.scm).

### 2.3.4
After describing sets and trees as abstractions on top of lists, the book uses Huffman encoding as the basis for several exercises ([2.67](2.67.scm), [2.68](2.68.scm), [2.69](2.69.scm)). The use case is fascinating; I wrote about it [here](https://daviddavidson.website/huffman-encoding/).
