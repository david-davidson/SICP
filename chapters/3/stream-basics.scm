(load "chapters/1/1.21.scm") ; To import `prime?` predicate

; --------------------------------------------------------------------------------------------------
; These utils are built into Scheme already -- these DIY implementations just show how they work!
; --------------------------------------------------------------------------------------------------

; Since the first element isn't lazy, we can just use vanilla `car`:
(define (stream-car seq)
    (car seq))

; The second _is_ lazy, so we force it:
(define (stream-cdr seq)
    (force (cdr seq)))

; Mapping and filtering work just like normal, except for using stream-specific helpers:
(define (stream-map fn seq)
    (if (stream-null? seq)
        the-empty-stream
        (cons-stream (fn (stream-car seq))
                     (stream-map fn (stream-cdr seq)))))

(define (stream-filter pred seq)
    (cond ((stream-null? seq)
            the-empty-stream)
          ((pred (stream-car seq))
            (cons-stream (stream-car seq)
                         (stream-filter pred (stream-cdr seq))))
          (else
            (stream-filter pred (stream-cdr seq)))))

; --------------------------------------------------------------------------------------------------

(define (stream-enumerate-interval low high)
    (if (> low high)
        the-empty-stream)
        (cons-stream low
                     (stream-enumerate-interval (+ low 1) high)))

; Returns 10,009:
(display (stream-car (stream-cdr (stream-filter prime?
                                 (stream-enumerate-interval 10000 1000000)))))
