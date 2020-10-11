#|
An extended set of problems in section 2.3 deals with Huffman encoding: see
https://daviddavidson.website/huffman-encoding/ for a look at them as a group. Here, the book gives
us the handful of supporting data structures (leaves and trees), plus the `decode` operation.
|#


; --------------------------------------------------------------------------------------------------
; Leaves:
; --------------------------------------------------------------------------------------------------

(define (make-leaf char weight)
    (list 'leaf char weight))
(define (leaf? object)
    (eq? (car object) 'leaf))
(define (char-leaf object) (cadr object))
(define (weight-leaf object) (caddr object))

; --------------------------------------------------------------------------------------------------
; Trees:
; --------------------------------------------------------------------------------------------------

(define (make-tree left right)
    (list left
          right
          (append (chars left) (chars right))
          (+ (weight left) (weight right))))
(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))
(define (chars-tree tree) (caddr tree))
(define (weight-tree tree) (cadddr tree))

; --------------------------------------------------------------------------------------------------
; Generic selectors:
; --------------------------------------------------------------------------------------------------

(define (chars node)
    (if (leaf? node)
        (list (char-leaf node))
        (chars-tree node)))

(define (weight node)
    (if (leaf? node)
        (weight-leaf node)
        (weight-tree node)))

; --------------------------------------------------------------------------------------------------
; Tree decoding (see https://daviddavidson.website/huffman-encoding/ for a deeper look)
; --------------------------------------------------------------------------------------------------

(define (decode bits tree)
    (define (choose-branch bit tree)
        (if (= bit 0)
            (left-branch tree)
            (right-branch tree)))
    (define (recur bits subtree)
        (if (null? bits)
            '()
            (let ((next-branch (choose-branch (car bits) subtree)))
                (if (leaf? next-branch)
                    (cons (char-leaf next-branch)
                          (recur (cdr bits) tree))
                    (recur (cdr bits) next-branch)))))
    (recur bits tree))
