;---------------------------------------------------------------------------------------------------
; The function `fixed-point` finds argument `fn`'s *fixed point*: the argument `x` to `fn` such that
; `(fn x => x)`. It does this by starting with an arbitrary initial guess and running `fn` on a
; sequence of subsequent guesses (`(f x)`, `(f (f x))`, `(f (f (f x)))`, etc) until the guesses
; are within `tolerance` of each other.
;---------------------------------------------------------------------------------------------------

(define tolerance 0.00001)

(define (fixed-point fn first-guess)
    (define (close-enough? v1 v2)
        (< (abs (- v1 v2)) tolerance))
    (define (try guess)
        (let ((next (fn guess)))
            (if (close-enough? guess next)
                next
                (try next))))
    (try first-guess))

;---------------------------------------------------------------------------------------------------
; Note how similar this process of *iterative improvement* is to how we computed square roots back
; in 1.6.scm. We can try to express that process as a fixed-point search:
;   * Finding the square root of x means finding a y such that `y^2 = x`
;   * To solve for y: `y = x/y`
;   * That is, we need the *fixed point* of `x/y`
;---------------------------------------------------------------------------------------------------

(define (sqrt-naive x)
    (fixed-point (lambda (y) (/ x y))
                 1.0))

;---------------------------------------------------------------------------------------------------
; But this search doesn't converge! From an initial guess `y1`, we get a next guess `x/y1`, and a
; subsequent guess `x/(x/y1)`... or `y1`. The guesses enter an infinite loop, toggling between those
; two values.
;
; One way to address this is to keep the guesses from changing so much on every iteration:
;   * In the case of square roots, we know that the answer will be between our guess and `x/y` (next
;   guess as written above)
;   * So, we can bring the next guess closer to y by averaging y and `x/y`
;   * In that case, we want the fixed point of `y = 1/2(y + x/y)`
;
; This technique is called *average damping*.
;---------------------------------------------------------------------------------------------------

(define (average x y)
    (/ (+ x y) 2))

(define (sqrt-better x)
    (fixed-point (lambda (y) (average y (/ x y)))
                 1.0))

;---------------------------------------------------------------------------------------------------
; Note that we can think about average damping independently of this specific use case: for any unary
; function `f(x)`, its average-damped counterpart returns the average of `x` and `f(x)`. This
; abstracted description lends itself to a higher-order function:
;---------------------------------------------------------------------------------------------------

(define (average-damp fn)
    (lambda (x)
        (average x (fn x))))

(define (sqrt-best x)
    (fixed-point (average-damp (lambda (y) (/ x y)))
                 1.0))

;---------------------------------------------------------------------------------------------------
; As SICP notes, this final iteration is extremely "obvious" in its division into distinct elements:
;   * Fixed-point search
;   * Average damping
;   * `y => x/y`
;
; That sort of explicitness is part of the expressive power of higher-order functions!
;---------------------------------------------------------------------------------------------------

;---------------------------------------------------------------------------------------------------
; The square-root approach above is an instance of Newton's general method for finding roots. The
; general method: if `g` is a differentiable function, it has a zero at the fixed point of
; f(x) = x - g(x)
;            -----
;            g'(x)
; ...where `g'` is the derivative of `g`.
;
; Derivatives, too, can be expressed as higher-order functions: in the limit of a small `dx`, we can
; calculate the slope at `dx`:
;---------------------------------------------------------------------------------------------------

(define dx 0.00001)

(define (deriv g)
    (lambda (x)
        (/ (- (g (+ x dx)) (g x))
           dx)))

;---------------------------------------------------------------------------------------------------
; The `deriv` function lets us express Newton's method: given `x`, we can look for a zero of
; `(lambda (y) (- (square y) x))`, which means looking for the fixed point of the transformed version
; of that function:
;---------------------------------------------------------------------------------------------------

(define (newton-transform g)
    (lambda (x)
        (- x (/ (g x)
                ((deriv g) x)))))

(define (newtons-method g)
    (fixed-point (newton-transform g)
                 1.0))

(define (sqrt-newton x)
    (newtons-method (lambda (y) (- (square y) x))))

;---------------------------------------------------------------------------------------------------
; OK, now we have two ways to compute square roots (Newton's method, direct fixed-point search), both
; of which boil down to fixed-point search. Each starts with a simple input function and transforms
; that function somehow. This, too, we can abstract away:
;---------------------------------------------------------------------------------------------------

(define (fixed-point-of-transform g transform guess)
    (fixed-point (transform g)
                 guess))

;---------------------------------------------------------------------------------------------------
; Note how similar the two methods now appear:
;---------------------------------------------------------------------------------------------------

(define (sqrt-1 x)
    (fixed-point-of-transform (lambda (y) (/ x y))
                              average-damp
                              1.0))

(define (sqrt-2 x)
    (fixed-point-of-transform (lambda (y) (- (square y) x))
                              newton-transform
                              1.0))
