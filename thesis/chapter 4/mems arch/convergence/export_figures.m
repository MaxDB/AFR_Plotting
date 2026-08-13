clear
close all


fig_name = "fe_convergence";

Export_Settings.height = 5; 
Export_Settings.width = 15.6;
Export_Settings.font_size = 12;



figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)