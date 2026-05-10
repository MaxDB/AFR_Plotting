clear 
close all

fig_names = "arch_dynamic_cost";

Export_Settings.height = 6;
Export_Settings.width = 7.8;
Export_Settings.font_size = 12;

%--------------------------
figs = open_local_figures(fig_names);
%--------------------------
leg = findobj(figs{1},"type","legend");
ax = findobj(figs{1},"type","ax");
leg.Location = "northoutside";
ylim(ax,[0,25])
leg.String{4} = 'Eom construction';
%--------------------------
export_fig(figs,fig_names,Export_Settings)
ax.Position = ax.Position;