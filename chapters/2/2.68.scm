(load "chapters/2/2.67.scm") ; To import `sample-tree`

; --------------------------------------------------------------------------------------------------
; Exercise 2.68 gives us `encode` and asks us to implement `encode-char`, which is the logic that
; actually walks the tree and builds up binary sequences.
; --------------------------------------------------------------------------------------------------

(define (encode message tree)
    (if (null? message)
        '()
        (append (encode-char (car message) tree)
                (encode (cdr message) tree))))

(define (encode-char char tree)
    (if (leaf? tree)
        '()
        (let ((left-subtree (left-branch tree))
              (right-subtree (right-branch tree)))
            (cond ((contains? char (chars left-subtree))
                    (cons 0 (encode-char char left-subtree)))
                  ((contains? char (chars right-subtree))
                    (cons 1 (encode-char char right-subtree)))
                  (else
                    (error "missing character:" char))))))

(define (contains? x xs)
    (cond ((null? xs) false)
          ((equal? x (car xs)) true)
          (else (contains? x (cdr xs)))))

(define sample-message (encode '(a d a b b c a) sample-tree)) ; => (0 1 1 0 0 1 0 1 0 1 1 1 0)
