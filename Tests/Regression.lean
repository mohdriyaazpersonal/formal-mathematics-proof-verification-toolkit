import Relations.Transport
import Relations.Structures
import Functions.Composition
import Sets.Images
import Induction.Summation
import Algebra.Identities
import NumberTheory.Parity
import Counterexamples.Transport
import Counterexamples.FiniteSearch

/-! # Integration regressions
Specialize generic theorems at concrete types and check boundary values.
These examples exercise API composition as well as the individual source modules.
-/
namespace FormalToolkit.Tests

example : Induction.triangular 0 = 0 := rfl
example : Induction.triangular 10 = 55 := by decide
example : (∑ k ∈ Finset.range 101, k) = 5050 := by
  rw [Induction.sum_range_formula]

example : Function.Injective (Nat.succ ∘ Nat.succ) :=
  Functions.injective_comp Nat.succ_injective Nat.succ_injective

example (a b : ℤ) : (a+b)^2 = a^2 + 2*a*b + b^2 := Algebra.square_add a b

example : Odd (12 + 7 : ℕ) :=
  NumberTheory.even_add_odd (by decide) (by decide)

example : Equivalence (Relations.sameImage (fun n : ℕ => n % 3)) :=
  Relations.sameImage_equivalence _

example {α : Type*} (R : α → α → Prop) (P : α → Prop)
    (forward : ∀ {x y}, R x y → P x → P y)
    (symm : ∀ {x y}, R x y → R y x) {a b : α} (hab : R a b) (hb : P b) : P a :=
  Relations.backward_transport R P forward symm hab hb

example : ¬(∀ {a b : Bool}, Counterexamples.ordered a b →
    Counterexamples.upper b → Counterexamples.upper a) :=
  Counterexamples.backward_transport_fails

example : ((11 : Fin 16), (2 : Fin 4)) ∈ Counterexamples.countermodels :=
  Counterexamples.ordered_model_found
end FormalToolkit.Tests
