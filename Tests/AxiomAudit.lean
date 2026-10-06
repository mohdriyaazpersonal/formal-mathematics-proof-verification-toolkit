import Toolkit
import Tests.Regression
import Lean.Util.CollectAxioms

/-! # Trust audit
Inspect every theorem in our namespace, including transitive dependencies.
Only Lean's standard logical axioms are allowed. In particular, placeholders,
custom axioms, and native evaluation axioms cannot silently certify a result.
-/
open Lean Elab Command in
run_cmd do
  let env ← getEnv
  let mut checked := 0
  for (name, _) in env.constants.toList do
    if (`FormalToolkit).isPrefixOf name && Lean.getOriginalConstKind? env name == some .thm then
      let axioms ← Lean.collectAxioms name
      for ax in axioms do
        unless #[``propext, ``Classical.choice, ``Quot.sound].contains ax do
          throwError "Unexpected axiom {ax} in {name}"
      checked := checked + 1
  if checked < 40 then
    throwError "Expected at least 40 toolkit theorems; found {checked}"
  logInfo m!"Trust audit passed for {checked} theorem declarations."
