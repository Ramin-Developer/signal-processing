# Signal Processing

MATLAB-based signal processing experiments, filter design utilities, and numerical analysis scripts.

## Overview

This repository contains a compact set of MATLAB files for:
- signal filtering and transformation
- coefficient and parameter calculation
- frequency response and evaluation
- test logging and validation helpers

## Project purpose

The code in this repository is intended for MATLAB-based signal analysis and experimentation, with a focus on practical DSP routines and reproducible processing workflows.

## Usage

Run `Main_Check.m` for the demonstration flow. Use `Calc_OutputWithState` when integrating the filter into an application that owns its state explicitly.

`MakeInputFile.m` remains available to generate legacy example input files, but `InputFile.txt` is not consumed by the modern filter pipeline.

## Repository notes

- Source files are stored as MATLAB scripts and data files.
- Temporary outputs, log artifacts, and generated files are ignored through the repository's configuration.
