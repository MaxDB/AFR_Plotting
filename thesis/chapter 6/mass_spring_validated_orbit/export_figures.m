clear 
close all

fig_name = "validation_orbit";



Export_Settings.height = 9;
Export_Settings.width = 12.6;
Export_Settings.font_size = 12;



%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};
markers = findobj(fig,"Marker","o");
set(markers,"MarkerSize",14)

leg = findobj(fig,"type","legend");
leg.IconColumnWidth = leg.IconColumnWidth*3;

small_ax = fig.Children(1);
small_ax.Position(1:2) = small_ax.Position(1:2)*1.1;
%----
export_fig(fig,fig_name,Export_Settings)
