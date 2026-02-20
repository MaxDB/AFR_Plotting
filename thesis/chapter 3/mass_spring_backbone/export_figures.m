clear 
close all

fig_names = "mass_spring_bb";

Export_Settings.height = 5;
Export_Settings.width = 15.6;
Export_Settings.font_size = 12;


%--------------------------
figs = open_local_figures(fig_names);
%--------------------------

ax = figs{1}.Children;
set(ax.Children(2:end),"LineWidth",1.5)

%--------------------------
export_fig(figs,fig_names,Export_Settings)