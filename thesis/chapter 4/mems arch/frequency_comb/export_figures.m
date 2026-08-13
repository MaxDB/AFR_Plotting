clear
close all


fig_name = "frequency_comb";

Export_Settings.font_size = 12;
Export_Settings.height = 12; 
Export_Settings.width = 15.6;



figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)