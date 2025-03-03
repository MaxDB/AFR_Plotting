clear 
close all

fig_names = "manifold_comp";

Export_Settings.height = 6;
Export_Settings.width = 8.4;

Export_Settings.file_type = "png";
Export_Settings.projection = "3D";
Export_Settings.renderer = "opengl";
Export_Settings.resolution = 500;
Export_Settings.font_name = "Times New Roman";
Export_Settings.font_size = 8;
%--------------------------
figs = open_local_figures;

%--------------------------
export_fig(figs,fig_names,Export_Settings)