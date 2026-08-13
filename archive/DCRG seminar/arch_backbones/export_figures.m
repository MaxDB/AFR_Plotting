clear
close all


fig_name = "arch_energy_bb";
Export_Settings.file_type = "png";
Export_Settings.resolution = 500;


Export_Settings.height = 10; 
Export_Settings.width =16;


Export_Settings.font_size = 16;

figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)