function result = scan_G_roots(n, params, opts)
%SCAN_G_ROOTS Scan positive omega roots over an epsilon grid for one mode.

if nargin < 3 || isempty(opts)
    opts = make_phase_b_options();
end

epsilon_grid = linspace(opts.epsilon_min, opts.epsilon_max, opts.num_epsilon);
roots_cell = cell(size(epsilon_grid));

for idx = 1:length(epsilon_grid)
    epsilon = epsilon_grid(idx);
    roots_cell{idx} = find_omega_roots(epsilon, n, params, opts);
end

result = struct();
result.n = n;
result.mu = mu_n(n, params.L);
result.epsilon_grid = epsilon_grid;
result.omega_roots = roots_cell;
end
