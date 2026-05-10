clear
close all


fig_name = "beam_three_mode";

Export_Settings.height = 9; 
Export_Settings.width = 12.6;
Export_Settings.font_size = 12;
Export_Settings.projection = "3D";
% Export_Settings.file_type = "png";
% Export_Settings.resolution = 300;


figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)