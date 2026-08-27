# MATLAB Modernization Plan

Status: active
Branch: refactor/matlab-modernization-20260827
Last updated: 2026-08-27

## Objective

Improve the MATLAB signal-processing codebase for modernization, performance, readability, and maintainability while preserving the current DSP behavior.

## Scope

This plan covers the current script collection under the repository root, with focus on:
- shared configuration and state management
- repeated numerical logic and code duplication
- file I/O and status handling
- naming and structure for maintainability
- validation and future refactor safety

## Assessment summary

### Findings

1. Script-oriented design
   - The project is organized as a set of MATLAB functions and data files, but several routines rely on implicit state and path-driven file operations.
   - This makes behavior harder to trace and more fragile when reused outside the current execution flow.

2. Repeated logic and magic numbers
   - The code contains repeated loop patterns, repeated near-duplicate sequences, and numeric constants such as `LenMin = 1000`, `Start = 5`, and fixed iteration limits.
   - These values should be promoted to named configuration constants or clearly documented parameters.

3. Mixed responsibilities
   - Some functions both compute DSP behavior and write output files.
   - This makes the code harder to test and harder to maintain.

4. Inconsistent error and status handling
   - Status values are used in several places with different semantics and file-based logging behavior.
   - This should become a clearer and more consistent validation pattern.

5. Naming and readability issues
   - Some identifiers are misspelled or abbreviated (`Normilize`, `Calc_Output`, `ApplyNext`, `LastInSignal`) and reduce clarity.
   - A naming cleanup pass is worthwhile without changing externally visible behavior.

6. Data flow risk
   - Several functions read and write files for state persistence between calls.
   - Refactoring toward explicit input/output structures will reduce the risk of hidden coupling.

## Refactoring tasks

### Phase 1 — Baseline and structure
- [ ] Document the project entry points and expected data flow
- [ ] Capture the current execution path for the main filter pipeline
- [x] Identify all shared file-based state and isolate it behind explicit config objects or helpers

### Phase 2 — Reliability and readability
- [ ] Rename ambiguous or misspelled functions and variables where safe
- [ ] Replace repeated magic numbers with named constants or configuration structures
- [x] Fix inconsistent file I/O patterns and status/error handling
- [ ] Centralize MATLAB path assumptions and file naming conventions

### Phase 3 — Performance improvement
- [ ] Replace repeated nested loops with vectorized MATLAB patterns where practical
- [x] Reduce duplicated signal extension logic in the initial-period and next-period handlers
- [ ] Reuse helper functions for common operations instead of inlining repeated logic

### Phase 4 — Maintainability and validation
- [ ] Add small smoke tests or script-level validation for core DSP routines
- [ ] Add a basic documentation section for expected inputs, outputs, and assumptions
- [ ] Establish a simple validation checklist before future refactors

## Planned implementation order

1. Stabilize the public execution flow and document known behaviors.
2. Separate configuration, filter state, and output persistence.
3. Standardize naming and status handling.
4. Improve performance hotspots in filter loops and input expansion.
5. Add lightweight automated validation.

## Exit criteria

The refactor is considered successful when:
- the MATLAB entry flow still behaves as expected
- no hidden shared state is required for core operations
- the code is easier to read and extend
- repeated logic is reduced without reducing correctness
- the project has a simple validation path for future changes

## Update policy

This plan should be updated as the refactor progresses. Completed items should be checked off, and new tasks should be added when additional code smells or risks are identified.
