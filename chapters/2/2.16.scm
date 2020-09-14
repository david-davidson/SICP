; --------------------------------------------------------------------------------------------------
; Is it possible to devise a package for interval arithmetic in which equivalent algebraic
; expressions consistently produce the same result?
;
; My sense is: practical, no; theoretically possible, yes??
;
; The only way I can imagine doing this is with metaprogramming/macros. The trick would be to
; "rewrite" the program to the simplest algebraic equivalent at runtime. As far as I can tell,
; simplifying algebraic expressions looks at least _somewhat_ tractable, at least for an 80%
; solution. Once we had an adequate simplifier, we'd need to require that the outermost "wrapper"
; call be our macro--at runtime, it would parse the string passed in as an argument (under lazy
; evaluation), simplify the expression, and evaluate it.
;
; I suspect that's a TON of work all told, and probably fails to account for an edge case or two.
; I'm less optimistic it's possible to do *perfectly*. But it seems tractable, if challenging, to do
; for (say) the core 80% of user scenarios.
; --------------------------------------------------------------------------------------------------
