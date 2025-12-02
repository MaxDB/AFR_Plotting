clear
close all
fig_name = "physical_backbone";

% orbit_style = {"Marker","*","Color",colour,"LineWidth",line_width,"MarkerSize",marker_size};
%--------------------------------------------------
data_directory = get_project_path + "\examples\validation\mems_arch";
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

bb_line.Marker = ".";
bb_line.MarkerSize = 12;

lines = ax.Children;
num_lines = length(lines);
for iLine = 1:num_lines
    line = lines(iLine);
    line.YData = line.YData*1000;
end


ylabel(ax,"Max(\bf{x}\rm{_{mid}) \fontname{Times New Roman}(μm)}")
save_fig(fig,fig_name)