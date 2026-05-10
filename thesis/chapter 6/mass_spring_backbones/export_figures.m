clear
close all


fig_name = "energy_backbone";

Export_Settings.height = 7.8; 
Export_Settings.width = 7.8;
Export_Settings.font_size = 12;


figs = open_local_figures(fig_name);
ax = figs{1}.Children;
set(ax.Children,"LineWidth",1.2)
marker = findobj(ax,"Marker","*");
set(marker,"MarkerSize",6)
%--------------------------
export_fig(figs,fig_name,Export_Settings)