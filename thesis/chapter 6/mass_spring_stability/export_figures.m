clear
close all


fig_name = "stability";

Export_Settings.height = 6.4; 
Export_Settings.width = 12;
Export_Settings.font_size = 12;


figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)