clear
close all


fig_name = "verification_seps_3d";

Export_Settings.height = 5; 
Export_Settings.width = 8.4;
% Export_Settings.file_type = "png";
Export_Settings.projection = "3D";


figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)