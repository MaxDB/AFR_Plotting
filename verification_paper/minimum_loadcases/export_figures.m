clear 
close all

fig_names = ["min_loadcases"];

Export_Settings.height = 5.5;
Export_Settings.width = 8.4;

Export_Settings.file_type = "pdf";
Export_Settings.font_name = "Times New Roman";
Export_Settings.font_size = 8;
%--------------------------
figs = open_local_figures;
%--------------------------

%--------------------------
export_fig(figs,fig_names,Export_Settings)