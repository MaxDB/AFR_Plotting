clear
close all

fig_num = 3;
fig_name = "frc_"+fig_num;

Export_Settings.height = 6; 
Export_Settings.width = 8.4;



figs = open_local_figures(fig_name);

%--------------------------
export_fig(figs,fig_name,Export_Settings)
