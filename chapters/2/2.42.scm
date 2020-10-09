; --------------------------------------------------------------------------------------------------
; The eight-queens problem: how to place eight queens on a chessboard such that none are in check?
; We're given a recursive implementation, below, with certain helpers TBD:
; --------------------------------------------------------------------------------------------------

(define (queens board-size)
    (define (queen-cols col-idx)
        (if (= col-idx 0)
            (list empty-queens)
            (filter
                safe?
                (flatmap
                    (lambda (prev-queens)
                        (map (lambda (row-idx)
                                (adjoin-position row-idx col-idx prev-queens))
                             (enumerate-rows board-size)))
                    (queen-cols (- col-idx 1))))))
    (queen-cols board-size))

; --------------------------------------------------------------------------------------------------
; By now, we already have a handful of helpers defined from earlier:
; --------------------------------------------------------------------------------------------------

(define (enumerate-interval low high)
    (if (> low high)
        '()
        (cons low (enumerate-interval (+ low 1) high))))

(define (flatmap fn seq)
    (fold append '() (map fn seq)))

(define (enumerate-rows size)
    (enumerate-interval 1 size))

; --------------------------------------------------------------------------------------------------
; The problem: implement the remaining missing pieces, including data structures to represent
; positions on the board, structures to represent _multiple_ positions, and helpers to aggregate
; positions and check position safety.
; --------------------------------------------------------------------------------------------------

; Row/column coords are modeled as pairs:
(define (make-position x y) (cons x y))
(define (col position) (car position))
(define (row position) (cdr position))

; Visited positions are modeled as a list, which initializes empty:
(define empty-queens '())

; Adding positions simply conses onto the list
(define (adjoin-position row-idx col-idx prev-positions)
    (cons (make-position row-idx col-idx)
          prev-positions))

(define (every fn seq)
    (fold (lambda (current total)
            (and (fn current) total))
          true
          seq))

(define (safe-pair? x y)
    (define (same-col x y)
        (= (col x) (col y)))
    (define (same-row x y)
        (= (row x) (row y)))
    (define (diagonal x y)
        (let ((row-offset (abs (- (row x) (row y))))
              (col-offset (abs (- (col x) (col y)))))
            (= row-offset col-offset)))
    (and (not (same-row x y))
         (not (same-col x y))
         (not (diagonal x y))))

; Here we depart from the book a little. Its implementation has the signature `(safe? row-idx
; queens)`, but I don't think we need that row information: the first item on the list is always the
; queen to test (remaining are known to be safe relative to each other), and it already knows its
; own row idx.
(define (safe? queens)
    (let ((latest-queen (car queens))
          (prev-queens (cdr queens)))
        (every
            (lambda (prev-queen)
                (safe-pair? prev-queen latest-queen))
            prev-queens)))
