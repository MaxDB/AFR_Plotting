clear 
close all

fig_name = "validation_manifold";

Export_Settings.height = 9;
Export_Settings.width = 7.8;
Export_Settings.font_size = 12;



Export_Settings.file_type = "pdf";
Export_Settings.projection = "3D";
%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};

%--------------------------

%--------------------------

lines = fig.Children(1).Children;
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

markers = findobj(fig,"Marker","o");
set(markers,"MarkerSize",14)
%--------------------------
export_fig(fig,fig_name,Export_Settings)