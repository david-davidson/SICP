### The metacircular evaluator

An evaluator written in the same language that it evaluates is called metacircular.

`eval` and `apply` work together as the heart of the evaluator, together implementing
the [environment model of evaluation](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-21.html#%_sec_3.2).

The two parts of that model are:
1. `eval`: evaluate an expression's subexpressions, and apply the value of the operator (first expression) to the value of the operands (remaining expressions)
2. `apply`: apply the body of the operator's procedure in a new environment that extends the original environment with function arguments/values

In a cycle, expressions are reduced to functions to be applied to values ->
functions produce new expressions to be evaluated -> expressions are reduced... until we reach the
base level of primitive functions and symbols. The job of the evaluator isn't to define these primitives, but to provide the "connective tissue" (means of combination and abstration) to orchestrate
their use.

See [eval-apply](eval-apply/index.scm) for a runnable example of the evaluator!
