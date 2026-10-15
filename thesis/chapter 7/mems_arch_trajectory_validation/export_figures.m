clear
close all

fig_name = "trajectory_validation";

Export_Settings.height = 5; 
Export_Settings.width = 8.4;

Export_Settings.file_type = "pdf";

figs = open_local_figures(fig_name);

%--------------------------
export_fig(figs,fig_name,Export_Settings)
