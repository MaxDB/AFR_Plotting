clear 
close all
% 
% 

fig_name = "arch_validation_error";

Export_Settings.file_type = "png";
Export_Settings.resolution = 500;


Export_Settings.height = 16; 
Export_Settings.width =16;
Export_Settings.font_size = 16;


%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};



%----
export_fig(fig,fig_name,Export_Settings)
