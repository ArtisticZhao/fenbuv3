function output_path = plot_G_summary(mode_results, plot_opts)
%PLOT_G_SUMMARY Plot omega branches from G(omega, epsilon)=0 for all modes.

fig = figure('Color', 'w', 'Visible', plot_opts.visible);
hold on;

mode_count = numel(mode_results);
colors = lines(max(mode_count, 1));
legend_handles = gobjects(0);
legend_names = {};

for mode_idx = 1:mode_count
    item = mode_results(mode_idx);
    epsilon_grid = item.branch_data.epsilon_grid(:);
    omega_mat = item.branch_data.omega_mat;
    color = colors(mode_idx, :);

    first_handle = [];
    for branch_id = 1:size(omega_mat, 2)
        omega_curve = omega_mat(:, branch_id);
        if all(isnan(omega_curve))
            continue;
        end

        handle = plot(epsilon_grid, omega_curve, '-', ...
            'Color', color, 'LineWidth', plot_opts.line_width);
        if isempty(first_handle)
            first_handle = handle;
        else
            set(handle, 'HandleVisibility', 'off');
        end
    end

    if ~isempty(first_handle)
        legend_handles(end + 1) = first_handle; %#ok<AGROW>
        legend_names{end + 1} = sprintf('n=%d', item.n); %#ok<AGROW>
    end

    if ~isempty(item.hopf_points)
        scatter([item.hopf_points.epsilon_refined], ...
            [item.hopf_points.omega_refined], ...
            plot_opts.marker_size * 2.2, ...
            'MarkerFaceColor', color, ...
            'MarkerEdgeColor', 'k', ...
            'LineWidth', 0.8, ...
            'HandleVisibility', 'off');
    end
end

xlabel('\epsilon', 'FontSize', 12);
ylabel('\omega', 'FontSize', 12);
title('Root branches of G(\omega,\epsilon)=0', 'FontSize', 13);
grid on;
box on;

if ~isempty(legend_handles)
    legend(legend_handles, legend_names, 'Location', 'eastoutside');
end

output_path = fullfile(plot_opts.output_dir, plot_opts.summary_filename);
if plot_opts.save_png
    save_figure_png(fig, output_path);
else
    output_path = '';
end

if plot_opts.close_after_plot
    close(fig);
end
end
