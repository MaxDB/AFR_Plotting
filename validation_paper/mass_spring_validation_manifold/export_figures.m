clear 
close all

fig_name = "validation_manifold";

% Export_Settings.height = 8;
% Export_Settings.width = 8.4;

Export_Settings.height = 20;
Export_Settings.width = 30;
Export_Settings.font_size = 22;
Export_Settings.axes = "on";

Export_Settings.file_type = "pdf";
Export_Settings.projection = "3D";
%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};

%--------------------------

%--------------------------

lines = fig.Children(2).Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    if isempty(line.Tag)
        continue
    end
    if line.Tag(1) == "o"
        uistack(line,"top")
        line.ZData = line.ZData + 1e-5;
    end
end

%--------------------------
export_fig(fig,fig_name,Export_Settings)