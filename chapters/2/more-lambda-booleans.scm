#|
The starting place for Church booleans is how booleans are _used_: choosing between branching code
paths. A pseudocode ternary, for example, starts with a boolean and returns one path or the other:
`someCondition ? someReturnValue : otherReturnValue` .

Church booleans are, of course, functions--but they have a similar signature. A boolean `bool` looks
like `((bool on-true) on-false)`, and it simply returns one of its two curried arguments: the first
to signify true, the second to signify false.

As it happens, here we begin to overlap greatly with the world of combinators as building blocks --
https://github.com/david-davidson/to-mock-a-mockingbird looks at combinators in greater
detail. Here, we'll use the famous bird nicknames from Smullyan.

Before even addressing booleans, let's start with two of the basic combinators:
|#

; The I combinator, aka (unfortunately) Idiot Bird, aka identity
(define (I x) x)

; The K combinator, aka Kestrel, aka first/const
(define (K x)
    (lambda (y) x))

#|
We already have enough here to be productive! The Kestrel returns its first argument, just like
Church booleans return their first argument to signify true. That means the Kestrel _is_ our `true`.
(You've probably used it many times as the `first` or `const` util.)

To build `false`/`second`, we need something like `(lambda (on-true) (lambda (on-false) on-false))`:
a function that always returns its second argument. As it happens, we can build that using just `K`
and `I`. Like this: `((K I) y) => (I y) => y`. (`(K I)`, by the way, is the KI combinator, or Kite.)

The latter form isn't as "obvious," but it's theoretically interesting in that it helps us reason
about what the minimal base of combinators is that can express arbitrary computation.

Here's something else that's interesting, even wonderful: recall that the Church numeral for zero is
`(lambda (f) (lambda (x) x))`. Just like 0 is falsey in just about every programming language, the
Church encodings for zero and false are the exact same function!
|#

(define true K)

(define false (K I))

; Let's also set up a helper that works in the REPL: e.g., `(to-boolean false)` => "false"
(define (to-boolean bool)
    ((bool "true") "false"))

#|
So far, so good. What do we want to do with booleans? For starters:
* If-statements
* Negation
* And/or operations
* Equality checks

Let's start with if-statements. Church booleans already own the logic of choosing a code path
depending on truthiness; they _already do the work_ of a traditional if-statement. So, `if` is just
syntactic sugar that lets us forget about the odd signature of Church booleans:
```
(define (if boolean)
    (lambda (on-true)
        (lambda (on-false)
            ((boolean on-true) on-false))))
```
But note that `(if boolean)` returns a function with the exact signature of the boolean it receives.
That means that `if` does so little work that we can just use identity:
|#

(define if I)

#|
Negation is more interesting: we want to go from `true` to `false` and vice versa. That amounts to
changing which callback each boolean invokes. We can't modify the internals of the primitive
booleans, but we can _call them_ with the `on-true` and `on-false` arguments reversed. Like this:
|#

(define (not-verbose bool)
    (lambda (on-true) ; Return a brand-new bool, and follow standard argument order...
        (lambda (on-false) ; ...Still standard argument order...
            ((bool on-false) on-true)))) ; ...Reverse order!

#|
As it happens, that's another of the standard combinators: the Cardinal, aka "flip," which takes
a function, takes two args, and invokes the function with those arguments reversed.
|#

(define (C f)
    (lambda (x)
        (lambda (y)
            ((f y) x))))

#|
So, just like we used `K` for true and `(K I)` for false, we can use `C` for negation.
|#

; In the REPL: `(to-boolean (not true))` => "false"
(define not C)

#|
How about `and` and `or`? Here's `and`:
|#

(define (and x)
    (lambda (y)
        ((x y) x)))

#|
Assume `x` is true. If so, we know it'll invoke its first argument, and the only thing left to know
is whether `y` is _also_ true. So, we can pass `y` into `x` as the truthy first argument. If `y` is
also true, `and` will return true; if either `x` or `y` is false, `and` will return false.

`or` is pretty similar. Assume `x` is true. That's already enough for `or` to return true, so in
that case, `x` can return itself as the truthy first argument. If `x` is false, the only thing left
to learn is whether `y` is true, so we can return `y`.
|#

(define (or x)
    (lambda (y)
        ((x x) y)))

#|
Finally, here's a boolean equality check. Like `and` and `or`, it makes the most sense if we start
by considering what happens if `x` is true. In that case, just like `and`, we only care whether `y`
is also true, so we can return `y`.

If `x` is false, we need to know whether `y` is false. If `y` is false, `or` should return true; if
`y` is true, `or` should return false. That is, the return value (when `x` is false) is the reverse
of `y`. So, we just return `(not y)`!
|#

(define (eq x)
    (lambda (y)
        ((x y) (not y))))

; See also: ./more-lambda-arithmetic.scm!
