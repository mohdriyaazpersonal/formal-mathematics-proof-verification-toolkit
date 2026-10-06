import Mathlib.Tactic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.ModEq

/-! # Parity by witnesses (beginner/intermediate)
Even n means n = k + k, and Odd n means n = 2*k + 1, for some k.
-/
namespace FormalToolkit.NumberTheory

/-- Add the half-witnesses of two even naturals. -/
theorem even_add {m n : ℕ} (hm : Even m) (hn : Even n) : Even (m + n) := by
  obtain ⟨a, rfl⟩ := hm
  obtain ⟨b, rfl⟩ := hn
  exact ⟨a + b, by ring⟩

/-- Adding an even number to an odd one retains the single odd unit. -/
theorem even_add_odd {m n : ℕ} (hm : Even m) (hn : Odd n) : Odd (m + n) := by
  obtain ⟨a, rfl⟩ := hm
  obtain ⟨b, rfl⟩ := hn
  exact ⟨a + b, by ring⟩

/-- Two odd units combine into an additional pair. -/
theorem odd_add_odd {m n : ℕ} (hm : Odd m) (hn : Odd n) : Even (m + n) := by
  obtain ⟨a, rfl⟩ := hm
  obtain ⟨b, rfl⟩ := hn
  exact ⟨a + b + 1, by ring⟩

/-- The product of an even natural with any natural is even. -/
theorem even_mul {m : ℕ} (hm : Even m) (n : ℕ) : Even (m * n) := by
  obtain ⟨a, rfl⟩ := hm
  exact ⟨a * n, by ring⟩
end FormalToolkit.NumberTheory
