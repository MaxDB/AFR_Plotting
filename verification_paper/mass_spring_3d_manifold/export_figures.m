clear 
close all

fig_names = ["force1","force2"];

Export_Settings.height = 8.4;
Export_Settings.width = 8.4;

Export_Settings.file_type = "png";
Export_Settings.projection = "3D";
Export_Settings.renderer = "opengl";
Export_Settings.resolution = 500;
Export_Settings.font_name = "Times New Roman";
Export_Settings.font_size = 8;
%--------------------------
figs = open_local_figures;
num_figs = size(figs,1);
%--------------------------
for iFig = 1:num_figs
    fig = figs{iFig};

    lines = fig.Children.Children;
    num_lines = size(lines,1);
    for iLine = 1:num_lines
        line = lines(iLine);
        switch line.Tag
            case "force_manifold"
                line.ZData = line.ZData - 0.2;
            case "grid_line"
                line.ZData = line.ZData - 0.1;
            case "zero"
                line.ZData = line.ZData - 0.1;
        end
    end
end

%--------------------------

%--------------------------
export_fig(figs,fig_names,Export_Settings)