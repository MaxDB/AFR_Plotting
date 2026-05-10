clear
close all


fig_name = "stability";

Export_Settings.height = 4.2; 
Export_Settings.width = 8.4;


figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)