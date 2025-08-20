clear 
close all

fig_names = "mass_spring_bb";

Export_Settings.height = 4;
Export_Settings.width = 8.4;


%--------------------------
figs = open_local_figures(fig_names);
%--------------------------

%--------------------------
export_fig(figs,fig_names,Export_Settings)