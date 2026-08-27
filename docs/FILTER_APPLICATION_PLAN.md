# Filter Application Modernization Plan

## Objective

Make the stable cascaded filter application path the clear, testable integration API before rewriting the technical documentation.

## Scope

The work applies to active runtime code under `src/runtime` and its shared dependencies under `src/support`. It does not modify the historical `miros-original` or `miros-modified` sibling folders.

## Implementation Plan

1. Define the public runtime API.
   - Make `Calc_OutputWithState` the documented application integration entry point.
   - Define input shape, initial- and later-period semantics, returned state, status values, and named errors.

2. Decouple normal runtime processing from compatibility files.
   - Keep normal section state in memory.
   - Make writes to `LastInSignal.txt`, `LastOutSignal.txt`, and `LogFile.txt` optional compatibility behavior where practical.

3. Add practical sample workflows.
   - Cover impulse, step, sine, and seeded-noise input signals.
   - Verify multi-period continuity and explicit session reset behavior.

4. Strengthen runtime validation.
   - Validate time and sample vectors, section state structure, section count, and status propagation at public boundaries.
   - Preserve named errors and stable-section checks.

5. Clarify compatibility boundaries.
   - Identify `Calc_Output`, `ApplyFilter`, `ApplyNext`, and direct-form coefficient APIs as compatibility surfaces.
   - Move compatibility code to `legacy` only in a separate, bootstrap-aware change that preserves or intentionally versions public callers.

6. Create application-focused tests.
   - Test signal input-to-output behavior for each supported signal type.
   - Test independent state for two concurrent caller-owned sessions.
   - Test that the modern API does not require persisted file state.

7. Modernize technical documentation.
   - Document the verified API, state model, and sample workflows.
   - Retain the original mathematical foundation while replacing obsolete direct-form implementation claims and results.

## Completion Criteria

- The caller-owned cascade API is documented and covered by executable tests.
- Normal application processing does not depend on compatibility files.
- Compatibility behavior is explicit, isolated, and regression-tested.
- The full MATLAB R2017a suite passes after each behavior-changing change.