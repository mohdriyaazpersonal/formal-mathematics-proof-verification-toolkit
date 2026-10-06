import Mathlib.Tactic
import Mathlib.Data.Finset.Card

/-! # Finite sets and graph-style relations (intermediate/advanced) -/
namespace FormalToolkit.DiscreteMath

/-- A graph on three vertices, with adjacency given by distinctness. -/
def adjacent (u v : Fin 3) : Prop := u ≠ v

/-- Every edge can be reversed in this undirected graph. -/
theorem adjacent_symmetric : Symmetric adjacent := fun _ _ h => Ne.symm h

/-- There are no self-loops, since no vertex differs from itself. -/
theorem adjacent_irreflexive : Irreflexive adjacent := fun _ h => h rfl

/-- Vertices 0 and 1 share an edge; the finite calculation is decidable. -/
theorem sample_edge : adjacent 0 1 := by
  unfold adjacent
  decide

/-- Inclusion-exclusion counts two finite sets without double-counting overlap. -/
theorem inclusion_exclusion {α : Type*} [DecidableEq α] (A B : Finset α) :
    (A ∪ B).card + (A ∩ B).card = A.card + B.card :=
  Finset.card_union_add_card_inter A B

/-- The graph has exactly three vertices, expressed using finite cardinality. -/
theorem vertex_count : Fintype.card (Fin 3) = 3 := by simp

/-- Among three Boolean values two coincide: finite pigeonhole by case analysis. -/
theorem boolean_pigeonhole (a b c : Bool) : a = b ∨ a = c ∨ b = c := by
  cases a <;> cases b <;> cases c <;> decide
end FormalToolkit.DiscreteMath
