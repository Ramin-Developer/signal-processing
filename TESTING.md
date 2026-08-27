# Testing Checklist

Run these checks from the repository root before merging MATLAB changes.

## MATLAB R2017a smoke test

In MATLAB, run:

```matlab
MATLAB_R2017_COMPATIBILITY_TESTS
```

The test must finish without assertion failures. It covers configuration, signal generation, filter design, coefficient calculation, and consecutive filter periods.

## Manual pipeline check

1. Run `Main_Check`.
2. Confirm that the input and output signals are plotted.
3. Confirm that the first period initializes state before later periods are processed.
4. Confirm that no generated state or log files are staged for commit.

## Git check

Run `git status --short` and verify that only intended source, test, or documentation files are present.