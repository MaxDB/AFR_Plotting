clear 
close all

fig_name = "validation_error";



Export_Settings.height = 6;
Export_Settings.width =  15.6;
Export_Settings.font_size = 12;


%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};

%----
export_fig(fig,fig_name,Export_Settings)
