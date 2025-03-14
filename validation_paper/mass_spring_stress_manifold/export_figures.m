clear 
close all

fig_name = "stress_manifold_comp";



Export_Settings.height = 6;
Export_Settings.width = 8.4;


Export_Settings.file_type = "png";
Export_Settings.resolution = 500;
Export_Settings.projection = "3D";
%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};
%--------------------------
ax = fig.Children;
lines = findall(ax,"Type","Line");
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    if isempty(line.Tag)
        continue
    end
    switch line.Tag
        case "m-1,2"
            % line.ZData = line.ZData - 1e-5;
        case "m-1"
            line.ZData = line.ZData + 1e-5;
        case "grid_line"
            %copied_line = copyobj(line,ax);
            %copied_line.ZData = copied_line.ZData - 0e-5;
            % line.ZData = line.ZData + 0e-5;
    end
    if line.Tag(1) == "o"
        uistack(line,"top")
        line.ZData = line.ZData + 2e-5;
    end
end
%--------------------------
export_fig(fig,fig_name,Export_Settings)