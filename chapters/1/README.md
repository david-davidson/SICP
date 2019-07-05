# Notes

### 1.1.3
Combinations (or s-expressions) are paren-enclosed lists in which the first entry is the operator and the rest are operands. Evaluation is inherently tree-like: an expression like
```scm
(* (+ 2
      (* 4 6))
      (+ 3 5 7))
```
...requires that four sub-combinations be evaluated. Operators and primitive values represent leaf nodes; as they combine, they "percolate upward" into the final value. This is called **tree accumulation**.

Definitions are _not_ combinations: `(define x 3)` does not apply `define` equivalently to both arguments. Definitions are one example of **special forms**, which all have their own special evaluation rules. Lisp's syntax boils down to the standard evaluation of combinations plus the evaluation of special forms.

### 1.1.5
When an expression includes a "compound procedure" (function), we evaluate it with the **substitution model**, which evaluates function bodies with their variables populated by arguments. In one model of evaluation, we first evaluate all operators and operands, then evaluate the resulting expression. In another model, we don't evaluate operands until they're needed. The former method is called **applicative-order evaluation**, and the latter is **normal-order evaluation**. Lisp uses the former by default (and the latter in certain special forms, like `if` expressions); the latter is lazier.

### 1.2.1
All recursion is not equivalent. The standard recursive model is called **linear recursion**, where the expression evaluates with the help of a chain of deferred operations.
```scm
(define (factorial n)
    (if (= n 1)
        1
        (* n (factorial - n 1))))
```
As we evaluate, say, `(factorial 5)`, we first _expand_ deferred multiplications (`(* 5 (factorial 4))`, etc.) until we hit the base case, then _reduce_ the expression back into the answer. The steps involved (to evaluate operations) and the memory involved (to track the deferred operations) scale linearly with `n`.

Another form of "recursion" might look like this:
```scm
(define (factorial n)
    (define (recur-iterative total counter)
        (if (> counter n)
            total
            (recur-iterative (* counter total)
                             (+ counter 1))))
    (recur-iterative 1 1))
```

Here, we track state not through deferred operations but through explicit variable values: `product`, `counter`, and `n`. You could pause this version of factorial partway through running, capture the values of all state variables, and simply restart it from those variables; the same is _not_ true of the linear-recursive process, with its implicit stack state. This is called a **linear-iterative** process. This process doesn't show the same pattern of expansion and contraction; the number of steps grows with `n`, but memory consumption is constant.

Note that `recur-iterative` is still a recursive _function_: it calls itself. A process can be conceptually iterative and still be implemented by recursive function calls.

This mode of "recursion" is basically equivalent to a `for` or `while` loop in C-style languages. In many such languages, recursion is evaluated such that multiple recursive function calls consume memory linearly, _even when no computation is deferred_. (This is why iteration requires constructs like `for` and `while`.) For these languages, the two forms of `factorial` are equivalent; only **tail-recursive** language implementations (like Scheme) treat them differently.

For a function to be tail-recursive, there must be nothing for it left to do after it completes execution other than call itself with the latest value. (This is called a **tail call**.) At that point, with no deferred work, the compiler can safely discard the function's stack frame—hence the constant memory usage.

### 1.2.2
When a function calls itself multiple times, it's called **tree recursion**. The Fibonacci function is a classic example:
```scm
(define (fibonacci n)
    (cond ((= n 0) 0)
          ((= n 1) 1)
          (else (+ (fibonacci (- n 1))
                   (fibonacci (- n 2))))))
```
Tree-recursive functions end up duplicating a great deal of work (`(fibonacci 5)` evaluates `(fibonacci 3)` twice), which makes them a great candidate for refactoring into iterative form. While linear recursion only consumes more _space_ than iteration, tree recursion (because of that duplicate work) also consumes more _time_.

In general, the number of steps required by a tree-recursive process is proportional to the number of nodes in the tree, while the space required is proportional to the maximum depth of the tree. (That's because, at any time, all we need to keep track of is the call stack back to the root of the tree.)

### 1.3.3
A function's **fixed point** is the value `x` for which `f(x) = x`. (In [Smullyan's terms](https://github.com/david-davidson/to-mock-a-mockingbird), `f` is fond of `x`.)
