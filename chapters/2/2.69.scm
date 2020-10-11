(load "chapters/2/2.68.scm") ; To import `encode` and `decode`

; --------------------------------------------------------------------------------------------------
; Exercise 2.69 gives us `generate-huffman-tree`, `make-leaf-set`, and `adjoin-set`, and asks us
; to implement `successive-merge`
; --------------------------------------------------------------------------------------------------

(define (generate-huffman-tree pairs)
    (successive-merge (make-leaf-set pairs)))

; This is kind of tricky. Note that we assume our nodes are ordered, so the
; lightest and next-lightest nodes are the first and second. (Initially both will
; be leaves, but as `successive-merge` recursively calls itself, it'll pull leaves
; out of the set and replace them with trees.)
; In the recursive call, we call `make-tree` with the lightest and second-lightest
; nodes, and then call `adjoin-set` to add the tree to the ordered set of nodes.
; As we successively merge, we combine the lightest elements (whether leaf or tree)
; over and over, turning more and more of the set into trees rather than leaves.
; When there's only one node left, that's the tree itself, and we're done!
(define (successive-merge ordered-nodes)
    (let ((lightest-node (car ordered-nodes))
          (heavier-nodes (cdr ordered-nodes)))
        (if (null? heavier-nodes)
            lightest-node
            (successive-merge (adjoin-set (make-tree lightest-node (car heavier-nodes))
                                          (cdr heavier-nodes))))))

; `successive-merge` assumes that its inputs are ordered and that all nodes are
; either leaves or trees. To satisfy that condition initially, `make-leaf-set`
; formats each pair as a proper leaf and calls `adjoin-set` to order the set.
(define (make-leaf-set pairs)
    (if (null? pairs)
        '()
        (let ((pair (car pairs)))
            (let ((char (car pair))
                  (weight (cadr pair)))
                (adjoin-set (make-leaf char weight)
                            (make-leaf-set (cdr pairs)))))))

; Finally, `adjoin-set` adds `node` to `set` in the correct order. Ordering is
; an important part of the process here: each call to `successive-merge` requires
; us to access the lightest and second-lightest nodes, so by keeping the set in
; order, we save work.
(define (adjoin-set node set)
    (cond ((null? set)
            (list node))
          ((< (weight node) (weight (car set)))
            (cons node set))
          (else (cons (car set)
                      (adjoin-set node (cdr set))))))

; --------------------------------------------------------------------------------------------------
; Finally, a fun detour from the book! We now have encoding, decoding, and tree generation--the only
; missing piece is a more user-friendly way of generating weighted alphabets and interacting with
; encoders/decoders. Ideally, we could pass in a string to generate the weighted alphabet, and
; deal with messages formatted as strings, not lists of characters. Let's set that up.
; --------------------------------------------------------------------------------------------------

; Loops over chars, building up a list of character/frequency pairs
(define (generate-pairs chars)
    (define (iter pairs chars)
        (if (null? chars)
            pairs
            (iter (increment-char-count (car chars) pairs)
                  (cdr chars))))
    (iter '() chars))

; For a given character, increments its count or adds it to the pairs list
(define (increment-char-count char pairs)
    (define (make-pair char count) (list char count))
    (define (char-pair pair) (car pair))
    (define (count-pair pair) (cadr pair))
    (if (null? pairs)
        (list (make-pair char 1))
        (let ((pair (car pairs)))
            (if (eq? (char-pair pair) char)
                (cons (make-pair char (+ (count-pair pair) 1))
                      (cdr pairs))
                (cons pair
                      (increment-char-count char (cdr pairs)))))))

; Just a generic helper to tidy up function nesting
(define (pipe . fns)
    (define (identity x) x)
    (define (compose f g)
        (lambda (x) (f (g x))))
    (fold compose identity fns))

; Finally, a closure wrapper over a tree built from a specific alphabet
(define (build-encoder alphabet)
    (let ((tree ((pipe string->list generate-pairs generate-huffman-tree) alphabet)))
        (lambda (operation data)
            (cond ((equal? operation "encode")
                    (encode (string->list data) tree))
                  ((equal? operation "decode")
                    (list->string (decode data tree)))
                  (else (error "unknown operation:" operation))))))

(define encoder (build-encoder "I am the alphabet that determines character weighting!"))
(encoder "encode" "secret") ; => (1 1 1 0 1 0 0 1 1 1 1 0 0 1 0 1 0 1 0 1 1 1 0 0)
(encoder "decode" '(1 1 1 0 1 0 0 1 1 1 1 0 0 1 0 1 0 1 0 1 1 1 0 0)); => "secret"
