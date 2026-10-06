import Mathlib.Tactic
import Mathlib.Data.Real.Basic

/-! # Inequalities with explicit assumptions (intermediate)
`linarith` combines linear equalities/inequalities; `nlinarith` also preprocesses
polynomial expressions. Nonnegativity of squares is supplied explicitly.
-/
namespace FormalToolkit.Algebra

/-- Add two real inequalities by linear arithmetic. -/
theorem add_bounds (a b c d : ℝ) (hab : a ≤ b) (hcd : c ≤ d) : a + c ≤ b + d := by
  linarith

/-- A nonnegative difference square proves the two-variable quadratic bound. -/
theorem twice_mul_le_squares (a b : ℝ) : 2*a*b ≤ a^2 + b^2 := by
  nlinarith [sq_nonneg (a - b)]

/-- A square is monotone only with suitable sign assumptions. -/
theorem square_mono_nonnegative (a b : ℝ) (ha : 0 ≤ a) (hab : a ≤ b) : a^2 ≤ b^2 := by
  nlinarith
end FormalToolkit.Algebra
