#|
2.63 introduces the notion of sets as binary search trees, where the root is an
entry, the left subtree is all smaller entries, and the right subtree is all greater
entries. Unsurprisingly, we can represent such trees as lists, where the entry
is the first item, the left subtree the second, and the right subtree the third.
|#

(define (make-tree entry left-subtree right-subtree)
    (list entry left-subtree right-subtree))

(define (entry tree)
    (car tree))

(define (left-branch tree)
    (cadr tree))

(define (right-branch tree)
    (caddr tree))

#|
Ordering our lists took operations like `element-of-set?` from O(N) to O(N/2) --
still in the ballpark of O(N). But the tree representation lets us take performance
to O(log(N)), because with each branch, we halve the remaining work.

`element-of-set?` and `adjoin-set` take a similar approach: traverse the tree
until we either find a match or reach the end of the tree.
|#

(define (element-of-set? x set)
    (cond ((null? set)
            false)
          ((= x (entry set))
            true)
          ((< x (entry set))
            (element-of-set? x (left-branch set)))
          (else
            (element-of-set? x (right-branch set)))))

(define (adjoin-set x set)
    (cond ((null? set)
            (make-tree x '() '()))
          ((= x (entry set))
            set)
          ((< x (entry set))
            (make-tree (entry set)
                       (adjoin-set x (left-branch set))
                       (right-branch set)))
          (else
            (make-tree (entry set)
                       (left-branch set)
                       (adjoin-set x (right-branch set))))))

#|
But note that our assumption of O(log(N)) performance only works when the tree is balanced: you can
imagine trees made up of nothing but (say) right branches, where performance becomes once again linear.
To address this, we'll need to periodically balance the tree. This looks like 1.) converting it to a
list and 2.) converting the list back into a balanced tree.
|#

; --------------------------------------------------------------------------------------------------
; Problem: both of these functions transform a tree into a list. Do they produce the same result?
; Do they have the same order of growth?
; --------------------------------------------------------------------------------------------------

(define (tree->list tree)
    (if (null? tree)
        '()
        (append (tree->list (left-branch tree))
                (cons (entry tree)
                      (tree->list (right-branch tree))))))

(define (tree->list2 tree)
    (define (copy-to-list tree results)
        (if (null? tree)
            results
            (copy-to-list (left-branch tree)
                          (cons (entry tree)
                                (copy-to-list (right-branch tree)
                                              results)))))
    (copy-to-list tree '()))

#|
I found this exercise a littlefrustrating, because I read it as hinting that there was in fact some
difference in output. But after looking at (and playing with) both, I think they produce the same result:
an ordered list of tree entries, left->right.

From a completely abstract point of view (setting aside the underlying language, focusing only on the
algorithm), they have the same order of growth, which is O(N): they visit every entry in the tree. The
difference between them is that the first uses `append` to build up results, while the second uses `cons`.
As we saw earlier in chapter 2, `append` works by looping over one of its lists, so it itself is O(N).
That makes the first approach O(N^2) in practice.
|#
