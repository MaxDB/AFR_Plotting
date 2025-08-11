clear
close all


fig_name = ["orbit_comp_one_mode","orbit_comp_two_mode"];
% fig_name = "orbit_comp_two_mode"

Export_Settings.height = 6; 
Export_Settings.width = 8.4;

Export_Settings.file_type = "png";
Export_Settings.resolution = 500;
Export_Settings.projection = "3D";
Export_Settings.font_size = [6,8];


figs = open_local_figures(fig_name);

%--------------------------
export_fig(figs,fig_name,Export_Settings)