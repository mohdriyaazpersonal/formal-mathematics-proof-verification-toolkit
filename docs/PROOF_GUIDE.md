# Reading and extending the proofs

## Hypotheses are part of the theorem

`{α : Type*}` allows an arbitrary universe of elements. A predicate `P : α → Prop`
assigns a proposition to each element. A relation `R : α → α → Prop` assigns a
proposition to each ordered pair. A hypothesis such as `R a b` is a proof of an
edge, not an instruction to assume all relation properties.

Section variables that occur only in a theorem proof must be enabled with
`include`; `omit` ends that inclusion. For example, `two_step_transport` does not acquire the nearby symmetry
assumption: its proof uses only forward preservation and two edges.

## From logical structure to tactics

| Tactic | Mathematical role | Example module |
| --- | --- | --- |
| `intro` | Assume the antecedent or choose an arbitrary element | Logic/Propositional |
| `exact` | Supply a term of exactly the required proposition | Relations/Transport |
| `apply` | Reduce a conclusion to a theorem's premises | Functions/Composition |
| `constructor` | Prove each component of a conjunction/structure | Logic/Propositional |
| `cases`, `rcases`, `obtain` | Analyze alternatives or unpack a witness | Logic/Predicates |
| `rw` | Replace equal expressions using a proved equality | Induction/Summation |
| `simp` | Use certified simplification lemmas | DiscreteMath/Sequences |
| `aesop` | Search using introductions, constructors, and hypotheses | Sets/Operations |
| `ext` | Reduce function/set equality to pointwise equality | Sets/Images |
| `induction` | Base case plus successor case with an induction hypothesis | Induction/Naturals |
| `ring` | Close a polynomial identity in a commutative ring | Algebra/Identities |
| `ring_nf` | Normalize polynomials in goals or hypotheses | Algebra/Identities |
| `linarith` | Combine linear bounds and equalities | Algebra/Inequalities |
| `nlinarith` | Combine polynomial arithmetic constraints | Algebra/Inequalities |
| `omega` | Decide supported natural/integer linear arithmetic | Induction/Naturals |
| `norm_num` | Prove concrete arithmetic and primality facts | NumberTheory/Divisibility |
| `decide` | Reduce a decidable proposition and check its proof in the kernel | Counterexamples/Transport |

Term proofs and tactic proofs produce the same kind of kernel-checked evidence.
`⟨h.2, h.1⟩` directly constructs a reversed conjunction; `constructor` followed
by two `exact` steps builds that same pair interactively. The toolkit provides
both styles for retaining a hypothesis and commuting a conjunction.

## Constructive and classical logic

Contraposition, double-negation introduction, and the negated-disjunction version
of De Morgan are constructive. Eliminating double negation or extracting a
disjunction from a negated conjunction uses classical reasoning here. `by_contra`
and `classical` make these choices visible. Classical choice is permitted by the
trust audit; arbitrary additional axioms are not.

## Induction and natural-number division

`triangular` is defined recursively with base value zero and successor equation
`triangular (n+1) = triangular n + (n+1)`. Induction first proves
`2 * triangular n = n * (n+1)`. This polynomial identity avoids division.
Only after that equality is available do we deduce
`triangular n = n * (n+1) / 2` by exact cancellation in naturals.

`triangular_eq_sum` connects the recurrence with Mathlib's finite sum over
`Finset.range (n+1)`, which includes zero and ends at n. Adding zero makes this
the intended sum 1 + ... + n, including the empty boundary case n = 0.

## Algebraic assumptions

Polynomial identities are stated over a general commutative ring wherever
possible. Inequalities are stated over the reals. Squaring preserves order when
`0 ≤ a ≤ b`; dropping the sign assumption produces the explicit counterexample
`a = -2`, `b = -1`. `nlinarith` can use `sq_nonneg (a-b)` to turn the nonnegativity
of a difference square into `2*a*b ≤ a²+b²`.

## Building a counterexample

1. Write the proposed universal statement and identify the missing assumption.
2. Choose a small model, often Bool, and define its relation or predicate explicitly.
3. Prove every premise in the model; vacuous premises still require verification.
4. Exhibit a failing conclusion, ideally also proving the negation of the universal claim.
5. Explain what additional assumption would repair the result when one is known.

The natural successor counterexample uses an infinite domain intentionally:
for an endomap on a finite type, injectivity does imply surjectivity.
The transitivity counterexample even satisfies reflexivity; the useful repair
is symmetry or an independent backward preservation hypothesis.

The bounded search encodes relations as four-bit masks and predicates as two-bit
masks. Relation positions are `(false,false)`, `(false,true)`, `(true,false)`,
`(true,true)`. Mask 11 is binary 1011 and predicate mask 2 selects true. The
filter checks all assumptions and requires an explicit bad edge and predicate
values. `search_sound` proves that every reported pair meets this specification.
It does not claim completeness for larger or infinite universes.

## Trust boundaries

All named mathematical theorems live below `FormalToolkit`. The axiom audit
recursively traverses dependencies and rejects anything outside Lean's standard
logical axiom allowlist. This includes unfinished proof placeholders and native
evaluation axioms. `#eval` prints the search results for convenience; the search
certificates use `decide`, and `#eval` output is not proof evidence.

The Python inventory check is a maintenance aid, not a proof checker. Lean's
successful compilation and the dependency audit provide the formal verification.
