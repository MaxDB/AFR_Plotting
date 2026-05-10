clear
close all


fig_name = "arch_two_mode_bb";



Export_Settings.height = 8;
Export_Settings.width = 8.4;
Export_Settings.file_type = "png";
figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)