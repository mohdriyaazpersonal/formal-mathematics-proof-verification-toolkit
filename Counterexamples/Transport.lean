import Mathlib.Tactic
import Mathlib.Data.Real.Basic

/-! # Why transitivity cannot replace symmetry (intermediate)
Proposed claim: a transitive relation and forward predicate preservation imply
backward predicate preservation. The two-point model below disproves it.
false plays a; true plays b. R x y means x implies y as Boolean truth values.
It is even reflexive, so adding reflexivity still cannot repair the claim.
-/
namespace FormalToolkit.Counterexamples

/-- The Boolean order has loops and the edge false → true, but no reverse edge. -/
def ordered (x y : Bool) : Prop := x = false ∨ y = true

/-- Only the upper point satisfies the predicate. -/
def upper (x : Bool) : Prop := x = true

/-- Check transitivity exhaustively on the eight triples of points. -/
theorem ordered_transitive : Transitive ordered := by
  simp only [Transitive, ordered]
  decide

/-- This countermodel is a preorder, making the failed converse especially explicit. -/
theorem ordered_reflexive : Reflexive ordered := by
  simp only [Reflexive, ordered]
  decide

/-- A true source cannot flow to a false target; every forward edge preserves P. -/
theorem ordered_forward : ∀ {x y : Bool}, ordered x y → upper x → upper y := by
  simp only [ordered, upper]
  decide

/-- Counterexample 1: transitive does not imply symmetric. -/
theorem transitive_not_symmetric : Transitive ordered ∧ ¬Symmetric ordered := by
  simp only [Transitive, Symmetric, ordered]
  decide

/-- Counterexample 2: all requested assumptions hold but backward transport fails.
The conjunction exposes the edge, missing reverse edge, and predicate truth values.
-/
theorem backward_transport_counterexample :
    Transitive ordered ∧
    (∀ {x y : Bool}, ordered x y → upper x → upper y) ∧
    ordered false true ∧ ¬ordered true false ∧ upper true ∧ ¬upper false := by
  simp only [Transitive, ordered, upper]
  decide

/-- Negate the proposed implication itself, rather than merely describing a bad model. -/
theorem backward_transport_fails :
    ¬(∀ {a b : Bool}, ordered a b → upper b → upper a) := by
  simp only [ordered, upper]
  decide
end FormalToolkit.Counterexamples
