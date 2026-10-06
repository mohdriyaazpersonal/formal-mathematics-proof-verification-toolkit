import Mathlib.Tactic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.ModEq

/-! # Divisibility, primes, GCD, and congruences (intermediate) -/
namespace FormalToolkit.NumberTheory

/-- Common divisibility is preserved under addition, by adding factor witnesses. -/
theorem divides_add {d a b : ℕ} (ha : d ∣ a) (hb : d ∣ b) : d ∣ a + b := by
  obtain ⟨x, rfl⟩ := ha
  obtain ⟨y, rfl⟩ := hb
  exact ⟨x + y, by ring⟩

/-- Compose factor witnesses to prove divisibility is transitive. -/
theorem divides_trans {a b c : ℕ} (hab : a ∣ b) (hbc : b ∣ c) : a ∣ c := by
  obtain ⟨x, rfl⟩ := hab
  obtain ⟨y, rfl⟩ := hbc
  exact ⟨x * y, by ring⟩

/-- Mathlib's GCD characterization yields both required divisibilities. -/
theorem gcd_divides_both (a b : ℕ) : Nat.gcd a b ∣ a ∧ Nat.gcd a b ∣ b :=
  ⟨Nat.gcd_dvd_left a b, Nat.gcd_dvd_right a b⟩

/-- A concrete primality certificate is checked by norm_num. -/
theorem prime_seventeen : Nat.Prime 17 := by norm_num

/-- A prime's only natural divisors are one and itself, from its defining property. -/
theorem prime_divisor {p d : ℕ} (hp : Nat.Prime p) (hd : d ∣ p) : d = 1 ∨ d = p :=
  (Nat.dvd_prime hp).mp hd

/-- Congruence modulo five remains true after adding any common offset. -/
theorem congruence_add (a b c : ℕ) (h : Nat.ModEq 5 a b) :
    Nat.ModEq 5 (a + c) (b + c) := h.add_right c

/-- A concrete residue computation is decidable and checked by the kernel. -/
theorem residue_example : Nat.ModEq 7 100 2 := by decide
end FormalToolkit.NumberTheory
