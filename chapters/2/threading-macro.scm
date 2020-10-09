(load "chapters/2/2.42.scm") ; To import all the other helpers for `queens`

; --------------------------------------------------------------------------------------------------
; While working on problem 2.42, I found myself struggling to follow the `queens` solution even
; with `flatmap` and `filter` present. The tricky bit is just the visual order of execution, which
; hops around both vertically and horizontally as we step through list operations.
;
; What would help would be Clojure's threading macros (`->` and `->>`), which enable a much more
; visually ordered code style. So here's `->>` implemented in Scheme...
; --------------------------------------------------------------------------------------------------

; `define-syntax` uses pattern matching to define valid ways to invoke the macro: each pattern
; corresponds to a template to rewrite the expression into. Scheme rewrites the expression *before*
; evaluating it.
(define-syntax ->>
    ; Pipes an initial value through in the *last* argument position
    (syntax-rules ()
        ; Pattern to match on. All args are template variables, but the first is the macro name
        ; itself -- so this matches, e.g., (->> 3)
        ((->> value)
            ; expression we rewrite *to*: e.g., 3
            value)

        ; Matches e.g. (->> 3 (+ 1 2) (/ 3))
        ((->> value (fn args ...) rest ...)
            ; Rewrites to (->> (+ 1 2 3) (/ 3)), with 3 inserted in last position.
                (->> (fn args ... value) rest ...))

        ; Matches e.g.. (->> 3 inc (/ 3))
        ((->> value fn rest ...)
            ; Rewrites to (->> (inc 3) (/ 3))
            (->> (fn value) rest ...))))

; --------------------------------------------------------------------------------------------------
; ...And here's the resulting `queens` code! Compare this with the solution in 2.42 and note how
; much easier to understand this is.
; A little more on `->>` at https://daviddavidson.website/threading-macros-scheme/ if interested
; --------------------------------------------------------------------------------------------------

(define (queens board-size)
    (define (queen-cols col-idx)
        (if (= col-idx 0)
            (list empty-queens)
            (->> (queen-cols (- col-idx 1))
                 (flatmap (lambda (prev-queens)
                            (->> (enumerate-rows board-size)
                                 (map (lambda (row-idx)
                                        (adjoin-position row-idx col-idx prev-queens))))))
                 (filter safe?))))
    (queen-cols board-size))
