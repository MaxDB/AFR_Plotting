clear 
close all

% fig_names = "arch_time_complexity_6";
% 
% Export_Settings.height = 8.4;
% Export_Settings.width = 8.4;

fig_names = "arch_time_complexity";
% 
Export_Settings.height = 20;
Export_Settings.width = 16.8;

%--------------------------
figs = open_local_figures(fig_names);
%--------------------------

%--------------------------
export_fig(figs,fig_names,Export_Settings)