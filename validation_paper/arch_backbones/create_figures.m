clear
close all
fig_name = "physical_backbone";

PRESENTATION_MODE = 1;

% orbit_style = {"Marker","*","Color",colour,"LineWidth",line_width,"MarkerSize",marker_size};
%--------------------------------------------------
data_directory = get_project_path + "\examples\size_test";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
data_dir_execute(@compare_solutions,"physical amplitude","mems_arch_1",1);
fig = gcf;
leg = findobj(fig,"Type","Legend");
delete(leg);

ax = gca;
% ylim(ax,[0,0.01])
% xlim(ax,[360,590])

bb_line = ax.Children(2);
bb_line.Color = get_plot_colours(1);

if ~PRESENTATION_MODE
    bb_line.Marker = "o";
else
    bb_line.LineWidth = bb_line.LineWidth*2;
end

lines = ax.Children;
num_lines = length(lines);
for iLine = 1:num_lines
    line = lines(iLine);
    line.YData = line.YData*1000;
end


ylabel(ax,"Maximum displacement (μm)")
save_fig(fig,fig_name)