clear 
close all

fig_names = "amp_dependence_2";

Export_Settings.height = 10; 
Export_Settings.width =16;
Export_Settings.file_type = "pdf";


Export_Settings.font_size = 16;


%--------------------------
figs = open_local_figures(fig_names);
%--------------------------



%--------------------------
export_fig(figs,fig_names,Export_Settings)