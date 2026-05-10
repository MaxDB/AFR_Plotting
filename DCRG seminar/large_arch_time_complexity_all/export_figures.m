clear 
close all


fig_names = "arch_time_complexity_4";
% 
Export_Settings.height = 8;
Export_Settings.width = 16;
Export_Settings.padding = [0.2,0.2,0.2,0.8];
Export_Settings.file_type = "png";

%--------------------------
figs = open_local_figures(fig_names);
%--------------------------
ax = figs{1}.Children.Children;

%--------------------------
export_fig(figs,fig_names,Export_Settings)