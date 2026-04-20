# Matlab Phase A/B/C/D: Budengyao Hopf Setup

This folder isolates the first implementation phase for the Hopf analysis in
`budengyao.pdf`.

Phase A builds the formula layer:

1. define the parameter struct,
2. compute the Neumann eigenvalue `mu_n`,
3. build the final characteristic equation used by the paper for
   `lambda ~= 0`,
4. keep the compact kernel form only as a derivation check.

Phase B adds:

1. the sine and cosine right-hand sides after setting `lambda = i * omega`,
2. the scalar search equation `G(omega, epsilon) = 0`,
3. positive root search in `omega`,
4. a basic scan over an `epsilon` grid for one spatial mode.

Phase C adds:

1. branch tracking for the positive roots `omega_n(epsilon)`,
2. phase recovery `theta_n(epsilon)`,
3. evaluation of `S_{n,k}(epsilon)`,
4. candidate detection for critical values `epsilon_{n,k}`.

Phase D adds:

1. candidate refinement by solving the pure-imaginary root conditions,
2. simple-root checking through `\partial_\lambda \Delta`,
3. transversality checking through `Re(dlambda / depsilon)`,
4. a top-level pipeline entry.

## Files

- `phase_a_demo.m`: minimal entry script that evaluates the characteristic
  equation at a sample mode and a sample complex `lambda`.
- `phase_b_demo.m`: minimal scan script that searches positive roots of
  `G(omega, epsilon) = 0` for one mode and plots the root cloud.
- `phase_c_demo.m`: computes `S_{n,k}` curves and prints candidate critical
  values detected from zero crossings.
- `phase_d_demo.m`: refines candidates and checks the Hopf conditions.
- `run_budengyao_hopf_analysis.m`: top-level entry for the whole pipeline.
- `make_plot_options.m`: default plotting settings.
- `plot_G_summary.m`: global branch summary for `G(\omega,\epsilon)=0`.
- `plot_mode_diagnostics.m`: per-mode figure with `G` branches and `S_{n,k}`.
- `save_figure_png.m`: save a figure to PNG.
- `write_hopf_points_csv.m`: export the verified Hopf points to CSV.
- `make_budengyao_params.m`: default parameter factory.
- `make_phase_b_options.m`: default scan and root-search settings.
- `make_phase_c_options.m`: default branch-tracking and `S`-curve settings.
- `make_phase_d_options.m`: default refinement and verification settings.
- `mu_n.m`: Neumann eigenvalue for the interval `(0, L)`.
- `char_eq.m`: final polynomial-exponential characteristic equation from the
  paper, used as the main interface.
- `char_eq_compact.m`: compact integral form kept only for checking.
- `kernel_integral.m`: closed-form transform of the asymmetric kernel used by
  `char_eq_compact.m`.
- `char_eq_expanded.m`: compatibility wrapper that points to `char_eq.m`.
- `sin_rhs.m`: right-hand side of the sine equation `(0.8)`.
- `cos_rhs.m`: right-hand side of the cosine equation `(0.9)`.
- `G_fun.m`: scalar equation `(0.10)` used for root search.
- `find_omega_roots.m`: positive-root search for fixed `epsilon`.
- `scan_G_roots.m`: scan across an `epsilon` grid for one mode.
- `assign_root_branches.m`: connect the root cloud into approximate branches.
- `fill_small_gaps.m`: fill short missing segments inside one branch.
- `build_omega_branches.m`: convert scanned roots into a branch matrix.
- `phase_theta.m`: compute `theta_n(epsilon)` from the sine/cosine pair.
- `S_fun.m`: evaluate `S_{n,k}(epsilon)`.
- `compute_S_branches.m`: build `theta` and `S` arrays along each branch.
- `find_S_candidates.m`: detect candidate `epsilon_{n,k}` values.
- `pure_imag_residual.m`: real-imag residual of `char_eq(i*omega)=0`.
- `refine_hopf_candidate.m`: refine one candidate point numerically.
- `char_eq_lambda_derivative.m`: derivative with respect to `lambda`.
- `char_eq_epsilon_derivative.m`: derivative with respect to `epsilon`.
- `verify_hopf_point.m`: simple-root and transversality checks.
- `refine_and_verify_candidates.m`: run Phase D on all candidates.
- `deduplicate_hopf_points.m`: remove repeated nearby points.

## Paper Correspondence

For the kernel in `budengyao.pdf`, the original characteristic equation is

`Delta_n(lambda, epsilon) = lambda + d1 * mu_n + d2 * ubar * mu_n * H(lambda) - fu`

with

`H(lambda) = integral_{-tau}^0 h(s) exp(lambda s) ds`.

For `lambda ~= 0`, the paper gives

`H(lambda) = 2 * (tau - epsilon + epsilon * exp(-lambda * tau) - tau * exp(-lambda * epsilon)) / (tau * epsilon * (tau - epsilon) * lambda^2)`.

For `lambda = 0`, continuity gives `H(0) = 1`.

After clearing the `lambda^2` denominator, the paper continues with the final
formula used in Hopf analysis:

`lambda^2 * Delta_n(lambda, epsilon) = P0(lambda) + P1 exp(-lambda * tau) + P2 exp(-lambda * epsilon)`.

This is why `char_eq.m` now uses the final exponential form directly. It is
the formula that we will substitute with `lambda = i * omega` in Phase B.

## Run

Top-level batch entry:

`/Applications/MATLAB_R2025b.app/bin/matlab -batch "cd('/Users/az/Desktop/WDH/fenbuv4/fenbuv3_repo/matlab_phase_a_budengyao'); run_budengyao_hopf_analysis"`

For interactive figures, run inside MATLAB Desktop or use a non-batch start,
then call:

`run_budengyao_hopf_analysis`

The top-level entry also saves:

- `budengyao_hopf_results.mat`
- `budengyao_hopf_points.csv`
- `budengyao_G_summary.png`
- `budengyao_mode_n*_diagnostics.png`
