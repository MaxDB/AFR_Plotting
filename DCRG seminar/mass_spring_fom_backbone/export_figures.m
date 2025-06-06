clear
close all


fig_name = "energy_backbone_" + [1,2,3,4];



Export_Settings.height = 20;
Export_Settings.width = 40;
Export_Settings.font_size = 32;
Export_Settings.file_type = "svg";

figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)