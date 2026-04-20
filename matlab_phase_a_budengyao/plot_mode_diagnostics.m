function output_path = plot_mode_diagnostics(mode_result, plot_opts)
%PLOT_MODE_DIAGNOSTICS Plot G-branches and S_{n,k} curves for one mode.

k_list = mode_result.s_data.k_list;
num_k = numel(k_list);
fig = figure('Color', 'w', 'Visible', plot_opts.visible);
tiledlayout(2, max(num_k, 1), 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile([1, max(num_k, 1)]);
hold on;

epsilon_grid = mode_result.branch_data.epsilon_grid(:);
omega_mat = mode_result.branch_data.omega_mat;

for branch_id = 1:size(omega_mat, 2)
    omega_curve = omega_mat(:, branch_id);
    if all(isnan(omega_curve))
        continue;
    end
    plot(epsilon_grid, omega_curve, '-', 'LineWidth', plot_opts.line_width);
end

if ~isempty(mode_result.hopf_points)
    scatter([mode_result.hopf_points.epsilon_refined], ...
        [mode_result.hopf_points.omega_refined], ...
        plot_opts.marker_size * 2.5, ...
        'filled', ...
        'MarkerFaceColor', [0.85, 0.2, 0.15], ...
        'MarkerEdgeColor', 'k', ...
        'LineWidth', 0.8);
end

omega_upper = max(omega_mat(:), [], 'omitnan');
if ~isempty(mode_result.hopf_points)
    omega_upper = max(omega_upper, max([mode_result.hopf_points.omega_refined]));
end
if ~isfinite(omega_upper)
    omega_upper = 1.0;
end

xlabel('\epsilon', 'FontSize', 12);
ylabel('\omega', 'FontSize', 12);
title(sprintf('Mode n=%d: branches of G(\\omega,\\epsilon)=0', mode_result.n), ...
    'FontSize', 13);
ylim([0, plot_opts.omega_margin * omega_upper]);
grid on;
box on;
hold off;

for k_idx = 1:num_k
    nexttile;
    hold on;

    for branch_id = 1:size(mode_result.s_data.omega_mat, 2)
        S_curve = mode_result.s_data.S_tensor(:, branch_id, k_idx);
        if all(isnan(S_curve))
            continue;
        end
        plot(mode_result.s_data.epsilon_grid, S_curve, '-', ...
            'LineWidth', plot_opts.line_width);
    end

    yline(0.0, '--k', 'LineWidth', 1.0);

    candidate_mask = false(1, numel(mode_result.candidates));
    for idx = 1:numel(mode_result.candidates)
        candidate_mask(idx) = mode_result.candidates(idx).k == k_list(k_idx);
    end

    if any(candidate_mask)
        selected = mode_result.candidates(candidate_mask);
        scatter([selected.epsilon_star], zeros(1, numel(selected)), ...
            plot_opts.marker_size, ...
            'o', ...
            'MarkerEdgeColor', [0.2, 0.2, 0.2], ...
            'MarkerFaceColor', [0.9, 0.75, 0.2], ...
            'LineWidth', 0.8);
    end

    xlabel('\epsilon', 'FontSize', 11);
    ylabel(sprintf('S_{n,%d}(\\epsilon)', k_list(k_idx)), 'FontSize', 11);
    title(sprintf('k=%d', k_list(k_idx)), 'FontSize', 12);
    grid on;
    box on;
    hold off;
end

output_path = fullfile(plot_opts.output_dir, ...
    sprintf('budengyao_mode_n%d_diagnostics.png', mode_result.n));
if plot_opts.save_png
    save_figure_png(fig, output_path);
else
    output_path = '';
end

if plot_opts.close_after_plot
    close(fig);
end
end
