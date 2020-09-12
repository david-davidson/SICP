(load "chapters/2/2.7.scm") ; To import interval utils

; --------------------------------------------------------------------------------------------------
; Problem: implement a `sub-interval` function for interval subtraction.
;
; This is a little unintuitive--my first instinct is to do something like this, an exact mirror of
; `add-interval`...
; --------------------------------------------------------------------------------------------------

(define (sub-interval-wrong x y)
    (make-interval (- (lower-bound x) (lower-bound y))
                   (- (upper-bound x) (upper-bound y))))

; --------------------------------------------------------------------------------------------------
; ...But that's off. Recall that, conceptually, we're looking for the _lowest and highest possible
; values_. When subtracting interval y from interval x into interval z, the lowest z could be is the
; lowest value of x minus the HIGHEST value of y. Likewise, the highest z could be is the highest
; value of x minus the lowest of y.
; --------------------------------------------------------------------------------------------------

(define (sub-interval x y)
    (make-interval (- (lower-bound x) (upper-bound y))
                   (- (upper-bound x) (lower-bound y))))

; --------------------------------------------------------------------------------------------------
; You can also look at that as _adding_ x to the negation of y (where negation entails changing the
; sign and flipping the values: [1, 2] => [-2, -1])
; --------------------------------------------------------------------------------------------------

(define (negate-interval x)
    (make-interval (- (upper-bound x))
                   (- (lower-bound x))))

(define (sub-interval-fancy x y)
    (add-interval x (negate-interval y)))

; --------------------------------------------------------------------------------------------------
; Here's an interesting property of this system: unlike "regular" addition/subtraction, it can't be
; reversed in a way that perfectly preserves information. (That is: 10 + 20 - 20 is... 10; you can
; undo the +20.)
; Here, on the other hand:
;   (define ten (make-interval 9 11))
;   (define twenty (make-interval 19 21))
;   (define thirty (add-interval ten twenty)) => range [28, 32]
;   (sub-interval thirty twenty) => [7, 13] (not [9, 11]
;
; I suppose this makes sense, in that every interval reflects uncertainty, and every arithmetic
; operation increases the uncertainty. In that sense, arithmetic is necessarily "lossy." In the
; above case, we went from an original tolerance of +/- 1 to (after addition) +/- 2 to (after
; subtraction) +/- 3.
; --------------------------------------------------------------------------------------------------
