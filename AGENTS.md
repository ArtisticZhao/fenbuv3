# Repository Guidelines

## Project Structure & Module Organization
This repository is a compact numerical-simulation workspace rather than a multi-package application. Keep executable logic in `hopf_baseline_validation.py`, which contains the FiPy-based PDE solver and plotting workflow for the baseline kernel. Use `hopf_baseline_validation.ipynb` for exploratory or presentation-friendly notebook runs, but mirror stable changes back into the Python script. Use `hopf_budengyao_branch_search.py` and `hopf_budengyao_validation.ipynb` for the asymmetric-kernel Hopf workflow. Treat exported figures as generated output; regenerate them from code instead of editing them manually. Ignore transient notebook artifacts such as `.ipynb_checkpoints/`.

## Build, Test, and Development Commands
Run the script locally with:

```bash
python3 hopf_baseline_validation.py
```

This executes the simulation and writes `ax2_heatmap.eps`.

For notebook work, open:

```bash
jupyter notebook hopf_baseline_validation.ipynb
```

Install core dependencies explicitly when needed:

```bash
python3 -m pip install numpy matplotlib scipy fipy tqdm ipykernel
```

The script includes on-demand package installation, but prefer preinstalling dependencies for reproducible runs.

## Coding Style & Naming Conventions
Follow PEP 8 with 4-space indentation and clear snake_case names such as `history_steps`, `solution_matrix`, and `mat_filename`. Keep constants uppercase only when they are true configuration constants, for example `MAX_SWEEP`. Preserve concise inline comments where the PDE discretization or buffer logic is non-obvious. Avoid adding wildcard imports outside the existing FiPy usage pattern unless you first refactor the file consistently.

## Testing Guidelines
There is no formal automated test suite yet. Validate baseline changes by running `python3 hopf_baseline_validation.py` and confirming the solver completes and exported figures regenerate without errors. Validate asymmetric-kernel changes by running the branch search and then the notebook workflow. For numerical changes, record the parameter set you used, such as `Nx`, `dt`, `tau`, `epsilon`, and `Tend`, in your PR or patch notes.

## Commit & Pull Request Guidelines
Git history is not available in this directory, so use short, imperative commit messages such as `Refine heatmap export` or `Stabilize delay buffer update`. Pull requests should summarize the numerical or plotting change, list modified parameters, and attach updated figures when visuals change. Call out dependency changes and notebook/script sync status explicitly.

## Security & Configuration Tips
Do not rely on runtime `pip install` in restricted or offline environments. Prefer pinned dependencies in a future `requirements.txt` if this workspace becomes shared or reproducible across machines.
