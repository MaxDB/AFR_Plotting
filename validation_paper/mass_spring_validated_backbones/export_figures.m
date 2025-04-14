clear 
close all

fig_name = "validated_backbone";

% Export_Settings.height = 8;
% Export_Settings.width = 8.4;

Export_Settings.height = 20;
Export_Settings.width = 60;
Export_Settings.font_size = 22;

%--------------------------
figs = open_local_figures(fig_name);
fig = figs{:};


%--------------------------
export_fig(fig,fig_name,Export_Settings)