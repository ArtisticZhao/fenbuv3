# fenbuv3

This repository contains Hopf-bifurcation validation code for a nonlocal cross-diffusion model.

## Files
- `hopf_baseline_validation.py`: baseline FiPy simulation script converted from the original notebook template.
- `hopf_baseline_validation.ipynb`: notebook version of the baseline simulation.
- `hopf_budengyao_branch_search.py`: numerical branch-search script for the asymmetric kernel in `budengyao.pdf`.
- `hopf_budengyao_validation.ipynb`: integrated workflow that first plots `S_{n,k}(\epsilon)` and then runs the FiPy validation at a detected critical `\epsilon_*`.

## Recommended Workflow
1. Search the Hopf branch with the asymmetric kernel:
   `python hopf_budengyao_branch_search.py`
2. Open the validation notebook:
   `jupyter notebook hopf_budengyao_validation.ipynb`
3. In the notebook, inspect the `S_{n,k}(\epsilon)` curves, confirm the zero crossing, and then run the FiPy time-domain simulation cells.

## Notes
- PDF derivation files are intentionally excluded from version control.
- Generated outputs such as `.eps`, `.csv`, and notebook checkpoints are ignored.
- The legacy MATLAB implementation is preserved in the branch `legacy/v3-matlab`.
