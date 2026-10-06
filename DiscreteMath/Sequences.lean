import Mathlib.Tactic
import Mathlib.Data.Finset.Card

/-! # Recursive sequences and Boolean laws (beginner/intermediate) -/
namespace FormalToolkit.DiscreteMath

/-- Number of binary strings: each new position doubles the choices. -/
def binaryWords : ℕ → ℕ
  | 0 => 1
  | n + 1 => 2 * binaryWords n

/-- The recurrence agrees with the closed form 2^n, proved by induction. -/
theorem binaryWords_eq (n : ℕ) : binaryWords n = 2 ^ n := by
  induction n with
  | zero => rfl
  | succ n ih => simp [binaryWords, ih, pow_succ, Nat.mul_comm]

/-- Boolean negation is an involution, checked on both possible values. -/
theorem not_not (b : Bool) : (!(!b)) = b := by cases b <;> rfl

/-- Boolean De Morgan's law is exhaustive case analysis on a two-element type. -/
theorem boolean_deMorgan (a b : Bool) : (!(a && b)) = ((!a) || (!b)) := by
  cases a <;> cases b <;> rfl
end FormalToolkit.DiscreteMath
