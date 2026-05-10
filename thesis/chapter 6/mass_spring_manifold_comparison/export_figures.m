clear 
close all

fig_name = "manifold_comparison";

Export_Settings.height = 9;
Export_Settings.width = 7.8;
Export_Settings.font_size = 12;




Export_Settings.file_type = "png";
Export_Settings.resolution = 800;
Export_Settings.projection = "3D";
Export_Settings.padding = [0.1,0,0,0.1];
Export_Settings.separate_labels = true;
%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};
%--------------------------

%--------------------------
export_fig(fig,fig_name,Export_Settings)