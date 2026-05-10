clear 
close all

fig_name = "two_mode_resonance_error";



Export_Settings.height = 6;
Export_Settings.width = 8.4;



%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};

%----
export_fig(fig,fig_name,Export_Settings)
