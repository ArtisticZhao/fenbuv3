function opts = make_phase_b_options()
%MAKE_PHASE_B_OPTIONS Default search options for Phase B root finding.

opts = struct();
opts.omega_min = 1.0e-4;
opts.omega_max = 40.0;
opts.num_omega = 6000;
opts.max_roots = 12;
opts.root_tol = 1.0e-6;
opts.dup_tol = 1.0e-4;
opts.epsilon_min = 0.05;
opts.epsilon_max = 1.95;
opts.num_epsilon = 120;
end
