# MATLAB Project Overview

## Entry points

When the repository is the MATLAB current folder, `startup.m` adds the implementation and test directories to the MATLAB path.

The current workflow is driven by the following MATLAB entry points:

- `src/runtime/Main_Check.m` — top-level script that creates several time vectors, invokes the filter calculation for each set, and plots the input-output signal pairs.
- `src/runtime/Calc_Output.m` — compatibility wrapper used by the plotting script.
- `src/runtime/Calc_OutputWithState.m` — preferred callable pipeline for applications that own their section state explicitly.
- `src/runtime/MakeInputFile.m` — legacy standalone utility that can generate an untracked `InputFile.txt`; it is not read by the modern filtering pipeline.

## Directory layout

- `src/design/` contains filter specification, parameter calculation, and section design.
- `src/runtime/` contains sample processing, session state, and demonstration entry points.
- `src/support/` contains configuration, validation, frequency-response, and persistence helpers.
- `tests/` contains the MATLAB compatibility and filter-design test scripts.
- `legacy/` is reserved for explicitly retained compatibility code.

## Execution flow

1. `Main_Check.m` initializes the number of signal sets and time vector values.
2. For each set, it calls `Calc_Output(t, FirstPeriod)`.
3. `Calc_Output.m` calls:
   - `Initialize` for file names and filter constants
   - `MakeTestFile` to construct the input waveform and design limits
   - `DesignParam` to deduce filter order and cutoff parameters
   - `CalculateFilterSections` to generate stable 2nd- or 4th-order filter sections
   - `ApplyFilterSections` to compute the output through the section cascade
4. `Calc_Output.m` retains one explicit state value for each section during the MATLAB session and writes `LastInSignal.txt`, `LastOutSignal.txt`, and `LogFile.txt` as compatibility artifacts.

`InputFile.txt` is separate from this flow. It is generated only on demand with `MakeInputFile` and does not influence `Calc_Output` or `Calc_OutputWithState`.

## Data and state model

The system is built around a mix of:
- function arguments passed explicitly
- in-memory state for each cascaded filter section
- file-based compatibility artifacts for the previous input and output vectors
- status values stored in text logs

The in-memory cascade preserves full double precision between periods. The compatibility writer also uses 17 significant digits so persisted state can round-trip without precision loss.

