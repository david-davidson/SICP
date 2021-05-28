(load "chapters/4/eval-apply/helpers")

#|
The all-important eval/apply pair! See helpers for logic around evaluating specific expression types.

Note abstract constructors/selectors/predicates like `make-procedure`, `text-of-quotation`, and
`variable?`, so that the evaluator can remain unchanged as language syntax itself changes.
|#

(define (eval exp env)
    (cond ((self-evaluating? exp) exp)
          ((variable? exp) (lookup-variable-value exp env))
          ((quoted? exp) (text-of-quotation exp))
          ((assignment? exp) (eval-assignment exp env))
          ((definition? exp) (eval-definition exp env))
          ((if? exp) (eval-if exp env))
          ((lambda? exp)
            (make-procedure (lambda-parameters exp)
                            (lambda-body exp)
                            env))
          ((begin? exp)
            (eval-sequence (begin-actions exp) env))
          ((cond? exp)
            (eval (cond->if exp) env))
          ((application? exp)
            (apply (eval (operator exp) env)
                   (list-of-values (operands exp) env)))
          (else (error "Unknown expression type -- EVAL" exp))))

(define (apply procedure arguments)
    (cond ((primitive-procedure? procedure)
            (apply-primitive-procedure procedure arguments))
          ((compound-procedure? procedure)
            (eval-sequence (procedure-body procedure)
                           (extend-environment (procedure-parameters procedure)
                                               arguments
                                               (procedure-environment procedure))))
          (else (error "Unknown procedure type -- APPLY" procedure))))

#|
Let's wire this up to actually run as a program. Using `read` to process CLI input, we'll set up a REPL to evaluate arbitrary expressions
|#

(define input-prompt "===> DIY eval input:")
(define output-prompt "===> DIY eval output:")

(define (driver-loop)
    (prompt-for-input input-prompt)
    (let ((input (read)))
        (let ((output (eval input the-global-environment)))
            (announce-output output-prompt)
            (safe-print output)))
    (driver-loop))

(define (prompt-for-input string)
    (newline)
    (newline)
    (display string)
    (newline))

(define (announce-output string)
    (newline)
    (display string)
    (newline))

; The `env` variable itself, a list of lists, will be massive and unreadable, so we omit it when
; printing functions:
(define (safe-print object)
    (if (compound-procedure? object)
        (display (list 'compound-procedure
                       (procedure-parameters object)
                       (procedure-body object)
                       '<procedure-env>))
        (display object)))


#|
Now we can initialize our environment and start our REPL:
|#

(define the-global-environment (setup-environment))
(driver-loop)

#|
Testing:
===> DIY eval input:
(define (append x y) (if (null? x) y (cons (car x) (append (cdr x) y))))

===> DIY eval output:
ok

===> DIY eval input:
(append '(1 2) '(3 4))

===> DIY eval output:
(1 2 3 4)
|#
