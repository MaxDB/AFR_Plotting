clear
close all
fig_name = "two_mode_physical_backbone";


% orbit_style = {"Marker","*","Color",colour,"LineWidth",line_width,"MarkerSize",marker_size};
%--------------------------------------------------
data_directory = get_project_path + "\examples\size_test";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
data_dir_execute(@compare_solutions,"physical amplitude","mems_arch_1",[1],"mems_arch_16",[1,6]);
fig = gcf;
leg = findobj(fig,"Type","Legend");
delete(leg);

ax = gca;
ax = swap_colours(ax,2,5);
ylim(ax,[0,2e-3])

ylabel(ax,"Maximum displacement (mm)")
save_fig(fig,fig_name)