#|
This code uses *successive squaring* to calculate exponentials. e.g., to reach b^8, we don't do
this: b x (b x (b x (b x (b x (b x (b x b))))))
Instead, we do this:
    b^2 = b x b
    b^4 = b^2 x b^2
    b^8 = b^4 x b^4

While naive exponentiation (the first version) is O(N) in both time and space, the version with
successive squaring is O(log(N))
|#

(define (expt-recur b n)
    (cond ((= n 0) 1)
          ((even? n) (square (expt-recur b
                                         (/ n 2))))
          (else (* b (expt-recur b
                                 (- n 1))))))

(define (even? n)
    (= (remainder n 2) 0))

; --------------------------------------------------------------------------------------------------
; Exercise: express successive squaring in an iterative algorithm
; --------------------------------------------------------------------------------------------------

#|
I struggled with this one -- my thought was to build _up_ in a 2, 4, 8... sequence, stop once the
_next_ doubling would pass the target exponent, and cover the remaining distance with a linear path.
That works fine, but the last step -- covering the last less-than-double with linear iteration --
makes for not-great perf. The worst-case scenario is an exponent like 15, where it's just one below
a power of 2, meaning our sequence is 2, 4, 8, 9, 10, 11, 12, 13, 14, 15. We iterate linearly over
half the path, meaning our order of growth is (precisely) .5(O(log(N))) + .5(O(N)), or (more or
less) O(N).
|#

(define (expt-iter b n)
    (define (square-iter current-power product)
        (let ((next-power (* 2 current-power))
              (next-product (* product product)))
             (cond ((= next-power n) next-product)
                   ((< next-power n) (square-iter next-power next-product))
                   (else (linear-iter current-power product)))))
    (define (linear-iter counter product)
        (if (= counter n)
            product
            (linear-iter (+ counter 1)
                         (* b product))))
    (if (= n 0) 1
        (square-iter 1 b)))

#|
The problem is that building _up_ will never be as efficient as dividing _down_, where the worst-
case scenario is that we land on an odd number, iterate by 1, and keep dividing. This is bound to
happen plenty of times, but it's not as bad as the worst-case scenario of iterating over nearly half
the distance. You can verify with the paths to, say, 15:
* doubling up:      2, 4, 8, 9, 10, 11, 12, 13, 14, 15
* dividing down:    15, 14, 7, 6, 3, 2

But, even once we know dividing down is faster, how can we express exponentiation in reverse order
without deferring work? One option (skipping ahead to data structures not yet taught) would be to do
two passes: first, divide _down_ to find the shortest path, `cons`-ing it into a list. Then, iterate
_up_ the list and build the product. This ought to work, but I don't think it's a meaningful
improvement either, because -- even as we save space by avoiding linear recursion -- we consume the
same space (O(log(N))) with the variable that tracks the list.

I found the following clever implementation online. It divides down and manages to build up the
correct exponent in a single pass, with no list variable. It handles odd numbers intuitively, but on
even ones, it leaves `product` alone, squares `b` instead, and divides down. e.g, here's the
sequence of arguments to `iter` resulting from `(expt-iter-faster 2 5)`:
    1, 2, 5
    2, 2, 4
    2, 4, 2
    2, 16, 1
    32, 16, 0 ; returns 32
|#

(define (expt-iter-faster b n)
    (define (iter a b n)
        (cond ((= n 0) a)
              ((even? n) (iter a
                               (square b)
                               (/ n 2)))
              (else (iter (* a b)
                          b
                          (- n 1)))))
   (iter 1 b n))

#|
EDIT: this "clever" solution was, in fact strongly hinted at in the book--I just missed it there!
It follows from the observation that `(b^(n/2))^2 = (b^2)^(n/2)`; SICP recommends adding the
`a` variable such that the product `a(b^n)` remains constant iteration over iteration.
|#
