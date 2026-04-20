function opts = make_phase_d_options()
%MAKE_PHASE_D_OPTIONS Default refinement and Hopf-verification settings.

opts = struct();
opts.refine_tol = 1.0e-8;
opts.simple_root_tol = 1.0e-8;
opts.transversality_tol = 1.0e-8;
opts.omega_floor = 1.0e-3;
opts.g_tol = 1.0e-8;
opts.s_tol = 1.0e-8;
opts.dedup_epsilon_tol = 1.0e-5;
opts.dedup_omega_tol = 1.0e-5;
opts.fminsearch_options = optimset( ...
    'Display', 'off', ...
    'TolX', 1.0e-12, ...
    'TolFun', 1.0e-12, ...
    'MaxIter', 2000, ...
    'MaxFunEvals', 6000);
end
