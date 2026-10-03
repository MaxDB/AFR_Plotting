clear
close all

plot_num = 2;
fig_name = "unstable_verification";

fig_name = fig_name + "_" + plot_num;

Export_Settings.height = 6; 
Export_Settings.width = 15.6;
Export_Settings.font_size = 12;


figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)