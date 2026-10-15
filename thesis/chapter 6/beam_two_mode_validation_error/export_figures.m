clear 
close all

fig_name = "two_mode_validation_error";



Export_Settings.height = 5.2;
Export_Settings.width = 14.5;
Export_Settings.font_size = 12;



%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};

%----
export_fig(fig,fig_name,Export_Settings)
