clear
close all


fig_name = "three_mode_physical_backbone";

Export_Settings.height = 4.5; 
Export_Settings.width = 8.4;


figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)