clear
close all


fig_name = "energy_backbone";

Export_Settings.height = 6; 
Export_Settings.width = 8.4;


figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)