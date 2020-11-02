(load "chapters/2/2.61.scm") ; To import `intersection-set`
(load "chapters/2/2.62.scm") ; To import `union-set`
(load "chapters/2/2.63.scm") ; To import `tree->list`
(load "chapters/2/2.64.scm") ; To import `list->tree`

; --------------------------------------------------------------------------------------------------
; Problem: give O(N) implementations of `union-set` and `intersection-set` for sets implemented as
; balanced BSTs.
; --------------------------------------------------------------------------------------------------

(define (union-set-tree set1 set2)
    (list->tree (union-set (tree->list set1)
                           (tree->list set2))))

(define (intersection-set-tree set1 set2)
    (list->tree (intersection-set (tree->list set1)
                                  (tree->list set2))))

#|
By now, we already have all the tools we need here; we just need to stitch them together, which is
what the problem is about.

Of course, the other approach would be to write versions of these functions that deal with the tree
structure directly. I'm not actually sure that's possible within the O(N) constraint. Take union,
for example: naively, we might `adjoin-set` (log(N)) each item from one set into another, but that's
O(Nlog(N)). And I'm not sure we can take advantage of tricks like we did in `intersection-set` and
`union-set`, where the sorted list structure makes taking the smallest item an O(1) operation. The
tree version optimizes for reaching _any node_ in the shortest time (O(log(N)) rather than O(N)),
while the list version optimizes for reaching _the smallest node_ in the shortest time (O(1) rather
than O(log(N))). I suspect the latter optimization is the best fit for unions and intersections.
|#
