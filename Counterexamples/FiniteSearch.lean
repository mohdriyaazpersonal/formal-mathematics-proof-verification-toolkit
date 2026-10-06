import Mathlib.Tactic
import Mathlib.Data.Real.Basic

/-! # Executable bounded counterexample search (advanced)
Enumerate all 16 relations and all 4 predicates on Bool. Bit positions encode
(false,false), (false,true), (true,false), (true,true), in that order.
This is exhaustive for this two-element universe only, not a general theorem prover.
-/
namespace FormalToolkit.Counterexamples

def boolIndex (b : Bool) : ℕ := if b then 1 else 0

def relationOfMask (mask : Fin 16) (x y : Bool) : Prop :=
  mask.val.testBit (2 * boolIndex x + boolIndex y) = true

def predicateOfMask (mask : Fin 4) (x : Bool) : Prop :=
  mask.val.testBit (boolIndex x) = true

/-- A candidate must satisfy transitivity and forward preservation and fail backward preservation. -/
def isCountermodel (r : Fin 16) (p : Fin 4) : Prop :=
  (∀ x y z, relationOfMask r x y → relationOfMask r y z → relationOfMask r x z) ∧
  (∀ x y, relationOfMask r x y → predicateOfMask p x → predicateOfMask p y) ∧
  (∃ a b, relationOfMask r a b ∧ predicateOfMask p b ∧ ¬predicateOfMask p a)

instance (r : Fin 16) (p : Fin 4) : Decidable (isCountermodel r p) := by
  unfold isCountermodel relationOfMask predicateOfMask
  infer_instance

/-- All 64 candidates are filtered by the decidable mathematical specification. -/
def countermodels : List (Fin 16 × Fin 4) :=
  ((List.finRange 16).flatMap fun r => (List.finRange 4).map fun p => (r, p)).filter
    (fun rp => decide (isCountermodel rp.1 rp.2))

/-- The search succeeds, checked by Lean's kernel reduction. -/
theorem search_nonempty : countermodels ≠ [] := by decide

/-- Mask 11 has the two loops and false → true; predicate mask 2 selects true. -/
theorem ordered_model_found : ((11 : Fin 16), (2 : Fin 4)) ∈ countermodels := by decide

/-- Every returned candidate meets the specification; the filter cannot report a false positive. -/
theorem search_sound {rp : Fin 16 × Fin 4} (h : rp ∈ countermodels) :
    isCountermodel rp.1 rp.2 := by
  have hf := (List.mem_filter.mp h).2
  exact of_decide_eq_true hf

-- Run with: lake env lean Counterexamples/FiniteSearch.lean
#eval countermodels.map (fun (r, p) => (r.val, p.val))
end FormalToolkit.Counterexamples
