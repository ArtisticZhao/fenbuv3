function save_figure_png(fig_handle, output_path)
%SAVE_FIGURE_PNG Save a figure as a PNG file.

exportgraphics(fig_handle, output_path, 'Resolution', 220);
end
