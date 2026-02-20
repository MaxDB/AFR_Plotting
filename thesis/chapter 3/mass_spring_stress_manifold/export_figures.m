clear 
close all

fig_names = ["reduced_force","stress_manifold"];

Export_Settings.height = 5;
% Export_Settings.height = 4;
Export_Settings.width = 7.8;
Export_Settings.font_size = 12;

Export_Settings.file_type = "pdf";

%--------------------------
figs = open_local_figures(fig_names);
%--------------------------

%--------------------------
export_fig(figs,fig_names,Export_Settings)