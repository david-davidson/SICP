#|
The following code calculates the number of different ways to make change, using USD coins (half-
dollars, quarters, dimes, nickels, and pennies), for arbitrary amounts of money.

It relies on the following logic: the number of ways to change amount `a` using `n` kinds of coins
equals
* The number of ways to change `a` using _all but the first kind of coin_, plus
* The number of ways to change `a - d` using all `n` kinds of coins, where `d` is the denomination
    of the first kind of coin

(TBH, I can't quite wrap my head around why this logic works.)
|#

; `amount` is in cents: 100 means 1 dollar
(define (count-change amount)
    (count-change-recur amount 5))

(define (first-denomination num-kinds-of-coins)
    (cond ((= num-kinds-of-coins 1) 1)
          ((= num-kinds-of-coins 2) 5)
          ((= num-kinds-of-coins 3) 10)
          ((= num-kinds-of-coins 4) 25)
          ((= num-kinds-of-coins 5) 50)))

(define (count-change-recur amount num-kinds-of-coins)
    (cond ((= amount 0) 1)
          ((or (< amount 0) (= num-kinds-of-coins 0)) 0)
          (else (+ (count-change-recur amount
                                       (- num-kinds-of-coins 1))
                   (count-change-recur (- amount
                                          (first-denomination num-kinds-of-coins))
                                       num-kinds-of-coins)))))

; --------------------------------------------------------------------------------------------------
; What is the time and space complexity of this approach?
; --------------------------------------------------------------------------------------------------
#|
`count-change-recur` is tree-recursive, so we know its perf characteristics won't be good. First,
time complexity:

Starting from the base case, `(count-change-recur n 1)` generates a tree where each level spawns two
more nodes: one to `(count-change-recur n 0)`, and one to `(count-change-recur (- n 1) 1)`. (Since
we have only one kind of coin, its denomination is 1.) The former node is terminal; the latter
generates another pair. Thus, when `num-kinds-of-coins` is 1, the steps required are O(N), where N
is the value passed in for `amount`.

Now, `(count-change-recur n 2)`: we're allowed to use two coins, one of denomination 1 and one of 5.
Each level spawns a subtree for `(count-change-recur n 1)`, and another for `(count-change-recur
(- n 5) 2)`. There'll be n/5 levels. _Each of these levels_ spawns a subtree that's already shown to
be O(N), so the total time complexity is O(N^2).

Continuing with this exercise shows that, in general, space complexity is O(N^<num-kinds-of-coins>)!
Thus, the implementation above is O(N^5). 😬
More here: http://www.ysagade.nl/2015/04/12/sicp-change-growth/

Meanwhile, the memory consumption of a tree-recursive function is determined by the depth of the
tree, and that in turn is determined by the recursion through decrementing values of
`num-kinds-of-coins`. The worst-case scenario there is decrementing by 1. So, memory usage is O(N),
where N is again `amount`.
|#
