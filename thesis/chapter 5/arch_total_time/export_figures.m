clear 
close all

fig_names = "arch_total_time";

Export_Settings.height = 6;
Export_Settings.width = 15.6;
Export_Settings.font_size = 12;


%--------------------------
figs = open_local_figures(fig_names);
%--------------------------

%--------------------------
export_fig(figs,fig_names,Export_Settings)