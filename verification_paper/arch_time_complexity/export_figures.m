clear 
close all

% fig_names = "arch_time_complexity_6";
% 
% Export_Settings.height = 8.4;
% Export_Settings.width = 8.4;

fig_names = "arch_time_complexity";
% 
Export_Settings.height = 21;
Export_Settings.width = 16.8;
Export_Settings.padding = [0,0.1,0.1,0];

%--------------------------
figs = open_local_figures(fig_names);
%--------------------------

%--------------------------
export_fig(figs,fig_names,Export_Settings)