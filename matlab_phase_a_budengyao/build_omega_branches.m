function branch_data = build_omega_branches(scan_result, opts)
%BUILD_OMEGA_BRANCHES Convert scanned root clouds into branch matrices.

if nargin < 2 || isempty(opts)
    opts = make_phase_c_options();
end

omega_mat = assign_root_branches(scan_result.omega_roots, opts);
omega_mat = fill_small_gaps(omega_mat, opts.max_fill_gap);

branch_data = struct();
branch_data.n = scan_result.n;
branch_data.mu = scan_result.mu;
branch_data.epsilon_grid = scan_result.epsilon_grid;
branch_data.omega_mat = omega_mat;
end
