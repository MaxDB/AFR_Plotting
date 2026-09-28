clear 
close all


fig_names = "arch_time_complexity_cost";
Export_Settings.height = 12;


% fig_names = "arch_time_complexity_memory";
% Export_Settings.height = 16;

Export_Settings.width = 15;
Export_Settings.font_size = 12;

%--------------------------
figs = open_local_figures(fig_names);
%--------------------------
fig = figs{1};
ax = findobj(fig,"type","axes");
set(ax,"XTickLabelRotationMode","manual")
%--------------------------
export_fig(figs,fig_names,Export_Settings)

