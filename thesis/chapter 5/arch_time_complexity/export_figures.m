clear 
close all


fig_names = "arch_time_complexity";
% % 
% Export_Settings.height = 21;
% Export_Settings.width = 16.8;
% Export_Settings.padding = [0,0.1,0.1,0];

Export_Settings.height = 18;
Export_Settings.width = 15;
Export_Settings.font_size = 12;


%--------------------------
figs = open_local_figures(fig_names);
%--------------------------
fig = figs{1};
tiled_layouts = findobj(fig,"Type","tiledlayout");

set(tiled_layouts,"TileSpacing","tight")
tiled_layouts(1).TileSpacing = "tight";
t_six = fig.Children.Children(1);
t_four = fig.Children.Children(2);
t_two = fig.Children.Children(3);
t_one = fig.Children.Children(4);

delete(findobj(t_six,"type","legend"))
delete(findobj(t_four,"type","legend"))
delete(findobj(t_one,"type","legend"))

ax_aspect_ratio = t_one.Children(3).DataAspectRatio;
daspect(t_four.Children(3),ax_aspect_ratio);
daspect(t_six.Children(3),ax_aspect_ratio);

ylim(t_four.Children(3),[0,60])
ylim(t_six.Children(3),[0,60])
%--------------------------
export_fig(figs,fig_names,Export_Settings)