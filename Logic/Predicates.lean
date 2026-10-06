import Mathlib.Tactic

/-! # Predicates and witnesses (beginner/intermediate) -/
namespace FormalToolkit.Logic
variable {α : Type*} {P Q : α → Prop}

/-- Specialize a universal implication at a and apply it to the given proof. -/
theorem specialize (h : ∀ x, P x → Q x) {a : α} (ha : P a) : Q a := h a ha

/-- An actual element and its property construct an existential witness. -/
theorem witness {a : α} (ha : P a) : ∃ x, P x := ⟨a, ha⟩

/-- Transport an existential witness through a pointwise implication. -/
theorem exists_map (h : ∀ x, P x → Q x) : (∃ x, P x) → ∃ x, Q x := by
  rintro ⟨x, hx⟩
  exact ⟨x, h x hx⟩

/-- Pointwise conjunction yields two universal statements and conversely. -/
theorem forall_and : (∀ x, P x ∧ Q x) ↔ (∀ x, P x) ∧ (∀ x, Q x) := by
  constructor
  · intro h
    exact ⟨fun x => (h x).1, fun x => (h x).2⟩
  · rintro ⟨hP, hQ⟩ x
    exact ⟨hP x, hQ x⟩

/-- No witness exists precisely when every candidate is ruled out. -/
theorem not_exists : (¬∃ x, P x) ↔ ∀ x, ¬P x := by
  constructor
  · intro h x hx
    exact h ⟨x, hx⟩
  · rintro h ⟨x, hx⟩
    exact h x hx
end FormalToolkit.Logic
