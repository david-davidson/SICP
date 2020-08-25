(load "chapters/1/1.42.scm") ; To import `compose`

;---------------------------------------------------------------------------------------------------
; In the spirit of `compose`, implement a function `repeated` that takes two arguments, a function
; `fn` and an integer `n`, and returns a function that applies `fn` `n` times.
;---------------------------------------------------------------------------------------------------

(define (inc x) (+ x 1))

(define (repeated fn n)
    (lambda (initial-val)
        (define (iter val count)
            (if (>= count n)
                val
                (iter (fn val)
                      (inc count))))
        (iter initial-val 0)))

; ((repeated square 2) 5) => 625

;---------------------------------------------------------------------------------------------------
; After I wrote ☝️this, I thought "I bet there's a more elegant way" and looked at others' answers--
; sure enough, you can do it much more elegantly using `compose`:
;---------------------------------------------------------------------------------------------------

(define (repeated-nicer fn n)
    (if (<= n 1)
        fn
        (compose fn (repeated-nicer fn (- n 1)))))
