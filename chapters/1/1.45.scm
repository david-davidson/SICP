(load "chapters/1/1.43.scm") ; To import `repeated`
(load "chapters/1/fixed-points.scm") ; To import `average-damp`

;---------------------------------------------------------------------------------------------------
; We've seen a fixed-point search for `y => x/y` find square roots with average damping, and
; `y => x/(y^2)` find cube roots. As it happens, the process does NOT work for fourth roots: the
; search doesn't converge!
; It does, though, converge if you average-damp _twice_.
; Problem: experiment with how much repeating average damping is necessary to solve nth roots, and
; implement a generic nth-root solver using `repeated`.
;
; After some experimentation, I found that:
;   * Roots 2–3 require average damping once
;   * 4–7 require average damping twice
;   * 8–15, 3 times
;   * 16–31, 4 times
;
; From that 2|4|8|16 pattern, we can work out that the number of required average damping is the
; floor of log2(x). From there, the problem is straightforward!
;---------------------------------------------------------------------------------------------------

; Per https://en.wikibooks.org/wiki/Scheme_Programming/Further_Maths#Logarithm, Scheme's built-in
; `log` is the natural log, but we can get to an arbitrary base like this:
(define (log-base base x)
    (/ (log x)
       (log base)))

(define (root-n n x)
    (let ((damp-count (floor (log-base 2 x))))
        (fixed-point ((repeated average-damp damp-count)
                        (lambda (y) (/ x
                                       (expt y (- n 1)))))
                     1.0)))

; (root-n 10 1024) => ~2
