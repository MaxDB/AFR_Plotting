clear
close all
fig_name = "energy_backbone";


% orbit_style = {"Marker","*","Color",colour,"LineWidth",line_width,"MarkerSize",marker_size};
%--------------------------------------------------
data_directory = get_project_path + "\examples\EN_examples\clamped_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
data_dir_execute(@compare_solutions,"energy","clamped_beam_1",1);
fig = gcf;
leg = findobj(fig,"Type","Legend");
delete(leg);

ax = gca;
ylim(ax,[0,0.01])
xlim(ax,[360,590])

bb_line = ax.Children(2);
bb_line.Color = get_plot_colours(1);
bb_line.Marker = ".";
bb_line.MarkerSize = 12;


ylabel(ax,"Energy (J)")
save_fig(fig,"energy_backbone")