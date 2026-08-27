# MATLAB Project Overview

## Entry points

The current workflow is driven by the following MATLAB entry points:

- `Main_Check.m` — top-level script that creates several time vectors, invokes the filter calculation for each set, and plots the input-output signal pairs.
- `Calc_Output.m` — core filtering function used by the plotting script. It initializes the filter model, builds a test signal, computes design parameters, and applies the filter.
- `Calc_OutputWithState.m` — preferred callable pipeline for applications that own their section state explicitly.
- `MakeInputFile.m` — legacy standalone utility that generates `InputFile.txt`; it is not read by the modern filtering pipeline.

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

`InputFile.txt` is separate from this flow. It may be generated with `MakeInputFile`, but it does not influence `Calc_Output` or `Calc_OutputWithState`.

## Data and state model

The system is built around a mix of:
- function arguments passed explicitly
- in-memory state for each cascaded filter section
- file-based compatibility artifacts for the previous input and output vectors
- status values stored in text logs

The in-memory cascade preserves full double precision between periods. The compatibility writer also uses 17 significant digits so persisted state can round-trip without precision loss.

## Refactor target for this phase

The first modernization pass should keep behavior the same while improving clarity of the execution path and reducing hidden file-based coupling. The main targets are:

- document the current execution path clearly
- isolate shared configuration constants
- reduce reliance on implicit file state
- make naming and function boundaries easier to follow

## Recommended next change

Before deeper refactoring, the code should be reorganized so that:
- configuration values are centralized
- state persistence is explicit
- filter calculation and persistence are separated more cleanly
- the same logic is easier to validate with small MATLAB smoke tests
