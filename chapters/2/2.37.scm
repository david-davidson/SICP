#|
We're given a representation of vectors and matrixes as lists: a vector is simply a list, and a
matrix is a list of lists, where each sub-list represents a row. For example, the matrix
    [1 2 3 4
     4 5 6 6
     6 7 8 9]
would be represented by the list
    ((1 2 3 4) (4 5 6 6) (6 7 8 9))

We're given an implementation of `dot-product`, and prompted to implement further matrix operations:
matrix * vector multiplication, matrix * matrix, and transpose.
|#

; Dot product is simple: the sum of the product of the corresponding entries between two sequences.
; Note that both vectors must be of the same length, though we don't validate for that here.
(define (dot-product vec1 vec2)
    (fold + 0 (map * vec1 vec2)))

(dot-product '(1 2 3 4) '(2 3 4 5)) ; => 40

; --------------------------------------------------------------------------------------------------
; Matrix * vector multiplication follows pretty naturally from `dot-product`: we take each row of
; the matrix, take its dot product with the vector, and populate the corresponding entry in the
; resulting vector.
; This only works when the number of *columns* in the matrix matches the number of entries in the
; vector: the number of columns is the length of a given row, which must match that of the vector
; for `dot-product` to be appropriate.
; --------------------------------------------------------------------------------------------------

(define (mult-matrix-vector matrix vec)
    (map (lambda (row)
            (dot-product row vec))
         matrix))

(define matrix1 '((1 2 3) (4 5 6) (7 8 9)))
(mult-matrix-vector matrix1 '(1 2 3)) ; => (14 32 50)

; --------------------------------------------------------------------------------------------------
; Likewise, matrix * matrix multiplication is only supported in cases where the number of columns in
; the first matrix matches the number of rows in the second (though we skip validation here).
; For every row in the first matrix, we take the dot product against every column in the second.
; Note that to extract columns we need to write `tranpose`, which--happily--is a requirement of the
; problem anyway!
; --------------------------------------------------------------------------------------------------

; Just a generic helper
(define (every fn seq)
    (fold (lambda (current total)
            (and (fn current) total))
          true
          seq))

; For a matrix defined row by row, extract columns (and vice versa)
(define (transpose matrix)
    (if (every pair? matrix)
        (let ((column (map car matrix))
              (remaining-matrix (map cdr matrix)))
            (cons column (transpose remaining-matrix)))
        '()))

(define (mult-matrix-matrix matrix1 matrix2)
    (map (lambda (row)
            (map (lambda (col)
                    (dot-product row col))
                 (transpose matrix2)))
         matrix1))

(define matrix2 '((1 2 2) (2 4 6) (7 2 5)))
(mult-matrix-matrix matrix1 matrix2) ; => ((26 16 29) (56 40 68) (86 64 107))
