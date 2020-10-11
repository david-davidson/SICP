(load "chapters/2/huffman-encoding.scm") ; To import `decode`

; --------------------------------------------------------------------------------------------------
; The first of the Huffman-encoding problems is trivially easy (presumably meant to verify we've
; implemented the base structures correctly): we're given a sample tree and sample message and asked
; to decode the message.
; --------------------------------------------------------------------------------------------------

(define sample-tree
    (make-tree (make-leaf 'A 4)
               (make-tree (make-leaf 'B 2)
                          (make-tree (make-leaf 'D 1)
                                     (make-leaf 'C 1)))))

(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))
(decode sample-message sample-tree) ; => (a d a b b c a)
