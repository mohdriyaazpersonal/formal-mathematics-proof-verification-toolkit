import Mathlib.Tactic

/-! # Function composition (beginner/intermediate) -/
namespace FormalToolkit.Functions
variable {α β γ : Type*} {f : α → β} {g : β → γ}

/-- Cancel g and then f from equality of composite outputs. -/
theorem injective_comp (hf : Function.Injective f) (hg : Function.Injective g) :
    Function.Injective (g ∘ f) := by
  intro x y h
  apply hf
  apply hg
  exact h

/-- Choose a preimage through g, then a preimage through f. -/
theorem surjective_comp (hf : Function.Surjective f) (hg : Function.Surjective g) :
    Function.Surjective (g ∘ f) := by
  intro z
  obtain ⟨y, hy⟩ := hg z
  obtain ⟨x, hx⟩ := hf y
  exact ⟨x, by simp [hx, hy]⟩

/-- Bijectivity combines the two independently proved composition laws. -/
theorem bijective_comp (hf : Function.Bijective f) (hg : Function.Bijective g) :
    Function.Bijective (g ∘ f) :=
  ⟨injective_comp hf.1 hg.1, surjective_comp hf.2 hg.2⟩

/-- Identity is bijective: equality is unchanged and each point is its preimage. -/
theorem identity_bijective : Function.Bijective (id : α → α) :=
  ⟨fun _ _ h => h, fun x => ⟨x, rfl⟩⟩
end FormalToolkit.Functions
