function phase_c_demo()
%PHASE_C_DEMO Compute S_{n,k}(epsilon) curves and candidate epsilon_{n,k}.

params = make_budengyao_params();
phase_b_opts = make_phase_b_options();
phase_c_opts = make_phase_c_options();
n = 1;

scan_result = scan_G_roots(n, params, phase_b_opts);
branch_data = build_omega_branches(scan_result, phase_c_opts);
s_data = compute_S_branches(branch_data, phase_c_opts.k_list, params);
candidates = find_S_candidates(s_data, phase_c_opts.zero_tol);

fprintf('Phase C demo for budengyao Hopf analysis\n');
fprintf('  mode n = %d\n', n);
fprintf('  tracked omega branches = %d\n', size(branch_data.omega_mat, 2));
fprintf('  k list = [%s]\n', num2str(phase_c_opts.k_list));
fprintf('  candidate epsilon_{n,k} count = %d\n', numel(candidates));

for idx = 1:numel(candidates)
    item = candidates(idx);
    fprintf(['  candidate %2d: branch=%d, k=%d, epsilon*=%.6f, ', ...
        'omega*=%.6f, method=%s\n'], ...
        idx, item.branch_id, item.k, item.epsilon_star, item.omega_star, ...
        item.method);
end

figure('Color', 'w');
hold on;

num_branches = size(s_data.omega_mat, 2);
for branch_id = 1:num_branches
    S_curve = s_data.S_tensor(:, branch_id, 1);
    if all(isnan(S_curve))
        continue;
    end
    plot(s_data.epsilon_grid, S_curve, 'LineWidth', 1.1);
end

yline(0.0, '--k', 'LineWidth', 1.0);
xlabel('\epsilon', 'FontSize', 12);
ylabel('S_{n,0}(\epsilon)', 'FontSize', 12);
title(sprintf('S_{n,0}(\\epsilon) curves for n=%d', n), 'FontSize', 13);
grid on;
box on;
hold off;
end
