# MATLAB Project Overview

## Entry points

The current workflow is driven by the following MATLAB entry points:

- `Main_Check.m` — top-level script that creates several time vectors, invokes the filter calculation for each set, and plots the input-output signal pairs.
- `Calc_Output.m` — core filtering function used by the plotting script. It initializes the filter model, builds a test signal, computes design parameters, and applies the filter.

## Execution flow

1. `Main_Check.m` initializes the number of signal sets and time vector values.
2. For each set, it calls `Calc_Output(t, FirstPeriod)`.
3. `Calc_Output.m` calls:
   - `Initialize` for file names and filter constants
   - `MakeTestFile` to construct the input waveform and design limits
   - `DesignParam` to deduce filter order and cutoff parameters
   - `CalculateCoeff` to generate the digital filter coefficients
   - `ApplyFilter` to compute the output signal and persist state
4. `ApplyFilter.m` reads or writes `LastInSignal.txt`, `LastOutSignal.txt`, and `LogFile.txt` depending on whether the first period or a later period is being processed.

## Data and state model

The system is currently built around a mix of:
- function arguments passed explicitly
- file-based persistence for the previous input and output vectors
- status values stored in text logs

This is useful for a small script-oriented workflow, but it makes the code harder to test and reason about as the project grows.

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
