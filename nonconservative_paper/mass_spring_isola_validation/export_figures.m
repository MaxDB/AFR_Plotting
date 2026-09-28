clear
close all

fig_name = "validation";

Export_Settings.height = 4.2; 
Export_Settings.width = 8.4;



figs = open_local_figures(fig_name);

%--------------------------
export_fig(figs,fig_name,Export_Settings)
zoomed_ax = gca;
zoomed_ax.Position(1) = 0.12;
zoomed_ax.Position(2) = 0.22;
zoomed_ax.Position(3) = 0.27; 
zoomed_ax.Position(4) = 0.6; 
export_fig(figs,fig_name,Export_Settings)