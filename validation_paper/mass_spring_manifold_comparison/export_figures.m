clear 
close all

fig_name = "manifold_comparison";

Export_Settings.height = 8;
Export_Settings.width = 8.4;




Export_Settings.file_type = "png";
Export_Settings.resolution = 500;
Export_Settings.projection = "3D";
%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};
%--------------------------

%--------------------------
export_fig(fig,fig_name,Export_Settings)