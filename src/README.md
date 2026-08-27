# Source Layout

- `design/` contains filter specification, parameter, coefficient, and section design code.
- `runtime/` contains sample processing and caller-owned filter state code.
- `support/` contains configuration, validation, and persistence helpers.

MATLAB source remains at the repository root until a path bootstrap is introduced and the migration can be verified incrementally.