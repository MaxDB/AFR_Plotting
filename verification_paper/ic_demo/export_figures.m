clear 
close all

fig_names = "ic_demo";

Export_Settings.height = 7;
Export_Settings.width = 8.4;

Export_Settings.font_name = "Times New Roman";
Export_Settings.font_size = 8;
%--------------------------
figs = open_local_figures;
%--------------------------

%--------------------------
export_fig(figs,fig_names,Export_Settings)