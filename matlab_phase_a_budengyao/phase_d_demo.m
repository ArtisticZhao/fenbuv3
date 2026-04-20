function phase_d_demo()
%PHASE_D_DEMO Refine Phase C candidates and verify Hopf conditions.

params = make_budengyao_params();
phase_b_opts = make_phase_b_options();
phase_c_opts = make_phase_c_options();
phase_d_opts = make_phase_d_options();
n = 1;

scan_result = scan_G_roots(n, params, phase_b_opts);
branch_data = build_omega_branches(scan_result, phase_c_opts);
s_data = compute_S_branches(branch_data, phase_c_opts.k_list, params);
candidates = find_S_candidates(s_data, phase_c_opts.zero_tol);
verified_points = refine_and_verify_candidates(candidates, params, phase_d_opts);
verified_points = deduplicate_hopf_points(verified_points, ...
    phase_d_opts.dedup_epsilon_tol, phase_d_opts.dedup_omega_tol);

fprintf('Phase D demo for budengyao Hopf analysis\n');
fprintf('  mode n = %d\n', n);
fprintf('  raw candidate count = %d\n', numel(candidates));
fprintf('  refined candidate count = %d\n', numel(verified_points));

for idx = 1:numel(verified_points)
    item = verified_points(idx);
    fprintf(['  point %2d: epsilon*=%.6f, omega*=%.6f, k_est=%d, ', ...
        'residual=%.3e, simple=%d, transversal=%d, hopf=%d\n'], ...
        idx, item.epsilon_refined, item.omega_refined, item.k_est, ...
        abs(item.delta_value), item.is_simple_root, item.is_transversal, ...
        item.is_hopf_point);
end
end
