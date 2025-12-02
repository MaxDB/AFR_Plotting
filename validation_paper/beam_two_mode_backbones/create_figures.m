clear
close all
fig_name = "two_mode_backbone";


% orbit_style = {"Marker","*","Color",colour,"LineWidth",line_width,"MarkerSize",marker_size};
%--------------------------------------------------
data_directory = get_project_path + "\examples\validation\clamped_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
data_dir_execute(@compare_solutions,"energy","clamped_beam_13",1);
fig = gcf;
leg = findobj(fig,"Type","Legend");
delete(leg);

ax = gca;
ylim(ax,[0,0.01])
xlim(ax,[360,590])

ax = swap_colours(ax,[0,0,0],get_plot_colours(2),"all");

ylabel(ax,"Energy (J)")
save_fig(fig,fig_name)