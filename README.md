# Signal Processing

MATLAB-based signal processing experiments, filter design utilities, and numerical analysis scripts.

## Overview

This repository contains MATLAB R2017a-compatible utilities for:
- stable cascaded filter design and processing
- coefficient and parameter calculation
- frequency response evaluation
- reproducible signal generation and validation

## Project purpose

The code in this repository is intended for MATLAB-based signal analysis and experimentation, with a focus on practical DSP routines and reproducible processing workflows.

## Usage

Run `Main_Check.m` for the demonstration flow. Use `Calc_OutputWithState` when integrating the filter into an application that owns its state explicitly.

`MakeInputFile.m` remains available to generate legacy example input files, including reproducible noise with an optional nonnegative integer seed: `MakeInputFile('InputFile.txt', 3, 42)`. `InputFile.txt` is not consumed by the modern filter pipeline.

Run `MATLAB_R2017_COMPATIBILITY_TESTS.m` to execute the full MATLAB R2017a compatibility suite.

## Repository notes

- Source files are stored as MATLAB scripts and data files.
- Temporary outputs, log artifacts, and generated files are ignored through the repository's configuration.
