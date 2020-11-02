(load "chapters/2/2.63.scm") ; To import `make-tree`

#|
SICP gives us the following two functions: `list->tree` converts an ordered list to a balanced
binary tree, and its helper `partial-tree` does the actual algorithmic work.
|#

(define (list->tree elements)
    (car (partial-tree elements (length elements))))

; Returns a pair with 1.) the first `n` elements of `elements` as a balanced tree, and 2.) the
; remaining elements to be processed
(define (partial-tree elements n)
    (if (= n 0)
        (cons '() elements)
        (let ((left-size (quotient (- n 1) 2)))
            (let ((left-result (partial-tree elements left-size)))
                (let ((left-tree (car left-result))
                      (non-left-elements (cdr left-result))
                      (right-size (- n (+ left-size 1))))
                    (let ((this-entry (car non-left-elements))
                          (right-result (partial-tree (cdr non-left-elements) right-size)))
                        (let ((right-tree (car right-result))
                              (remaining-elements (cdr right-result)))
                            (cons (make-tree this-entry left-tree right-tree)
                                  remaining-elements))))))))

; --------------------------------------------------------------------------------------------------
; Problem: explain how `partial-tree` works. What's its order of growth?
; --------------------------------------------------------------------------------------------------

#|
`partial-tree` basically divides the (ordered) list into the middle element, all left elements
(smaller), and all right elements (larger). Since we want the tree to be balanced, we'll want that
middle element to be the root.

The code visits every node as a root (center) node, so it's at least O(N). Beyond that, it doesn't
perform any expensive work beyond the recursive `partial-tree` calls, so overall performance is O(N).

An interesting counter-example: a lot of what's confusing in the above code is the overhead around
managing "slices" of the elements list, passing around n, etc. You can write a version that's
much simpler (closer to the natural-language explanation), like this...
|#

(define (take list n)
    (if (= n 0)
        '()
        (cons (car list)
              (take (cdr list) (- n 1)))))

(define (drop list n)
    (if (= n 0)
        list
        (drop (cdr list) (- n 1))))

(define (list->tree2 elements)
    (let ((len (length elements)))
        (if (= len 0)
            '()
            (let ((left-size (quotient (- len 1) 2)))
                (let ((left-elements (take elements left-size))
                      (center-element (list-ref elements left-size))
                      (right-elements (drop elements (+ left-size 1))))
                    (make-tree center-element
                               (list->tree2 left-elements)
                               (list->tree2 right-elements)))))))

#|
...but now we're not just doing O(1) stuff alongside our recursion. Instead, we're
measuring `length` multiple times, iterating with `take` and `drop`, etc, which
means we have iteration in each recursive call.

So, this version is much clearer, but O(Nlog(N)).
|#
