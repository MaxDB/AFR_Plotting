clear
close all


fig_name = "physical_backbone";

Export_Settings.height = 6;
Export_Settings.width = 7.8;
Export_Settings.font_size = 12;



figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)