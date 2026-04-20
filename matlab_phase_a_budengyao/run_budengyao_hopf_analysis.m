function results = run_budengyao_hopf_analysis()
%RUN_BUDENGYAO_HOPF_ANALYSIS Top-level entry for the Budengyao Hopf pipeline.
%   This function runs the whole workflow:
%   Phase B root scan -> Phase C candidate detection -> Phase D refinement
%   and Hopf verification.

params = make_budengyao_params();
phase_b_opts = make_phase_b_options();
phase_c_opts = make_phase_c_options();
phase_d_opts = make_phase_d_options();
plot_opts = make_plot_options();

n_list = 1:4;
all_points = struct([]);
mode_results = struct([]);

fprintf('Running Budengyao Hopf analysis pipeline\n');
fprintf('  n_list = [%s]\n', num2str(n_list));
fprintf('  k_list = [%s]\n', num2str(phase_c_opts.k_list));
fprintf('\n');

for n_idx = 1:numel(n_list)
    n = n_list(n_idx);

    scan_result = scan_G_roots(n, params, phase_b_opts);
    branch_data = build_omega_branches(scan_result, phase_c_opts);
    s_data = compute_S_branches(branch_data, phase_c_opts.k_list, params);
    candidates = find_S_candidates(s_data, phase_c_opts.zero_tol);
    verified_points = refine_and_verify_candidates(candidates, params, phase_d_opts);
    verified_points = deduplicate_hopf_points(verified_points, ...
        phase_d_opts.dedup_epsilon_tol, phase_d_opts.dedup_omega_tol);

    if isempty(verified_points)
        hopf_points_mode = verified_points;
    else
        hopf_points_mode = verified_points([verified_points.is_hopf_point]);
    end

    fprintf('Mode n = %d\n', n);
    fprintf('  mu_n = %.10f\n', scan_result.mu);
    fprintf('  omega branches tracked = %d\n', size(branch_data.omega_mat, 2));
    fprintf('  phase-C candidates = %d\n', numel(candidates));
    fprintf('  phase-D refined points = %d\n', numel(verified_points));
    fprintf('  verified Hopf points = %d\n', numel(hopf_points_mode));

    if isempty(hopf_points_mode)
        fprintf('    No verified Hopf points for this mode.\n');
    else
        for idx = 1:numel(hopf_points_mode)
            item = hopf_points_mode(idx);
            fprintf(['    Hopf %2d: k=%d, epsilon*=%.6f, omega*=%.6f, ', ...
                'residual=%.3e, Re(dlambda/depsilon)=%.3e\n'], ...
                idx, item.k_est, item.epsilon_refined, item.omega_refined, ...
                abs(item.delta_value), real(item.dlambda_depsilon));
        end
    end
    fprintf('\n');

    mode_result = struct();
    mode_result.n = n;
    mode_result.scan_result = scan_result;
    mode_result.branch_data = branch_data;
    mode_result.s_data = s_data;
    mode_result.candidates = candidates;
    mode_result.verified_points = verified_points;
    mode_result.hopf_points = hopf_points_mode;

    if isempty(mode_results)
        mode_results = mode_result;
    else
        mode_results(end + 1) = mode_result; %#ok<AGROW>
    end

    if isempty(all_points)
        all_points = verified_points;
    elseif ~isempty(verified_points)
        all_points = [all_points, verified_points]; %#ok<AGROW>
    end
end

all_points = deduplicate_hopf_points(all_points, ...
    phase_d_opts.dedup_epsilon_tol, phase_d_opts.dedup_omega_tol);

results = struct();
results.params = params;
results.phase_b_options = phase_b_opts;
results.phase_c_options = phase_c_opts;
results.phase_d_options = phase_d_opts;
results.plot_options = plot_opts;
results.mode_results = mode_results;
results.points = all_points;

if isempty(all_points)
    results.hopf_points = all_points;
else
    results.hopf_points = all_points([all_points.is_hopf_point]);
end

results_mat_path = fullfile(pwd, 'budengyao_hopf_results.mat');
results_csv_path = fullfile(pwd, 'budengyao_hopf_points.csv');
summary_plot_path = plot_G_summary(mode_results, plot_opts);
mode_plot_paths = cell(1, numel(mode_results));
for mode_idx = 1:numel(mode_results)
    mode_plot_paths{mode_idx} = plot_mode_diagnostics(mode_results(mode_idx), plot_opts);
end
results.summary_plot_path = summary_plot_path;
results.mode_plot_paths = mode_plot_paths;
save(results_mat_path, 'results');
write_hopf_points_csv(results.hopf_points, results_csv_path);

fprintf('Global summary\n');
fprintf('  total refined points = %d\n', numel(results.points));
fprintf('  total verified Hopf points = %d\n', numel(results.hopf_points));

if isempty(results.hopf_points)
    fprintf('  No verified Hopf points were found in the current search box.\n');
else
    fprintf('  Hopf point list:\n');
    for idx = 1:numel(results.hopf_points)
        item = results.hopf_points(idx);
        fprintf(['    n=%d, k=%d, epsilon*=%.6f, omega*=%.6f, ', ...
            'Re(dlambda/depsilon)=%.3e\n'], ...
            item.n, item.k_est, item.epsilon_refined, item.omega_refined, ...
            real(item.dlambda_depsilon));
    end
end

fprintf('  Saved MAT results: %s\n', results_mat_path);
fprintf('  Saved CSV summary: %s\n', results_csv_path);
if plot_opts.save_png
    fprintf('  Saved G summary plot: %s\n', summary_plot_path);
    for mode_idx = 1:numel(mode_plot_paths)
        fprintf('  Saved mode plot: %s\n', mode_plot_paths{mode_idx});
    end
else
    fprintf('  Figures were drawn directly in MATLAB and not exported to PNG.\n');
end
end
