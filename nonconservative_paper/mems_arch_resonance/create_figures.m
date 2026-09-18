clear
close all
fig_name = "resonance";

%--------------------------------------------------
data_directory = get_project_path + "\examples\nonconservative\mems_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
data_dir_execute(@compare_solutions,"energy","mems_arch_16",6:12,"validation",1);
fig = gcf;
leg = findobj(fig,"Type","Legend");
delete(leg);
%---------

ax = gca;

xlim(ax,[2.677100,2.680300]*1e6)
%--



%--
lines = findobj(fig,"Type","Line","Marker","none");
markers = findobj(fig,"Type","Line","Marker","o");
delete(markers)

epsilon_line = lines(6);
epsilon_line.XData(1) = [];
epsilon_line.YData(1) = [];

validation_lines = lines([1:5,7:8]);
bb_line = lines(10);
frc_lines = lines([9,11:14]);

set(validation_lines,"Color",get_plot_colours(4))
set(epsilon_line,"Color",get_plot_colours("grey"))
set(frc_lines,"Color",get_plot_colours(3))
set(bb_line,"Color",get_plot_colours(0))

uistack(validation_lines,"top")
uistack(epsilon_line,"bottom")
%--
ylim(ax,[0.15,0.45])
%--
ylabel("Energy (nJ)")

%---------
save_fig(fig,fig_name)