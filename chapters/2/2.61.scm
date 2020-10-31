#|
Sets as ordered lists: the book gives us `element-of-set?` and `intersection-set`,
in which we take advantage of ordering to speed up set operations vs. an unordered
(but unique) list.
* In `element-of-set?`, we go from scanning the entire set (list) to scanning only
    the subset that's smaller than x. On average, this looks like O(N/2) instead
    of O(N) -- a modest improvement, still basically O(N).
* In `intersection-of-set`, the ordering really shines. If both lists were unordered,
    finding the intersection would look like taking every item from one set (O(N))
    and checking if it's an element of the other (O(N^2)). If both sets are ordered,
    we can compare the smallest items from each. When they match, they belong in
    the intersection. When they do not match, we know that the smaller of the two
    _cannot_ be part of the intersection, because it must be smaller than the rest
    of the other set. We discard it and take the next smallest item. This means
    we basically check each entry in both sets once: O(N)!
|#
(define (element-of-set? x set)
    (cond ((null? set)
            false)
          ((= x (car set))
            true)
          ((< x (car set))
            false)
          (else
            (element-of-set? x (cdr set)))))

(define (intersection-set set1 set2)
    (if (or (null? set1) (null? set2))
        '()
        (let ((x1 (car set1))
              (x2 (car set2)))
            (cond ((= x1 x2)
                    (cons x1 (intersection-set (cdr set1)
                                               (cdr set2))))
                  ; Since x1 and x2 are both the smallest items in their respective
                  ; sets, we know that if x1 < x2, x1 < any item in set2 and is
                  ; therefore not in the intersection.
                  ((< x1 x2)
                    (intersection-set (cdr set1) set2))
                  ((> x1 x2)
                    (intersection-set set1 (cdr set2)))))))

; --------------------------------------------------------------------------------------------------
; Problem: implement `adjoin-set` with this ordered representation, in a way that requires half the
; steps (on average) of the unordered version:
; --------------------------------------------------------------------------------------------------

(define (adjoin-set item set)
    (if (null? set)
        (list item)
        (let ((next-in-set (car set)))
            (cond ((= item next-in-set)
                    set)
                  ((< item next-in-set)
                    (cons item set))
                  (else
                    (cons next-in-set (adjoin-set item (cdr set))))))))
