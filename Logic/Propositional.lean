import Mathlib.Tactic

/-! # Propositional logic (beginner)
Each theorem constructs a proof from its stated hypotheses. Term and tactic proofs
elaborate to proof terms checked by the same Lean kernel.
-/
namespace FormalToolkit.Logic
variable {P Q R : Prop}

/-- Retaining the first hypothesis needs no assumption on the second proposition. -/
theorem keep_left : P → Q → P := fun hP _ => hP

/-- The same proof with introductions: the resulting term is a lambda expression. -/
theorem keep_left_tactic : P → Q → P := by
  intro hP _
  exact hP

/-- Implications compose by applying the first implication, then the second. -/
theorem implication_chain : (P → Q) → (Q → R) → P → R := by
  intro hPQ hQR hP
  exact hQR (hPQ hP)

/-- Swap the projections of a conjunction to build the reversed conjunction. -/
theorem and_comm_term : P ∧ Q → Q ∧ P := fun h => ⟨h.2, h.1⟩

/-- `constructor` creates the two obligations of the conjunction. -/
theorem and_comm_tactic : P ∧ Q → Q ∧ P := by
  intro h
  constructor
  · exact h.2
  · exact h.1

/-- A disjunction is handled by cases, introducing the opposite branch. -/
theorem or_comm : P ∨ Q → Q ∨ P := by
  intro h
  cases h with
  | inl hP => exact Or.inr hP
  | inr hQ => exact Or.inl hQ

/-- Contraposition is constructive: a hypothetical P would contradict ¬Q. -/
theorem contrapositive (h : P → Q) : ¬Q → ¬P := by
  intro hnQ hP
  exact hnQ (h hP)

/-- Introducing double negation is constructive. -/
theorem double_neg_intro : P → ¬¬P := fun hP hnP => hnP hP

/-- Eliminating double negation uses classical proof by contradiction. -/
theorem double_neg_elim : ¬¬P → P := by
  intro h
  by_contra hnP
  exact h hnP

/-- De Morgan for a negated disjunction requires no classical assumptions. -/
theorem not_or : ¬(P ∨ Q) ↔ ¬P ∧ ¬Q := by
  constructor
  · intro h
    exact ⟨fun hP => h (Or.inl hP), fun hQ => h (Or.inr hQ)⟩
  · rintro ⟨hnP, hnQ⟩ (hP | hQ)
    · exact hnP hP
    · exact hnQ hQ

/-- This direction of De Morgan uses classical case analysis on P. -/
theorem not_and_classical : ¬(P ∧ Q) → ¬P ∨ ¬Q := by
  classical
  intro h
  by_cases hP : P
  · exact Or.inr (fun hQ => h ⟨hP, hQ⟩)
  · exact Or.inl hP

/-- `aesop` automates introduction, case analysis, and constructor search. -/
theorem distribute : P ∧ (Q ∨ R) ↔ (P ∧ Q) ∨ (P ∧ R) := by
  aesop
end FormalToolkit.Logic
