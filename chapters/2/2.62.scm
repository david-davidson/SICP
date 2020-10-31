; --------------------------------------------------------------------------------------------------
; Problem: implement `union-set` for sets represented as ordered lists, with O(N) performance
; --------------------------------------------------------------------------------------------------

#|
A more intuitive, less performant approach would look like: append set 1 and the filtered subset of
set 2 that doesn't overlap. That violates the O(N) requirement by calling `element-of-set?` once for
every entry in set 2, which is O(N^2). Instead, we can take our cues from the sorted `intersection-set`
and look for an approach that compares set entries element-wise.

Knowing that the sets are sorted, we can compare the two first (smallest) entries. We take the
smaller of the two, 1.) push it into results, and 2.) remove it from the remainder of the set to be
processed. When two entries are equal, we push once into results but remove from *both* sets.

Like this--

initial data:
    set 1: {1 3 5 6}
    set 2: {2 5 9}
    results: {}

1 < 2:
    set 1: {3 5 6}
    set 2: {2 5 9}
    results: {1}

2 < 3:
    set 1: {3 5 6}
    set 2: {5 9}
    results: {1 2}

3 < 5:
    set 1: {5 6}
    set 2: {5 9}
    results: {1 2 3}

5 = 5:
    set 1: {6}
    set 2: {9}
    results: {1 2 3 5}

6 < 9:
    set 1: {}
    set 2: {9}
    results: {1 2 3 5 6}

when one set is empty, append other to results:
    final results: {1 2 3 5 6 9}
|#

(define (union-set set1 set2)
    (cond ((null? set1)
            set2)
          ((null? set2)
            set1)
          (else
            (let ((next1 (car set1))
                  (next2 (car set2)))
                (cond ((= next1 next2)
                        (cons next1 (union-set (cdr set1) (cdr set2))))
                      ((< next1 next2)
                        (cons next1 (union-set (cdr set1) set2)))
                      (else
                        (cons next2 (union-set set1 (cdr set2)))))))))
