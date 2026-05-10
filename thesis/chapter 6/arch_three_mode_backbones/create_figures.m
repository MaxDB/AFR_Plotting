clear
close all
fig_name = "three_mode_physical_backbone";


% orbit_style = {"Marker","*","Color",colour,"LineWidth",line_width,"MarkerSize",marker_size};
%--------------------------------------------------
data_directory = get_project_path + "\examples\size_test";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
data_dir_execute(@compare_solutions,"physical amplitude","mems_arch_1611","all");
fig = gcf;
leg = findobj(fig,"Type","Legend");
delete(leg);

ax = gca;
ax = swap_colours(ax,2,5);


lines = ax.Children;
num_lines = length(lines);
xlim(ax.XLim)
for iLine = 1:num_lines
    line = lines(iLine);
    line.YData = line.YData*1000;
end

ylim(ax,[0,2])

ylabel(ax,"Max \bf{x}\rm{_{mid} (μm)}")
save_fig(fig,fig_name)