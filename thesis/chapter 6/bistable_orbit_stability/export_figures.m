clear
close all


fig_name = "orbit_stability";

Export_Settings.height = 7; 
Export_Settings.width = 15.4;
Export_Settings.font_size = 12;


figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)