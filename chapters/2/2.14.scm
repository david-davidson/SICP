; --------------------------------------------------------------------------------------------------
; A user of our system notes that two algebraically equivalent expressions produce different
; results. Why?
;
; This question revisits the comment at the end of problem 2.8, where we note that arithmetic is
; "lossy": `x` and `x + x - x` are algebraically equivalent expressions, but the latter will be less
; precise than the former. We can't count on consistency between algebraically equivalent
; expressions, because each instance of arithmetic (even instances that "cancel out" algebraically)
; introduces a little more uncertainty.
;
; Or, rather: each instance of an uncertain value increases the uncertainty of the result. In the
; case of `x + x - x`, it's not the arithmetic that's "lossy"; it's x itself--which, by appearing
; three times instead of (the algebraically equivalent) once, produces a more uncertain result.
; --------------------------------------------------------------------------------------------------
