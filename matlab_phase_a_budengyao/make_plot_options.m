function opts = make_plot_options()
%MAKE_PLOT_OPTIONS Default plotting options for the Hopf workflow.

opts = struct();
opts.visible = 'on';
opts.save_png = false;
opts.close_after_plot = false;
opts.line_width = 1.2;
opts.marker_size = 24;
opts.g_grid_size = 220;
opts.omega_margin = 1.05;
opts.output_dir = pwd;
opts.summary_filename = 'budengyao_G_summary.png';
end
