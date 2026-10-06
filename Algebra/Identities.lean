import Mathlib.Tactic
import Mathlib.Data.Real.Basic

/-! # Polynomial identities (beginner/intermediate)
`ring` proves equality by polynomial normalization over a commutative ring.
`ring_nf` normalizes expressions in the context or goal for subsequent steps.
-/
namespace FormalToolkit.Algebra
variable {A : Type*} [CommRing A]

/-- The square of a sum expands by distributivity; no order assumption is needed. -/
theorem square_add (a b : A) : (a + b) ^ 2 = a ^ 2 + 2 * a * b + b ^ 2 := by
  ring

/-- Difference of squares factors in every commutative ring. -/
theorem difference_squares (a b : A) : a ^ 2 - b ^ 2 = (a - b) * (a + b) := by
  ring

/-- A cubic binomial identity is also a polynomial normalization problem. -/
theorem cube_add (a b : A) :
    (a + b) ^ 3 = a ^ 3 + 3 * a ^ 2 * b + 3 * a * b ^ 2 + b ^ 3 := by
  ring

/-- The two-square identity is an algebraic ingredient of norm multiplication. -/
theorem two_squares (a b c d : A) :
    (a*a + b*b) * (c*c + d*d) = (a*c - b*d)^2 + (a*d + b*c)^2 := by
  ring

/-- Normalize the square in the hypothesis, then use that normalized equality. -/
theorem normalized_hypothesis (a b : ℚ) (h : (a + b)^2 = 0) :
    a^2 + 2*a*b + b^2 = 0 := by
  ring_nf at h ⊢
  exact h
end FormalToolkit.Algebra
