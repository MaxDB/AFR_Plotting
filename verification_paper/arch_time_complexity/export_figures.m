clear 
close all

fig_names = ["arch_time_complexity_4","insert_1","insert_2"];

Export_Settings(1).height = 6;
Export_Settings(1).width = 16.8;

Export_Settings(2).height = 2;
Export_Settings(2).width = 6;

Export_Settings(3).height = 2;
Export_Settings(3).width = 6;
%--------------------------
figs = open_local_figures(fig_names);
%--------------------------

%--------------------------
export_fig(figs,fig_names,Export_Settings)