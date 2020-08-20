#|
This one landed right at the edge of too math-y for me, but it's worth it because we're doing
something cool: finding Fibonacci numbers in O(log(N)), which I would not have expected to be
possible.

Here's how it works. The standard iterative Fibonacci tracks number pairs `a` and `b` and applies
a transformation to both on every iteration: `a <- a + b`, `b <- a`. Let's call that
transformation `T`. We apply it linearly: once per counter tick.

As it happens, `T` is just a special case in the family of transformations `Tpq`:
    Tpq(a, b) = a <- bq + aq + ap, b <- bp + aq
In the case of standard Fibonacci, `p` is 0 and `q` is 1. (Note that those values result in the
simpler `a <- a + b`, `b <- a` transformation we're familiar with.)

So here's the trick: to speed up iteration, we're going to do the same successive squaring thing
from the last couple exercises. Each time we halve the count, we want to square the transformation:
`Tpq(Tpq(a, b))`. Now, there exists a transformation `Tp'q'` that's equivalent to that nested call.
We want to solve for p' and q' and use them to transform the pair of numbers, as if we'd squared the
transformation. The challenge is to define `next-p` (p') and `next-q` (q') in the below algorithm.
|#

(define (fib n)
    (define (iter a b p q count)
        (cond ((= count 0) b)
              ((even? count) (let ((next-p (+ (square p) (square q)))
                                   (next-q (+ (* 2 p q) (square q))))
                                  (iter a
                                        b
                                        next-p ; Challenge: determine what `next-p` should be...
                                        next-q ; ... And `next-q`
                                        (/ count 2))))
              (else (let ((next-a (+ (* b q) (* a q) (* a p)))
                          (next-b (+ (* b p) (* a q))))
                         (iter next-a
                               next-b
                               p
                               q
                               (- count 1))))))
    (iter 1 0 0 1 n))


#|
Here are the steps to solve for p' and q'. Let's start with the standard algorithm:
T(a, b) =       bq + aq + ap,
                bp + aq

Now let's use the transformed values of a and b to populate the equation, as if we'd run it on
itself:
T(T(a, b)) =    (bp + aq)q + (bq + aq + ap)q + (bq + aq + ap)p,
                (bp + aq)p + (bq + aq + ap)q

We can multiply p and q through...
T(T(a, b)) =    bpq + aq^2 + bq^2 + aq^2 + apq + bqp + aqp + ap^2,
                bp^2 + aqp + bq^2 + aq^2 + apq

...And group the a and b components:
T(T(a, b)) =    bpq + bq^2 + bqp + aq^2 + aq^2 + apq + aqp + ap^2,
                bp^2 + bq^2 + aqp + aq^2 + apq

Now, starting with the second term (next-b), let's pull b and a out. The remaining terms are the new
values for p' and q':
T(T(a, b)) =    bpq + bq^2 + bqp + aq^2 + aq^2 + apq + aqp + ap^2,
                b(p^2 + q^2) + a(qp + q^2 + pq)

We can do _mostly_ the same thing with the next-a term -- it's easy to pull b out. Notice how the
new q' value matches the one we found in next-b:
T(T(a, b)) =    b(pq + q^2 + qp) + aq^2 + aq^2 + apq + aqp + ap^2,
                b(p^2 + q^2) + a(qp + q^2 + pq)

Lastly, we pull a out of the remainder of next-a. This part isn't as clean as what we've done so
far, since we're looking for _two_ values (aq + ap). Luckily, we already have a good sense of what
q and p will be, and can plug in our candidates and make sure they work.
T(T(a, b)) =    b(pq + q^2 + qp) + a(q^2 + p^2) + a (q^2 + pq + qp),
                b(p^2 + q^2) + a(qp + q^2 + pq)

Simplifying (and grouping like terms such as `qp` and `pq`), we end up with tidy values for p'
and q':
p' = p^2 + q^2
q' = q^2 + 2pq
|#
