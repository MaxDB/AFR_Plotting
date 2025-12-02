clear
close all
fig_name = "two_mode_physical_backbone";


% orbit_style = {"Marker","*","Color",colour,"LineWidth",line_width,"MarkerSize",marker_size};
%--------------------------------------------------
data_directory = get_project_path + "\examples\validation\mems_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
data_dir_execute(@compare_solutions,"physical amplitude","mems_arch_1",[1],"mems_arch_16",[1,2],"validation",[1,0]);
fig = gcf;
leg = findobj(fig,"Type","Legend");
delete(leg);

ax = gca;
swap_colours(ax,1,3);
swap_colours(ax,2,5);
swap_colours(ax,[0,0,0],1);


lines = ax.Children;
num_lines = length(lines);
xlim(ax.XLim)
for iLine = 1:num_lines
    line = lines(iLine);
    line.YData = line.YData*1000;
end

%---
y_lim = [0,2];
ylim(ax,y_lim)
hold(ax,"on")
line = plot([1,1]*2.6609e6,y_lim,"k--");
hold(ax,"off")
uistack(line,"bottom")
%---




ylabel(ax,"Max(\bf{x}\rm{_{mid}) \fontname{Times New Roman}(μm)}")
save_fig(fig,fig_name)