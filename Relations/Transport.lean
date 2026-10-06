import Mathlib.Tactic

/-! # Transport along relations (intermediate)
Forward transport follows a directed edge. Symmetry, rather than transitivity,
supplies the reversed edge required for backward transport.
-/
namespace FormalToolkit.Relations
variable {α : Type*}
variable (R : α → α → Prop) (P : α → Prop)
variable (forward : ∀ {x y : α}, R x y → P x → P y)

include forward

/-- A forward edge directly transports a proof of the source predicate. -/
theorem forward_transport {a b : α} (hR : R a b) (ha : P a) : P b :=
  forward hR ha

variable (symm : ∀ {x y : α}, R x y → R y x)

include symm

/-- Symmetry reverses the edge; forward transport then applies to P b. -/
theorem backward_transport {a b : α} (hR : R a b) (hb : P b) : P a := by
  exact forward (symm hR) hb

/-- Under symmetry, related points satisfy the predicate equivalently. -/
theorem predicate_iff {a b : α} (hR : R a b) : P a ↔ P b :=
  ⟨forward hR, forward (symm hR)⟩

omit symm

/-- Two successive transports need no transitivity assumption on R. -/
theorem two_step_transport {a b c : α} (hab : R a b) (hbc : R b c)
    (ha : P a) : P c := forward hbc (forward hab ha)

variable (trans : ∀ {x y z : α}, R x y → R y z → R x z)

omit forward
include trans

/-- Transitivity combines forward edges but supplies no edge in reverse. -/
theorem three_step_relation {a b c d : α} (hab : R a b) (hbc : R b c)
    (hcd : R c d) : R a d := trans (trans hab hbc) hcd
end FormalToolkit.Relations
