clear
close all
fig_name = "validation_error";

plot_colours = dictionary(2,{get_plot_colours(5)},3,{get_plot_colours(4)});
%------------------------------------------
figs = open_local_figures("validation_error_base");
fig = figs{1};
%------------------------------------------
ax = gca;
ax.YScale = "log";
ax.Title = [];
ylim(ax,[1e-6,1])
xlim(ax,[1.4,3.2])
fig.Children.Padding = "compact";

lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    validation_modes = line.DataTipTemplate.DataTipRows(4).Value(1);
    validation_modes = erase(validation_modes,["[","]"]);
    validation_modes = str2double(validation_modes{1});
    if validation_modes == 2
        uistack(line,"top")
    end
    line_colour =  plot_colours(validation_modes);
    line.Color = line_colour{1};
end
%------------------------------------------
save_fig(fig,fig_name)