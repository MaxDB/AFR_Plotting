clear
close all


fig_name = "stability";

Export_Settings.height = 4.2; 
Export_Settings.width = 8.4;

% Export_Settings.height = 15;
% Export_Settings.width = 25;
% Export_Settings.font_size = 32;

figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)