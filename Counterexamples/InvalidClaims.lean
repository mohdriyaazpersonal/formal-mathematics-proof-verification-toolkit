import Mathlib.Tactic
import Mathlib.Data.Real.Basic

/-! # Eight further failed universal claims (beginner/intermediate)
Each theorem pairs satisfied assumptions with a failed conclusion, or formally
negates the universal claim. These are proofs of failure, not unfinished proofs.
-/
namespace FormalToolkit.Counterexamples

/-- Counterexample 3: successor is injective on ℕ but has no preimage of zero.
The infinite domain matters: injective endomaps of a finite type are surjective.
-/
theorem injective_not_surjective :
    Function.Injective Nat.succ ∧ ¬Function.Surjective Nat.succ := by
  constructor
  · exact Nat.succ_injective
  · intro h
    obtain ⟨n, hn⟩ := h 0
    exact Nat.succ_ne_zero n hn

/-- Counterexample 4: False implies True, but True cannot imply False. -/
theorem implication_not_converse : (False → True) ∧ ¬(True → False) :=
  ⟨fun h => h.elim, fun h => h trivial⟩

/-- Counterexample 5: distinctness on Bool is symmetric but not transitive.
false ≠ true and true ≠ false, whereas false ≠ false fails.
-/
theorem symmetric_not_transitive :
    Symmetric (fun x y : Bool => x ≠ y) ∧ ¬Transitive (fun x y : Bool => x ≠ y) := by
  simp only [Symmetric, Transitive]
  decide

/-- Counterexample 6: an empty relation is vacuously transitive but has no loops. -/
theorem transitive_not_reflexive :
    Transitive (fun _ _ : Bool => False) ∧ ¬Reflexive (fun _ _ : Bool => False) := by
  simp only [Transitive, Reflexive]
  decide

/-- Counterexample 7: a constant map merges two inputs, so arbitrary maps need not
be injective. The witness uses a finite two-point domain and codomain.
-/
theorem constant_not_injective : ¬Function.Injective (fun _ : Bool => false) := by
  decide

/-- Counterexample 8: squaring is not monotone on all reals; -2 ≤ -1 but 4 > 1.
The missing nonnegativity assumption is essential.
-/
theorem square_not_monotone : ¬(∀ a b : ℝ, a ≤ b → a^2 ≤ b^2) := by
  intro h
  have bad := h (-2) (-1) (by norm_num)
  norm_num at bad

/-- Counterexample 9: separate existential witnesses need not be the same witness.
On Bool, one predicate holds only at false and the other only at true.
-/
theorem exists_and_not_distributive :
    ((∃ x : Bool, x = false) ∧ (∃ x : Bool, x = true)) ∧
    ¬(∃ x : Bool, x = false ∧ x = true) := by decide

/-- Counterexample 10: union membership need not imply intersection membership.
The point false belongs to {false} ∪ {true}, but not to their intersection.
-/
theorem union_not_intersection :
    ¬(∀ A B : Set Bool, A ∪ B ⊆ A ∩ B) := by
  intro h
  have bad := h {false} {true} (show false ∈ ({false} : Set Bool) ∪ {true} from
    Or.inl (by simp))
  simpa using bad.2
end FormalToolkit.Counterexamples
