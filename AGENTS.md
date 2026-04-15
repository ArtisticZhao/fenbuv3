# Repository Guidelines

## Project Structure & Module Organization
This repository is a compact numerical-simulation workspace rather than a multi-package application. Keep executable logic in `untitled2.py`, which contains the FiPy-based PDE solver and plotting workflow. Use `Untitled2.ipynb` for exploratory or presentation-friendly notebook runs, but mirror stable changes back into the Python script. Treat `ax2_heatmap.eps` as generated output; regenerate it from code instead of editing it manually. Ignore transient notebook artifacts such as `.ipynb_checkpoints/` and `.~Untitled2.ipynb`.

## Build, Test, and Development Commands
Run the script locally with:

```bash
python3 untitled2.py
```

This executes the simulation and writes `ax2_heatmap.eps`.

For notebook work, open:

```bash
jupyter notebook Untitled2.ipynb
```

Install core dependencies explicitly when needed:

```bash
python3 -m pip install numpy matplotlib scipy fipy tqdm ipykernel
```

The script includes on-demand package installation, but prefer preinstalling dependencies for reproducible runs.

## Coding Style & Naming Conventions
Follow PEP 8 with 4-space indentation and clear snake_case names such as `history_steps`, `solution_matrix`, and `mat_filename`. Keep constants uppercase only when they are true configuration constants, for example `MAX_SWEEP`. Preserve concise inline comments where the PDE discretization or buffer logic is non-obvious. Avoid adding wildcard imports outside the existing FiPy usage pattern unless you first refactor the file consistently.

## Testing Guidelines
There is no formal automated test suite yet. Validate changes by running `python3 untitled2.py` and confirming the solver completes, the residual trend remains bounded, and `ax2_heatmap.eps` is regenerated without errors. For numerical changes, record the parameter set you used, such as `Nx`, `dt`, `tau`, and `Tend`, in your PR or patch notes.

## Commit & Pull Request Guidelines
Git history is not available in this directory, so use short, imperative commit messages such as `Refine heatmap export` or `Stabilize delay buffer update`. Pull requests should summarize the numerical or plotting change, list modified parameters, and attach updated figures when visuals change. Call out dependency changes and notebook/script sync status explicitly.

## Security & Configuration Tips
Do not rely on runtime `pip install` in restricted or offline environments. Prefer pinned dependencies in a future `requirements.txt` if this workspace becomes shared or reproducible across machines.
