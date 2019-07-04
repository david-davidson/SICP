# Notes

### 1.1.3
Combinations (or s-expressions) are paren-enclosed lists in which the first entry is the operator and the rest are operands. Evaluation is inherently tree-like: an expression like
```s
(* (+ 2 (* 4 6))
    (+ 3 5 7))
```
...requires that four sub-combinations be evaluated. Operators and primitive values represent leaf nodes; as they combine, they "percolate upward" into the final value. This is called **tree accumulation**.

Definitions are _not_ combinations: `(define x 3)` does not apply `define` equivalently to both arguments. Definitions are one example of **special forms**, which all have their own special evaluation rules. Lisp's syntax boils down to the standard evaluation of combinations plus the evaluation of special forms.

### 1.1.5
When an expression includes a "compound procedure" (function), we evaluate it with the **substitution model**, which evaluates function bodies with their variables populated by arguments. In one model of evaluation, we first evaluate all operators and operands, then evaluate the resulting expression. In another model, we don't evaluate operands until they're needed. The former method is called **applicative-order evaluation**, and the latter is **normal-order evaluation**. Lisp uses the former by default (and the latter in certain special forms, like `if` expressions); the latter is lazier.

### 1.2.1
All recursion is not equivalent. The standard recursive model is called **linear recursion**, where the expression evaluates with the help of a chain of deferred operations.
```s
(define (factorial n)
    (if (= n 1)
        1
        (* n (factorial - n 1))))
```
As we evaluate, say, `(factorial 5)`, we first _expand_ deferred multiplications (`(* 5 (factorial 4))`, etc.) until we hit the base case, then _reduce_ the expression back into the answer. The steps involved (to evaluate operations) and the memory involved (to track the deferred operations) scale linearly with `n`.

Another form of "recursion" might look like this:
```s
(define (factorial n)
    (define (recur-iterative total counter)
        (if (> counter n)
            total
            (recur-iterative (* counter total)
                             (+ counter 1))))
    (recur-iterative 1 1))
```

Here, we track state not through deferred operations but through explicit variable values: `product`, `counter`, and `n`. You could pause this version of factorial partway through running, capture the values of all state variables, and simply restart it from those variables; the same is not true of the linear-recursive process. This is called a **linear iterative** process. This process doesn't show the same pattern of expansion and contraction; the number of steps grows with `n`, but the memory consumption does not.

Note that `recur-iterative` is still a recursive _function_: it calls itself. A process can be conceptually iterative and still be implemented by recursive function calls.

This form of recursion is basically equivalent to a for- or while-loop. In languages with those constructs, material on recursion tends to mention that any recursive process can be expressed as an iterative loop; in the cases of Lisp, any recursive process can be expressed as linear-iterative recursion. (This doesn't mean linear iteration is "better"; linear recursion is often much more declarative!)

Lots of languages—including JS—evaluate recursion such that multiple recursive function calls consume memory linearly, even when no computation is deferred. For these languages, the two forms of `factorial` are equivalent. Only **tail-recursive** implementations (like Scheme) treat them differently.

### 1.3.3
A function's **fixed point** is the value `x` for which `f(x) = x`. (In [Smullyan's terms](https://github.com/david-davidson/to-mock-a-mockingbird), `f` is fond of `x`.)
