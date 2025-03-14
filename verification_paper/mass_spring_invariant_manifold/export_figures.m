clear
close all

fig_names = "invariant_manifold_2d";

Export_Settings.height = 6; %8.4
Export_Settings.width = 8.4;

switch fig_names
    case "invariant_manifold_3d"
        Export_Settings.file_type = "png";
        Export_Settings.projection = "3D";
        Export_Settings.renderer = "opengl";
        Export_Settings.resolution = 500;
    case "invariant_manifold_2d"

end
Export_Settings.font_name = "Times New Roman";
Export_Settings.font_size = 8;
%--------------------------
figs = open_local_figures(fig_names);

%--------------------------

%--------------------------
export_fig(figs,fig_names,Export_Settings)