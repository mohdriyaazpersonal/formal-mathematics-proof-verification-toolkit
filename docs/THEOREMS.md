# Theorem catalog

Generated from named theorem declarations with `python3 scripts/theorem_catalog.py`.
Each source declaration includes its statement and proof idea. Supporting lemmas
and alternate proof styles count separately; anonymous regression examples do not.

## Logic

### [Predicates.lean](../Logic/Predicates.lean)

- `FormalToolkit.Logic.specialize`
- `FormalToolkit.Logic.witness`
- `FormalToolkit.Logic.exists_map`
- `FormalToolkit.Logic.forall_and`
- `FormalToolkit.Logic.not_exists`

### [Propositional.lean](../Logic/Propositional.lean)

- `FormalToolkit.Logic.keep_left`
- `FormalToolkit.Logic.keep_left_tactic`
- `FormalToolkit.Logic.implication_chain`
- `FormalToolkit.Logic.and_comm_term`
- `FormalToolkit.Logic.and_comm_tactic`
- `FormalToolkit.Logic.or_comm`
- `FormalToolkit.Logic.contrapositive`
- `FormalToolkit.Logic.double_neg_intro`
- `FormalToolkit.Logic.double_neg_elim`
- `FormalToolkit.Logic.not_or`
- `FormalToolkit.Logic.not_and_classical`
- `FormalToolkit.Logic.distribute`

## Relations

### [Structures.lean](../Relations/Structures.lean)

- `FormalToolkit.Relations.sameImage_refl`
- `FormalToolkit.Relations.sameImage_symm`
- `FormalToolkit.Relations.sameImage_trans`
- `FormalToolkit.Relations.sameImage_equivalence`
- `FormalToolkit.Relations.nat_antisymmetric`
- `FormalToolkit.Relations.mutual_equivalence`

### [Transport.lean](../Relations/Transport.lean)

- `FormalToolkit.Relations.forward_transport`
- `FormalToolkit.Relations.backward_transport`
- `FormalToolkit.Relations.predicate_iff`
- `FormalToolkit.Relations.two_step_transport`
- `FormalToolkit.Relations.three_step_relation`

## Functions

### [Composition.lean](../Functions/Composition.lean)

- `FormalToolkit.Functions.injective_comp`
- `FormalToolkit.Functions.surjective_comp`
- `FormalToolkit.Functions.bijective_comp`
- `FormalToolkit.Functions.identity_bijective`

### [Inverses.lean](../Functions/Inverses.lean)

- `FormalToolkit.Functions.left_inverse_injective`
- `FormalToolkit.Functions.right_inverse_surjective`
- `FormalToolkit.Functions.cancel_injective`

## Sets

### [Images.lean](../Sets/Images.lean)

- `FormalToolkit.Sets.preimage_inter`
- `FormalToolkit.Sets.subset_preimage_image`
- `FormalToolkit.Sets.image_mono`
- `FormalToolkit.Sets.image_inter_of_injective`

### [Operations.lean](../Sets/Operations.lean)

- `FormalToolkit.Sets.inter_subset_left`
- `FormalToolkit.Sets.subset_union_left`
- `FormalToolkit.Sets.inter_comm`
- `FormalToolkit.Sets.inter_union_distrib`
- `FormalToolkit.Sets.difference_disjoint`

## Induction

### [Naturals.lean](../Induction/Naturals.lean)

- `FormalToolkit.Induction.zero_add_by_induction`
- `FormalToolkit.Induction.two_mul_by_induction`
- `FormalToolkit.Induction.oddSum_eq_square`
- `FormalToolkit.Induction.double_eq`
- `FormalToolkit.Induction.successor_le_two_pow`

### [Summation.lean](../Induction/Summation.lean)

- `FormalToolkit.Induction.twice_triangular`
- `FormalToolkit.Induction.triangular_formula`
- `FormalToolkit.Induction.triangular_eq_sum`
- `FormalToolkit.Induction.sum_range_formula`

## Algebra

### [Identities.lean](../Algebra/Identities.lean)

- `FormalToolkit.Algebra.square_add`
- `FormalToolkit.Algebra.difference_squares`
- `FormalToolkit.Algebra.cube_add`
- `FormalToolkit.Algebra.two_squares`
- `FormalToolkit.Algebra.normalized_hypothesis`

### [Inequalities.lean](../Algebra/Inequalities.lean)

- `FormalToolkit.Algebra.add_bounds`
- `FormalToolkit.Algebra.twice_mul_le_squares`
- `FormalToolkit.Algebra.square_mono_nonnegative`

## NumberTheory

### [Divisibility.lean](../NumberTheory/Divisibility.lean)

- `FormalToolkit.NumberTheory.divides_add`
- `FormalToolkit.NumberTheory.divides_trans`
- `FormalToolkit.NumberTheory.gcd_divides_both`
- `FormalToolkit.NumberTheory.prime_seventeen`
- `FormalToolkit.NumberTheory.prime_divisor`
- `FormalToolkit.NumberTheory.congruence_add`
- `FormalToolkit.NumberTheory.residue_example`

### [Parity.lean](../NumberTheory/Parity.lean)

- `FormalToolkit.NumberTheory.even_add`
- `FormalToolkit.NumberTheory.even_add_odd`
- `FormalToolkit.NumberTheory.odd_add_odd`
- `FormalToolkit.NumberTheory.even_mul`

## DiscreteMath

### [FiniteModels.lean](../DiscreteMath/FiniteModels.lean)

- `FormalToolkit.DiscreteMath.adjacent_symmetric`
- `FormalToolkit.DiscreteMath.adjacent_irreflexive`
- `FormalToolkit.DiscreteMath.sample_edge`
- `FormalToolkit.DiscreteMath.inclusion_exclusion`
- `FormalToolkit.DiscreteMath.vertex_count`
- `FormalToolkit.DiscreteMath.boolean_pigeonhole`

### [Sequences.lean](../DiscreteMath/Sequences.lean)

- `FormalToolkit.DiscreteMath.binaryWords_eq`
- `FormalToolkit.DiscreteMath.not_not`
- `FormalToolkit.DiscreteMath.boolean_deMorgan`

## Counterexamples

### [FiniteSearch.lean](../Counterexamples/FiniteSearch.lean)

- `FormalToolkit.Counterexamples.search_nonempty`
- `FormalToolkit.Counterexamples.ordered_model_found`
- `FormalToolkit.Counterexamples.search_sound`

### [InvalidClaims.lean](../Counterexamples/InvalidClaims.lean)

- `FormalToolkit.Counterexamples.injective_not_surjective`
- `FormalToolkit.Counterexamples.implication_not_converse`
- `FormalToolkit.Counterexamples.symmetric_not_transitive`
- `FormalToolkit.Counterexamples.transitive_not_reflexive`
- `FormalToolkit.Counterexamples.constant_not_injective`
- `FormalToolkit.Counterexamples.square_not_monotone`
- `FormalToolkit.Counterexamples.exists_and_not_distributive`
- `FormalToolkit.Counterexamples.union_not_intersection`

### [Transport.lean](../Counterexamples/Transport.lean)

- `FormalToolkit.Counterexamples.ordered_transitive`
- `FormalToolkit.Counterexamples.ordered_reflexive`
- `FormalToolkit.Counterexamples.ordered_forward`
- `FormalToolkit.Counterexamples.transitive_not_symmetric`
- `FormalToolkit.Counterexamples.backward_transport_counterexample`
- `FormalToolkit.Counterexamples.backward_transport_fails`

**Total: 98 named theorems.**
