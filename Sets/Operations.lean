import Mathlib.Tactic
import Mathlib.Data.Set.Function

/-! # Set operations (beginner)
Set inclusion is a function transporting membership proofs; set equality uses extensionality.
-/
namespace FormalToolkit.Sets
variable {α : Type*} (A B C : Set α)

/-- Intersection membership contains a proof of membership in A. -/
theorem inter_subset_left : A ∩ B ⊆ A := fun _ h => h.1

/-- Union membership is a disjunction, here introduced on the left. -/
theorem subset_union_left : A ⊆ A ∪ B := fun _ h => Or.inl h

/-- Extensionality reduces equality of sets to pointwise logical equivalence. -/
theorem inter_comm : A ∩ B = B ∩ A := by
  ext x
  exact and_comm

/-- Distribute membership using propositional case analysis automated by aesop. -/
theorem inter_union_distrib : A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C) := by
  ext x
  simp only [Set.mem_inter_iff, Set.mem_union]
  aesop

/-- A point in A minus B cannot also lie in B. -/
theorem difference_disjoint : (A \ B) ∩ B = ∅ := by
  ext x
  simp only [Set.mem_inter_iff, Set.mem_diff, Set.mem_empty_iff_false, iff_false]
  exact fun h => h.1.2 h.2
end FormalToolkit.Sets
