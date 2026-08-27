# MATLAB Interface Guide

## Compatibility

The code and its smoke-test suite target MATLAB R2017a-compatible syntax.

Start MATLAB with the repository as its current folder. The root `startup.m` adds `src/design`, `src/runtime`, `src/support`, and `tests` to the MATLAB path.

## Primary entry point

`src/runtime/Main_Check.m` is the top-level demonstration script. It creates six input signal periods, calls `Calc_Output` for each period, and plots the input and filtered output.

## Core pipeline

`Calc_Output(t, firstPeriod)` is the main callable pipeline.

Inputs:
- `t`: column vector of time values
- `firstPeriod`: `1` for the initial period; `0` for a later period

Outputs:
- `x`: generated input signal
- `y`: filtered output signal
- `Status`: `0` for normal operation, `1` for a convergence warning, or `2` for an alarm.

The pipeline uses cascaded low-order sections rather than one high-order direct-form polynomial. Each section has independent in-memory history, which avoids the numerical conditioning failure that can make a high-order combined polynomial appear unstable.

For later-period calls, use `firstPeriod = 1` once at the beginning of the MATLAB session, then use `0` for subsequent periods. A new session must begin with `1` because section state is intentionally held in memory.

The pipeline constructs the test signal, derives the filter parameters, creates stable sections, and applies the section cascade.

## Legacy Input File

`MakeInputFile` and `InputFile.txt` are retained as a standalone compatibility utility for generating example input data. The modern `Calc_Output` and `Calc_OutputWithState` pipelines generate their test signal through `MakeTestFile` and do not read `InputFile.txt`.

Use `MakeInputFile(path, choice)` for a repeatable generated input file, where `choice` is `0` (impulse), `1` (step), `2` (sine), or `3` (noise). Omitting `choice` retains the interactive prompt.

## Filter state

`ApplyFilterWithState` and `ApplyFilterSections` expose the preferred explicit in-memory state APIs. They retain full MATLAB double precision between periods.

`ApplyFilter` remains available as a compatibility adapter. Its state files use 17 significant digits, allowing double-precision samples to round-trip without the continuation drift caused by the former 12-digit format.

The default file names are configured in `SignalConfig.m`:
- `LastInSignal.txt`
- `LastOutSignal.txt`
- `LogFile.txt`

The text files remain compatibility artifacts; `Calc_Output` uses in-memory section state for continuation.

## Stability protection

Every cascaded section is checked before its recurrence is evaluated. A finite, real coefficient set with poles strictly inside the unit circle is required. If a section fails that check, processing stops with `SignalProcessing:UnstableFilter`; `Calc_Output` writes alarm status `2` to `LogFile.txt` before propagating the error. This is an alarm and exception, not a recoverable status `1` warning.

## Configuration

`SignalConfig.m` centralizes the core configuration values, including:
- maximum filter order
- bilinear-transform constant
- default signal length and number of periods
- frequency-vector settings
- periodic-extension and convergence limits
- test-signal frequencies and amplitudes

## Validation

Run `MATLAB_R2017_COMPATIBILITY_TESTS` from the repository root to execute the compatibility smoke tests. The suite validates configuration, signal generation, filter design, section stability, multi-period cascaded filtering, state error handling, and top-level pipeline execution.