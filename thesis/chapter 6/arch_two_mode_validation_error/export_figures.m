clear 
close all

fig_name = "two_mode_validation_error";


Export_Settings.height = 11;
Export_Settings.width = 15.6;
Export_Settings.font_size = 12;



%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};
% ylabel("Max(|\bf{x}\rm{_{mid}|) \fontname{Times New Roman}(μm)}")
%----
export_fig(fig,fig_name,Export_Settings)
