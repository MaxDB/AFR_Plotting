clear 
close all
% 
% 
% 
% fig_name = "validation_error";
% 
% Export_Settings.height = 6;
% Export_Settings.width = 8.4;

fig_name = "validation_error_single";
Export_Settings.height = 15; 
Export_Settings.width = 15;
Export_Settings.font_size = 22;



%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};

%----
export_fig(fig,fig_name,Export_Settings)
