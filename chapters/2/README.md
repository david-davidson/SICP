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
