# Notes

## Streams
> We can describe the time-varying behavior of a quantity _x_ as a function of time _x(t)_. If we concentrate on _x_ instant by instant, we think of it as a changing quantity. Yet if we concentrate on the entire time history of values, we do not emphasize change—the function itself does not change.

A stream is simply a sequence (like a list) with delayed evaluation, which supports large (or infinite) structures. Streams let us model state immutably, as a series of values.

### 3.5.1
The vanilla sequence operations (`map`, `filter`, `accumulate`) come at the price of inefficiency, particularly over large data sets: in each transformation, we create and discard a new list.

As a straw man, let's compute the second prime in the interval from 10,000 to 1,000,000:
```scm
(car (cdr (filter prime?
                  (enumerate-interval 10000 1000000))))
```
This builds a list of almost a million items, filters it, and throws away almost all of it. (In a more imperative style, we would interleave enumeration and filtering, and bail early.)

With streams, we'll evaluate list items lazily, avoiding most of this work. We'll use stream equivalents to the standard sequence operations, like `stream-filter`—see [stream-basics.scm](stream-basics.scm) for implementations (though these primitives are built into Scheme).

The trick is that the `cdr` of a stream is evaluated not at _construction_-time (via `cons-stream`) but at _selection_-time (via `stream-cdr`). This happens via the special form `(delay <expr>)`, which "promises" to evaluate its expression later. In turn, `(force <delayed expr>)` performs that evaluation. (Note that both `delay` and `cons-stream` must be special forms: otherwise, under applicative-order evaluation, `(cons-stream x y)` would evaluate `y`, which is exactly what we wish to avoid!)

Let's step through that second-prime code again, this time with streams:
```scm
(stream-car (stream-cdr (stream-filter prime?
                                       (stream-enumerate-interval 10000 1000000))))
```
`stream-filter` (see [stream-basics.scm](stream-basics.scm)) tests the `car` and, in case of failure, keeps recursing down the input stream, each time forcing the `cdr`. The input stream (produced by `stream-enumerate-interval`) first looks like:
```scm
(cons 10000
      (delay (stream-enumerate-interval 10001 1000000)))
```
One step later, it looks like:
```scm
(cons 10001
      (delay (stream-enumerate-interval 10002 1000000)))
```
...and so on. With each tick (where the filter predicate fails), `stream-filter` and `stream-enumerate-interval` advance a step, bouncing control back and forth.

When `stream-filter` reaches 10,007, though, it finds a prime and "stops," returning...
```scm
(cons-stream (stream-car seq)
             (stream-filter pred (stream-cdr seq)))
```
...to `stream-cdr` in the original expression. (The first item in the `cons-stream` pair is 10,007; the second, the promise of further evaluation.) `stream-cdr` forces that second item—the delayed `stream-filter` call—which resumes forcing `stream-enumerate-interval` until it finds another prime: 10,009. This gets returned to the outermost `stream-car`, which returns our answer!

As _SICP_ puts it,
> we can think of delayed evaluation as "demand-driven" programming, whereby each stage in the stream process is activated only enough to satisy the next stage.

But note that the order of operations here is not _fully_ "demand-driven" (or "outside-in"): above, the first code that runs is `stream-enumerate-interval` and `stream-filter`, together incrementally forcing the stream until that first prime. At the first prime, `stream-cdr` runs, followed by another enumerate/filter sequence until the second prime, after which `stream-car` completes. So, we're still running _somewhat_ "inside-out," as under strict evaluation. Unlike strict evaluation, though, this version iterates through only the nine items it needs, not the million-item list.

### 3.5.2: infinite streams
Since we never deal with the whole of a stream, we can represent infinite sequences:
```scm
; 1, 2, 3, 4...
(define (integers-starting-from n)
    (cons-stream n (integers-starting-from (+ n 1))))

(define (fibs)
    (define (fib-stream a b)
        (cons-stream a (fib-stream b (+ a b))))
    (fib-stream 0 1))
(stream-ref (fibs) 10) ; The 10th Fibonacci number: 55
```
See [sieve.scm](sieve.scm) for a really cool example of an infinite stream of primes.

You can also define streams _implicitly_, in terms of themselves:
```scm
(define ones (cons-stream 1 ones))
```

More interestingly, we can take advantage of the fact that `map` (and `stream-map`), when called with multiple list arguments, call the passed function element-wise on _both_, returning a single list. This lets us add streams, even ones defined in terms of themselves:
```scm
(define (add-streams seq1 seq2)
    (stream-map + seq1 seq2))

(define integers (cons-stream 1 (add-streams ones integers)))
```
This is fairly mind-bending code: at first, `integers` is a stream with the `car` 1 and the `cdr` of more (delayed) integers. When you force that `cdr`, `add-streams` runs, taking the first element off `ones` (1) and `integers` (1). The element-wise addition returns 2. When you force `integers` again, `add-streams` takes the _second_ element off `ones` (1) and `integers` (the 2 we just calculated): 3. And so on.

We can even do this with Fibonaccis, represented here as a stream beginning with 0 and 1 and generated by adding `fibs` to itself (offset by 1):
```scm
(define fibs (cons-stream 0
                          (cons-stream 1
                                       (add-streams fibs
                                                    (stream-cdr fibs)))))
```
### 3.5.3: exploiting stream paradigms
In [exercise 1.7])(../1/1.7.scm), we found square roots by iteratively improving a guess, represented as a state variable. With streams, we can generate those guesses as a stream, using the same trick of "stream that starts with 1 and maps over itself, offset by 1"...
```scm
(define (sqrt-improve guess x)
    (average guess (/ x guess)))

(define (sqrt-stream x)
    (define guesses (cons-stream 1.0
                                 (stream-map (lambda (guess)
                                    (sqrt-improve guess x))
                                 guesses)))
    guesses)
```

...Or express a stream of better and better approximations of pi:
```scm
; From formula π/4 = 1 - 1/3 + 1/5 - 1/7 + ...
(define pi-stream (scale-stream (partial-sums (pi-summands 1))
                                4))
```
(☝️ See [pi.scm](pi.scm) for the full implementation of this.)

That pi stream converges on pi correctly but slowly: the 10th and 11th values are bound betweeen `3.0418...` and `3.2323...`. One interesting thing we can do is transform the stream with a *sequence accelerator*, which converts a sequence of approximations to a new sequence that converges on the same value, only faster.

Euler offers a formula for this, well-suited for sequences (like `pi-summands` above) that are partial sums of series with alternating signs. If `S(n)` is the `nth` item in the original sequence, the accelerated sequence matches:
```
S(n+1) = ((S(n+1) - S(n)) ^ 2) /
         (S(n - 1) - 2(S(n)) + S(n + 1))
```
As it happens, we can do two fascinating things:
* Map this transformation over `pi-stream` to create a new, accelerated stream
* Accelerate the stream recursively: create a "tableau" (stream of streams) where each stream accelerates its predecessor
See [sequence-accelerators.scm](sequence-accelerators.scm) for implementation!
