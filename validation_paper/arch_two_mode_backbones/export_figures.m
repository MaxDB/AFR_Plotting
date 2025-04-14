clear
close all


fig_name = "two_mode_physical_backbone";

% Export_Settings.height = 4; 
% Export_Settings.width = 8.4;
Export_Settings.height = 15; 
Export_Settings.width = 15;
Export_Settings.font_size = 22;

figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)