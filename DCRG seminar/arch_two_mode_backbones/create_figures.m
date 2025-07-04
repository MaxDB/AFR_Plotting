clear
close all
fig_name = "arch_two_mode_bb";

PRESENTATION_MODE = 1;

% orbit_style = {"Marker","*","Color",colour,"LineWidth",line_width,"MarkerSize",marker_size};
%--------------------------------------------------
data_directory = get_project_path + "\examples\size_test";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
data_dir_execute(@compare_solutions,"energy","mems_arch_1",1,"mems_arch_16",[1,2]);
fig = gcf;
leg = findobj(fig,"Type","Legend");
delete(leg);

ax = gca;
ax = swap_colours(ax,2,0);

bb_one_line = ax.Children(end);
ax = swap_colours(ax,1,"gray");

lines = findobj("Type","line");
set(lines,"LineWidth",2);



ylabel(ax,"Energy (mJ)")
save_fig(fig,fig_name)