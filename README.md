# Formal Mathematics & Proof Verification Toolkit

[![Lean verification](https://github.com/mohdriyaazpersonal/formal-mathematics-proof-verification-toolkit/actions/workflows/lean.yml/badge.svg)](https://github.com/mohdriyaazpersonal/formal-mathematics-proof-verification-toolkit/actions/workflows/lean.yml)

A collection of **98 named mathematical theorems** in **Lean 4 and Mathlib**.
Explore mathematical logic, relations, functions, set theory, induction, algebra,
number theory, and discrete mathematics—and identify claims whose assumptions
are insufficient.

The project combines informal proof ideas, explicit hypotheses, reusable Lean
proofs, **ten documented counterexamples**, and an executable two-point model search.
There are no unfinished proof exercises in the build.

## Explore the website

[Open the public proof workspace](https://formal-mathematics-toolkit.mohddriyaaz.chatgpt.site)

Browse and search all 98 theorems, read proof explanations and complete Lean modules,
and explore a two-point relation in the interactive counterexample lab. The website
is a reader and finite-model demonstration; Lean verification runs in this repository.
See [`web/README.md`](web/README.md) for local preview and data-refresh instructions.

## Getting started

Install [elan](https://github.com/leanprover/elan#installation), Git, and Python 3.
For an interactive proof state, install VS Code and its recommended **Lean 4** extension.

```sh
git clone https://github.com/mohdriyaazpersonal/formal-mathematics-proof-verification-toolkit.git
cd formal-mathematics-proof-verification-toolkit
lake exe cache get
lake build
python3 scripts/check_project.py
```

Lean **4.24.0** and Mathlib **v4.24.0** are intentionally pinned together.
`lean-toolchain` selects Lean; `lake-manifest.json` locks exact dependency revisions.
The first run downloads the compiler, dependencies, and Mathlib cache and requires
internet access and several GB of disk space. Subsequent builds reuse them.
See the official [Lean project setup guide](https://leanprover-community.github.io/install/project.html).

Open this repository's root folder in VS Code, then open a `.lean` file. Move the
cursor through a tactic proof to inspect the hypotheses and remaining goals.

## Why Lean?

A mathematical proposition becomes a type, and a proof becomes a term of that
type. Lean's kernel checks the term against the proposition. Tactics construct
these terms; successful automation still has to produce a checkable proof.
Mathlib provides reusable definitions, theorems, and tactics, letting this toolkit
focus on mathematical reasoning rather than rebuilding the foundations.

An invalid universal claim is handled by proving its negation or constructing
a model where its assumptions hold and its conclusion fails. This differs from
independence from a foundational axiom system; no independence claim is made here.

## Topics and learning path

| Folder | Topics | Named theorems | Level |
| --- | --- | ---: | --- |
| [`Logic/`](Logic) | Connectives, contraposition, contradiction, quantifiers, witnesses | 17 | Beginner |
| [`Relations/`](Relations) | Predicate transport, equivalences, preorders, antisymmetry | 11 | Intermediate–advanced |
| [`Functions/`](Functions) | Injectivity, surjectivity, composition, inverses | 7 | Beginner–intermediate |
| [`Sets/`](Sets) | Union, intersection, inclusion, difference, images, preimages | 9 | Beginner–intermediate |
| [`Induction/`](Induction) | Recursive functions, odd sums, triangular sums, exponential bounds | 9 | Intermediate |
| [`Algebra/`](Algebra) | Polynomial identities and inequalities with sign assumptions | 8 | Intermediate |
| [`NumberTheory/`](NumberTheory) | Parity, divisibility, primes, GCD, modular arithmetic | 11 | Intermediate |
| [`DiscreteMath/`](DiscreteMath) | Finite graphs, inclusion-exclusion, pigeonhole, Boolean laws, sequences | 9 | Intermediate–advanced |
| [`Counterexamples/`](Counterexamples) | Ten invalid claims, supporting lemmas, finite model search | 17 | Intermediate–advanced |
| [`Tests/`](Tests) | Integration regressions and transitive axiom audit | — | Advanced |

Start with `Logic/Propositional.lean`, then `Logic/Predicates.lean` and
`Relations/Transport.lean`. Pair the transport lesson with
`Counterexamples/Transport.lean`. Continue through sets and induction before
exploring `Relations/Structures.lean`, `Algebra/Identities.lean`, and the finite search.
The induction folder contains seven explicit induction proofs.

## Example: compose two implications

If P implies Q and Q implies R, then P implies R. Apply the first implication to
a proof of P, then feed its result to the second implication.

```lean
theorem implication_chain {P Q R : Prop} :
    (P → Q) → (Q → R) → P → R := by
  intro hPQ hQR hP
  exact hQR (hPQ hP)
```

See [`Logic/Propositional.lean`](Logic/Propositional.lean) for this theorem and paired
term/tactic proofs. For example, `fun hP _ => hP` and `by intro hP _; exact hP`
express the same proof of `P → Q → P`: both elaborate to a function returning
the first hypothesis. Proof styles differ in presentation, not in what the kernel checks.

## Counterexample analysis: symmetry versus transitivity

Suppose `forward : ∀ {x y}, R x y → P x → P y`.
With `symm : ∀ {x y}, R x y → R y x`, backward transport is immediate:

```lean
example {a b : α} (hR : R a b) (hb : P b) : P a := by
  exact forward (symm hR) hb
```

**Transitivity allows two forward relation steps to be combined, but it does not
reverse the direction of a relation. Therefore `R a b` does not provide `R b a`.**

The checked model uses `Bool`, with `a = false`, `b = true`,
`R x y := x = false ∨ y = true`, and `P x := x = true`.

| R | a | b |
| --- | --- | --- |
| a | true | true |
| b | false | true |

The relation is reflexive and transitive. Forward transport holds, because the
only point satisfying P is b and its only outgoing edge leads back to b.
Yet `R a b` and `P b` hold while `P a` is false. The Lean file separately proves
the assumptions and formally negates the desired conclusion.

[`Counterexamples/InvalidClaims.lean`](Counterexamples/InvalidClaims.lean) also covers
injective-but-not-surjective successor, an invalid converse implication,
symmetric-but-not-transitive distinctness, a transitive nonreflexive empty
relation, a noninjective constant function, squaring negative numbers,
incompatible existential witnesses, and union versus intersection.

Run the bounded model search:

```sh
lake env lean Counterexamples/FiniteSearch.lean
```

The printed pairs encode a relation mask and a predicate mask. It enumerates all
16 Boolean relations × 4 Boolean predicates and filters for transitive,
forward-preserving models where backward transport fails. Search soundness and
the presence of the documented model `(11, 2)` are formally proved. This search
is exhaustive for that finite universe; it is not a general counterexample solver.

## Verification and trust

`lake build` compiles every topic and both test modules through `FormalToolkit.lean`.
Warnings are errors. The source check enforces module coverage, minimum theorem
counts, at least five explicit induction proofs, and rejection of proof placeholders.

`Tests/AxiomAudit.lean` inspects every theorem under the `FormalToolkit` namespace
and its transitive dependencies. Only the standard logical axioms `propext`,
`Classical.choice`, and `Quot.sound` are permitted. Some constructive proofs use
none of these; classical results explicitly use classical reasoning. No custom
axioms, placeholder axioms, or native evaluation axioms are accepted.

[GitHub Actions](.github/workflows/lean.yml) runs the source checks, full build,
and trust audit on every push and pull request. A broken proof fails CI.
`Tests/Regression.lean` checks boundary values and combines APIs from different topics.

For reusable imports, use `import Toolkit`; `import FormalToolkit` additionally
includes the verification suite.

## Proof techniques and contributing

See [the proof guide](docs/PROOF_GUIDE.md) for tactic selection, classical reasoning,
natural-number division, and the counterexample method. See the
[theorem catalog](docs/THEOREMS.md) for the complete declaration inventory.

To extend the library, add documented theorems in the appropriate namespace.
For a new topic file, add its import to `Toolkit.lean`; for a new test file, add
its import to `FormalToolkit.lean`. Run the verification commands above before
submitting a change. Keep compiler and Mathlib versions matched when upgrading.

**Technologies:** Lean 4, Mathlib, Git, GitHub Actions, Python 3 (source inventory),
and VS Code with the Lean extension.

## License

MIT; see [LICENSE](LICENSE). Dependencies retain their own licenses.
