clear
close all


% fig_name = "nonlinear_mapping";
% Export_Settings.projection = "3d";
% Export_Settings.file_type = "png";
% Export_Settings.resolution = 800;


fig_name = "nonlinear_mapping_2d";

Export_Settings.height = 5; 
Export_Settings.width = 5;
Export_Settings.font_size = 12;

figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)