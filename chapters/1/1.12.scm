;---------------------------------------------------------------------------------------------------
; Write a recursive function that, given row and column, calculates elements of Pascal's triangle
;---------------------------------------------------------------------------------------------------

#|
As a reminder, Pascal's triangle is defined such that:
* Each edge number is 1
* Each non-edge number is the sum of the two above it

    1
   1 1
  1 2 1
 1 3 3 1
1 4 6 4 1
|#

(define (pascal row column)
    (let ((is-edge? (or (= column 0) (= column 0) (= column row)))
          (prev-row (- row 1))
          (prev-column (- column 1)))
         (if is-edge?
             1
             (+ (pascal prev-row prev-column)
                (pascal prev-row column)))))
