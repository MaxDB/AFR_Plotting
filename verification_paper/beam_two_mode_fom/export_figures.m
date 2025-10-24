clear
close all


fig_name = "beam_two_mode_comp";

Export_Settings.height = 12; 
Export_Settings.width = 8.4;
Export_Settings.projection = "3d";
Export_Settings.file_type = "png";
Export_Settings.resolution = 500;


figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)