clear 
close all

fig_name = "validated_backbone";

Export_Settings.height = 7.8; 
Export_Settings.width = 15.6;
Export_Settings.font_size = 12;


%--------------------------
figs = open_local_figures(fig_name);
fig = figs{:};


%--------------------------
export_fig(fig,fig_name,Export_Settings)