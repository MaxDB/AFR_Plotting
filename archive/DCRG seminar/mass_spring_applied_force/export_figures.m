clear 
close all

fig_name = "applied_force_1";



Export_Settings.width = 30;
Export_Settings.height = Export_Settings.width*110/180;
Export_Settings.font_size = 22;


Export_Settings.file_type = "png";
Export_Settings.resolution = 500;
Export_Settings.projection = "3D";
Export_Settings.renderer = "opengl";
%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};
%--------------------------
manifold = findobj(fig,"Tag","m-1");
manifold.Color = [manifold.Color,0.5];
% manifold.MarkerFaceColor = [manifold.Color,0.5];
%--------------------------
export_fig(fig,fig_name,Export_Settings)