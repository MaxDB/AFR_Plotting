clear
close all

fig_names = "invariant_manifold_3d";

Export_Settings.height = 7.8; %8.4
Export_Settings.width = 7.8;
Export_Settings.font_size = 12;




%--------------------------
figs = open_local_figures(fig_names);

%--------------------------
switch fig_names
    case "invariant_manifold_3d"
        Export_Settings.file_type = "png";
        Export_Settings.projection = "3D";
        Export_Settings.renderer = "opengl";
        Export_Settings.resolution = 500;
    case "invariant_manifold_2d"
        ax = figs{1}.Children(2);
        set(ax.Children,"LineWidth",1.5)
        ax.Children(1).LineStyle = "--";

end
%--------------------------
export_fig(figs,fig_names,Export_Settings)