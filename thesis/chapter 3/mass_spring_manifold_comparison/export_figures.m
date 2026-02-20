clear 
close all

fig_names = "manifold_comp";

Export_Settings.height = 6;
Export_Settings.width = 12;
Export_Settings.font_size = 12;

Export_Settings.file_type = "png";
Export_Settings.projection = "3D";
Export_Settings.renderer = "opengl";
Export_Settings.resolution = 750;
%--------------------------
figs = open_local_figures(fig_names);

%--------------------------
export_fig(figs,fig_names,Export_Settings)