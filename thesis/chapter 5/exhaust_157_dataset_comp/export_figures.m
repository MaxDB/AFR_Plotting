clear 
close all

fig_names = "157_staticdata";

Export_Settings.height = 8;
Export_Settings.width = 15.6;
Export_Settings.font_size = 12;
Export_Settings.projection = "3D";
Export_Settings.file_type = "png";
Export_Settings.resolution = 800;

%--------------------------
figs = open_local_figures(fig_names);
%--------------------------

%--------------------------
export_fig(figs,fig_names,Export_Settings)