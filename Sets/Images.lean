import Mathlib.Tactic
import Mathlib.Data.Set.Function

/-! # Images and preimages (intermediate) -/
namespace FormalToolkit.Sets
variable {α β : Type*} (f : α → β)

/-- Preimages preserve intersections because both sides assert two output memberships. -/
theorem preimage_inter (A B : Set β) : f ⁻¹' (A ∩ B) = (f ⁻¹' A) ∩ (f ⁻¹' B) := rfl

/-- A point of A witnesses membership of its image in f '' A. -/
theorem subset_preimage_image (A : Set α) : A ⊆ f ⁻¹' (f '' A) :=
  fun x hx => ⟨x, hx, rfl⟩

/-- An image witness in A remains a witness in its superset B. -/
theorem image_mono {A B : Set α} (h : A ⊆ B) : f '' A ⊆ f '' B := by
  rintro _ ⟨x, hx, rfl⟩
  exact ⟨x, h hx, rfl⟩

/-- Injectivity makes equal image witnesses equal, so images preserve intersections. -/
theorem image_inter_of_injective (hf : Function.Injective f) (A B : Set α) :
    f '' (A ∩ B) = (f '' A) ∩ (f '' B) := by
  ext y
  constructor
  · rintro ⟨x, ⟨ha, hb⟩, rfl⟩
    exact ⟨⟨x, ha, rfl⟩, ⟨x, hb, rfl⟩⟩
  · rintro ⟨⟨x, ha, hx⟩, ⟨z, hb, hz⟩⟩
    have h : x = z := hf (hx.trans hz.symm)
    subst z
    exact ⟨x, ⟨ha, hb⟩, hx⟩
end FormalToolkit.Sets
