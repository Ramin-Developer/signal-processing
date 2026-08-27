# Source Layout

- `design/` contains filter specification, parameter, coefficient, and section design code.
- `runtime/` contains sample processing and caller-owned filter state code.
- `support/` contains configuration, validation, and persistence helpers.

The root `startup.m` adds these directories to the MATLAB path when the repository is the current folder.