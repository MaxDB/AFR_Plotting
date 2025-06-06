clear 
close all

fig_name = "manifold_comparison_" + [1,2,3];

% Export_Settings.height = 8;
% Export_Settings.width = 8.4;

Export_Settings.height = 33;
Export_Settings.width = 40;
Export_Settings.font_size = 32;
Export_Settings.axes = "on";

Export_Settings.file_type = "png";
Export_Settings.resolution = 500;
Export_Settings.projection = "3D";
%--------------------------
figs = open_local_figures(fig_name);
num_figs = size(figs,1);
fig = figs{1};
%--------------------------
for iFig = 1:num_figs
    fig = figs{1};
    ax = fig.Children;
    % ax.CameraPosition = [-0.2404   -1.8429    0.0217];


    lines = ax.Children;
    num_lines = size(lines,1);
    for iLine = 1:num_lines
        line = lines(iLine);
        if isempty(line.Tag)
            continue
        end
        if line.Tag(1:2) == "o-"
            % uistack(line,"top")
            % line.ZData = line.ZData + 1e-5;
        elseif line.Tag == "orbit_point"
            % uistack(line,"top")
            % uistack(line,"down",1)
            % line.ZData = line.ZData + 0.22e-5;
        end

    end
end
%--------------------------
export_fig(figs,fig_name,Export_Settings)