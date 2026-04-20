function phase_b_demo()
%PHASE_B_DEMO Minimal scan for G(omega, epsilon) = 0 in one spatial mode.

params = make_budengyao_params();
opts = make_phase_b_options();
n = 1;

result = scan_G_roots(n, params, opts);

fprintf('Phase B demo for budengyao Hopf analysis\n');
fprintf('  mode n = %d\n', result.n);
fprintf('  mu_n = %.10f\n', result.mu);
fprintf('  epsilon range = [%.4f, %.4f]\n', opts.epsilon_min, opts.epsilon_max);
fprintf('  omega range = [%.4f, %.4f]\n', opts.omega_min, opts.omega_max);

total_roots = 0;
for idx = 1:length(result.omega_roots)
    total_roots = total_roots + length(result.omega_roots{idx});
end
fprintf('  total positive roots found across the scan = %d\n', total_roots);

figure('Color', 'w');
hold on;

for idx = 1:length(result.epsilon_grid)
    epsilon = result.epsilon_grid(idx);
    roots = result.omega_roots{idx};
    if isempty(roots)
        continue;
    end

    scatter(epsilon * ones(size(roots)), roots, 14, 'filled');
end

xlabel('\epsilon', 'FontSize', 12);
ylabel('\omega', 'FontSize', 12);
title(sprintf('Positive roots of G(\\omega,\\epsilon)=0 for n=%d', n), ...
    'FontSize', 13);
grid on;
box on;
hold off;
end
