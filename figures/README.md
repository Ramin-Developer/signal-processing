# Figure Generation Sources

This directory contains MATLAB sources used to reproduce and modernize documentation figures.

## Legacy Reference Sources

`legacy-reference/design/` is a copied, unmodified reference archive of the original design suite. `FilterDesign1` drives the direct-versus-backward response plots used for the original report's filter result figures. `InputParam.txt` is retained because the scripts read it at runtime.

`legacy-reference/prototypes/` contains the original Chebyshev prototype plotting scripts. `Low_Cheb` generated the original `Low_Cheb.eps` figure. `High_Cheb` was retained with the source set but was not used by the attached report.

The archived scripts are not part of the active `src` filter implementation. They use historical direct-form and file-output behavior and are retained solely as figure-generation reference material.

## Modern Figures

Place scripts that generate figures from the current stable cascaded implementation in this directory. Put generated output in `output/`; it is intentionally ignored by Git.