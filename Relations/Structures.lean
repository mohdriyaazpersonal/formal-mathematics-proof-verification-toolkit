import Mathlib.Tactic

/-! # Equivalence relations and preorders (intermediate/advanced) -/
namespace FormalToolkit.Relations
variable {α β : Type*}

/-- Equality of function outputs induces an equivalence relation on inputs. -/
def sameImage (f : α → β) (x y : α) : Prop := f x = f y

/-- Reflexivity follows from reflexivity of equality. -/
theorem sameImage_refl (f : α → β) : Reflexive (sameImage f) := fun _ => rfl

/-- Symmetry follows by reversing an equality of outputs. -/
theorem sameImage_symm (f : α → β) : Symmetric (sameImage f) := fun _ _ h => h.symm

/-- Transitivity follows by composing two output equalities. -/
theorem sameImage_trans (f : α → β) : Transitive (sameImage f) :=
  fun _ _ _ h₁ h₂ => h₁.trans h₂

/-- Package all three laws into Lean's Equivalence structure. -/
theorem sameImage_equivalence (f : α → β) : Equivalence (sameImage f) :=
  ⟨sameImage_refl f, fun h => sameImage_symm f h,
    fun h₁ h₂ => sameImage_trans f h₁ h₂⟩

/-- Pulling ≤ back along a numeric rank gives a preorder, possibly with ties. -/
def rankPreorder (rank : α → ℕ) : Preorder α where
  le x y := rank x ≤ rank y
  le_refl _ := le_rfl
  le_trans _ _ _ := le_trans

/-- Natural-number order is antisymmetric: mutual bounds force equality. -/
theorem nat_antisymmetric : ∀ a b : ℕ, a ≤ b → b ≤ a → a = b := by
  intro a b hab hba
  exact Nat.le_antisymm hab hba

/-- Mutual reachability in any preorder is an equivalence relation. -/
theorem mutual_equivalence [Preorder α] :
    Equivalence (fun x y : α => x ≤ y ∧ y ≤ x) := by
  constructor
  · intro x
    exact ⟨le_rfl, le_rfl⟩
  · intro x y h
    exact ⟨h.2, h.1⟩
  · intro x y z hxy hyz
    exact ⟨le_trans hxy.1 hyz.1, le_trans hyz.2 hxy.2⟩
end FormalToolkit.Relations
