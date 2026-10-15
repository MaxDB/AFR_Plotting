clear
close all


fig_name = "two_mode_physical_backbone";

Export_Settings.height = 6;
Export_Settings.width = 15.6;
Export_Settings.font_size = 12;



figs = open_local_figures(fig_name);
% ylabel("Max(|\bf{x}\rm{_{mid}|) \fontname{Times New Roman}(μm)}")
%--------------------------
export_fig(figs,fig_name,Export_Settings)