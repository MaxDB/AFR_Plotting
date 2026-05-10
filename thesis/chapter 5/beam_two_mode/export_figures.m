clear
close all


fig_name = "beam_two_mode";

Export_Settings.height = 8;
Export_Settings.width = 15.6;
Export_Settings.font_size = 12;
Export_Settings.projection = "3D";
Export_Settings.file_type = "png";
Export_Settings.resolution = 500;


figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)