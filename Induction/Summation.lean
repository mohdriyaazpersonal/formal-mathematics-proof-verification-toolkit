import Mathlib.Tactic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

/-! # Summation identities (intermediate/advanced)
Prove a division-free identity first: natural-number division then follows by
exact cancellation, rather than assuming division behaves like field division.
-/
namespace FormalToolkit.Induction

/-- triangular n computes 1 + 2 + ... + n, with the empty sum equal to zero. -/
def triangular : ℕ → ℕ
  | 0 => 0
  | n + 1 => triangular n + (n + 1)

/-- Multiplying the triangular sum by two gives n(n+1). -/
theorem twice_triangular (n : ℕ) : 2 * triangular n = n * (n + 1) := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [triangular, Nat.mul_add, ih]
    ring

/-- Exact cancellation justifies the usual formula in natural numbers. -/
theorem triangular_formula (n : ℕ) : triangular n = n * (n + 1) / 2 := by
  rw [← twice_triangular]
  omega

/-- Connect the recursive definition to Mathlib's finite sum, including 0. -/
theorem triangular_eq_sum (n : ℕ) :
    triangular n = ∑ k ∈ Finset.range (n + 1), k := by
  induction n with
  | zero => simp [triangular]
  | succ n ih =>
    rw [triangular, Finset.sum_range_succ, ih]

/-- The finite-sum version of 1 + ... + n = n(n+1)/2. -/
theorem sum_range_formula (n : ℕ) :
    (∑ k ∈ Finset.range (n + 1), k) = n * (n + 1) / 2 := by
  rw [← triangular_eq_sum, triangular_formula]
end FormalToolkit.Induction
