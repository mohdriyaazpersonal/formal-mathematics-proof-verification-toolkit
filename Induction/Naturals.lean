import Mathlib.Tactic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

/-! # Induction on natural numbers (beginner/intermediate)
These proofs explicitly expose the base case and successor step, even where
Mathlib already supplies the result.
-/
namespace FormalToolkit.Induction

/-- Zero plus n is n; addition reduces in the base case and respects successor. -/
theorem zero_add_by_induction (n : ℕ) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ n ih => simpa only [Nat.add_succ] using congrArg Nat.succ ih

/-- Adding n copies of two equals doubling n; the successor step is arithmetic. -/
theorem two_mul_by_induction (n : ℕ) : 2 * n = n + n := by
  induction n with
  | zero => rfl
  | succ n ih => omega

/-- A recursively defined count of the first n odd numbers. -/
def oddSum : ℕ → ℕ
  | 0 => 0
  | n + 1 => oddSum n + (2 * n + 1)

/-- The sum of the first n odd numbers is n²; expand the successor square. -/
theorem oddSum_eq_square (n : ℕ) : oddSum n = n ^ 2 := by
  induction n with
  | zero => simp [oddSum]
  | succ n ih =>
    rw [oddSum, ih]
    ring

/-- Doubling by recursion agrees with multiplication. -/
def double : ℕ → ℕ
  | 0 => 0
  | n + 1 => double n + 2

/-- The recursive call is replaced using the induction hypothesis. -/
theorem double_eq (n : ℕ) : double n = 2 * n := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [double, ih]
    ring

/-- The elementary exponential bound follows from the previous bound and 2^n ≥ 1. -/
theorem successor_le_two_pow (n : ℕ) : n + 1 ≤ 2 ^ n := by
  induction n with
  | zero => norm_num
  | succ n ih =>
    rw [pow_succ]
    have hp : 0 < 2 ^ n := pow_pos (by decide) n
    omega
end FormalToolkit.Induction
