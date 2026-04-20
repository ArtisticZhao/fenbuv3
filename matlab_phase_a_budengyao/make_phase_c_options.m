function opts = make_phase_c_options()
%MAKE_PHASE_C_OPTIONS Default branch-tracking and S-curve options.

opts = struct();
opts.k_list = 0:2;
opts.branch_gap_abs = 1.5;
opts.branch_gap_rel = 0.15;
opts.max_branches = 30;
opts.max_fill_gap = 3;
opts.zero_tol = 1.0e-3;
end
