import Mathlib.Tactic

/-! # Inverses and cancellation (intermediate) -/
namespace FormalToolkit.Functions
variable {α β γ : Type*} {f : α → β} {g : β → α}

/-- Applying a left inverse to equal outputs recovers equality of inputs. -/
theorem left_inverse_injective (h : Function.LeftInverse g f) :
    Function.Injective f := by
  intro x y hxy
  calc
    x = g (f x) := (h x).symm
    _ = g (f y) := congrArg g hxy
    _ = y := h y

/-- A right inverse explicitly provides a preimage of every point. -/
theorem right_inverse_surjective (h : Function.RightInverse g f) :
    Function.Surjective f := fun y => ⟨g y, h y⟩

/-- If a composite is injective, its first map must be injective. -/
theorem cancel_injective {k : β → γ} (h : Function.Injective (k ∘ f)) :
    Function.Injective f := by
  intro x y hxy
  exact h (congrArg k hxy)
end FormalToolkit.Functions
