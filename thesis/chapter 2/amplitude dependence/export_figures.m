clear 
close all

fig_names = "amp_dependence";

Export_Settings.height = 7.8;
Export_Settings.width = 7.8;
Export_Settings.font_size = 12;


%--------------------------
figs = open_local_figures(fig_names);
%--------------------------



%--------------------------
export_fig(figs,fig_names,Export_Settings)