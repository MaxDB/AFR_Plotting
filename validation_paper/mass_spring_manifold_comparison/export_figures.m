clear 
close all

fig_name = "manifold_comparison";
height = 8;
width = 8.4;

Export_Settings.file_type = "pdf";
Export_Settings.projection = "3D";
%--------------------------
figs = open_local_figures;
stress_manifold_fig = figs{:};

fig = stress_manifold_fig;
%--------------------------

fig.Units = 'centimeters';
fig.Position(3) = width;
fig.Position(4) = height; 
fig.PaperSize = fig.InnerPosition([3,4]);
% paperFigExport(figName,fig)
%--------------------------

lines = fig.Children(2).Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    if isempty(line.Tag)
        continue
    end
    if line.Tag(1:2) == "o-"
        % uistack(line,"top")
        line.ZData = line.ZData + 1e-5;
    elseif line.Tag == "orbit_point"
        % uistack(line,"top")
        % uistack(line,"down",1)
        line.ZData = line.ZData + 0.22e-5;
    end

end

%--------------------------
export_fig(fig,fig_name,Export_Settings)