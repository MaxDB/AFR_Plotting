clear
close all
fig_name = "arch_two_mode_bb";

PRESENTATION_MODE = 1;

% orbit_style = {"Marker","*","Color",colour,"LineWidth",line_width,"MarkerSize",marker_size};
%--------------------------------------------------
data_directory = get_project_path + "\examples\validation\mems_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});


Dyn_Data = data_dir_execute(@initalise_dynamic_data,"mems_arch_1");
Dyn_Data = data_dir_execute(@Dyn_Data.validate_solution,1,6);
data_dir_execute(@compare_solutions,"physical amplitude","mems_arch_1",1,"mems_arch_16",[1,2],"validation",[1,0]);

fig = gcf;
leg = findobj(fig,"Type","Legend");
delete(leg);

ax = gca;
lines = ax.Children;

ylim(ax,[0,2e-3])
xlim(ax,[2.65e6,2.75e6])
set(lines(1:4),"Color",get_plot_colours(3))

lines = findobj("Type","line");
set(lines,"LineWidth",2);



set_label(ax,"y","Max(|\bf{x}\rm{_{mid}|) \fontname{Times New Roman}(μm)}") %μ
save_fig(fig,fig_name)