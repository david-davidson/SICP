(load "chapters/2/2.2.scm") ; To import segment utils

; --------------------------------------------------------------------------------------------------
; Implement a representation for rectangles in a plane. Then, implement selectors for a rectangle's
; area and perimeter.
; --------------------------------------------------------------------------------------------------

(define (make-rectangle point-one point-two point-three)
    (let ((bottom (make-segment point-one point-two))
          (side (make-segment point-two point-three)))
        (cons bottom side)))

(define (get-bottom rectangle)
    (car rectangle))

(define (get-side rectangle)
    (cdr rectangle))

(define (get-area rectangle)
    (get-lengths rectangle *))

(define (get-perimeter rectangle)
    (get-lengths rectangle
                 (lambda (bottom-length side-length)
                    (* 2 (+ bottom-length side-length)))))

(define (get-lengths rectangle next)
    (next (get-segment-length (get-bottom rectangle))
          (get-segment-length (get-side rectangle))))

(define (get-segment-length segment)
    (define (pythag a b)
        (sqrt (+ (square a)
                 (square b))))
    (let ((start-point (start-segment segment))
          (end-point (end-segment segment)))
        (let ((start-x (x-point start-point))
              (end-x (x-point end-point))
              (start-y (y-point start-point))
              (end-y (y-point end-point)))
            (pythag (abs (- end-x start-x))
                    (abs (- end-y start-y))))))

#|
Testing:
(define point-1 (make-point 0 0))
(define point-2 (make-point 3 0))
(define point-3 (make-point 3 4))
(define rectangle (make-rectangle point-1 point-2 point-3))
(get-area rectangle) ; => 12
(get-area rectangle) ; => 14
|#
