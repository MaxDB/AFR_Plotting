clear
close all


fig_name = "frc";

Export_Settings.height = 6; 
Export_Settings.width = 8.4;



figs = open_local_figures(fig_name);

%--------------------------
export_fig(figs,fig_name,Export_Settings)

%-
leg = findobj("type","legend");
leg.Position(1) = leg.Position(1)*0.9;
%-
export_fig(figs,fig_name,Export_Settings)
