# MATLAB Interface Guide

## Compatibility

The code and its smoke-test suite target MATLAB R2017a-compatible syntax.

## Primary entry point

`Main_Check.m` is the top-level demonstration script. It creates six input signal periods, calls `Calc_Output` for each period, and plots the input and filtered output.

## Core pipeline

`Calc_Output(t, firstPeriod)` is the main callable pipeline.

Inputs:
- `t`: column vector of time values
- `firstPeriod`: `1` for the initial period; `0` for a later period

Outputs:
- `x`: generated input signal
- `y`: filtered output signal
- `Status`: `0` for normal operation, `1` for a convergence warning, or `2` when the required filter order exceeds the configured maximum

The pipeline constructs the test signal, derives the filter parameters, calculates coefficients, and applies the filter.

## Filter state

`ApplyFilter` persists the current input and output signals after each run. For later periods, `ApplyNext` reads these files to obtain the required history.

The default file names are configured in `SignalConfig.m`:
- `LastInSignal.txt`
- `LastOutSignal.txt`
- `LogFile.txt`

Call the pipeline with `firstPeriod = 1` before any later-period call. This initializes the persisted filter state.

## Configuration

`SignalConfig.m` centralizes the core configuration values, including:
- maximum filter order
- bilinear-transform constant
- default signal length and number of periods
- frequency-vector settings
- periodic-extension and convergence limits
- test-signal frequencies and amplitudes

## Validation

Run `MATLAB_R2017_COMPATIBILITY_TESTS` from the repository root to execute the compatibility smoke tests. The suite validates configuration, signal generation, filter design, coefficient calculation, and consecutive filter periods.