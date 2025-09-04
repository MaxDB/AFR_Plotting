clear
close all


fig_name = "beam_three_mode";

Export_Settings.height = 6; 
Export_Settings.width = 8.4;
Export_Settings.projection = "3D";
% Export_Settings.file_type = "png";
% Export_Settings.resolution = 300;


figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)