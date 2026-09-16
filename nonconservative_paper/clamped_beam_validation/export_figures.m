clear
close all

fig_num = 4;
fig_name = "validation_"+fig_num;

Export_Settings.height = 6; 
Export_Settings.width = 8.4;



figs = open_local_figures(fig_name);

%--------------------------
export_fig(figs,fig_name,Export_Settings)
zoomed_ax = gca;
zoomed_ax.Position(1) = 0.15;
zoomed_ax.Position(3:4) = zoomed_ax.Position(3:4)*0.9;
export_fig(figs,fig_name,Export_Settings)