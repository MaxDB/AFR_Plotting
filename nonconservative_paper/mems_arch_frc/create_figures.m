clear
close all
fig_name = "frc";

% orbit_style = {"Marker","*","Color",colour,"LineWidth",line_width,"MarkerSize",marker_size};
%--------------------------------------------------
data_directory = get_project_path + "\examples\nonconservative\mems_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
data_dir_execute(@compare_solutions,"physical amplitude","mems_arch_16",1:5);
fig = gcf;
leg = findobj(fig,"Type","Legend");
delete(leg);
%---------

ax = gca;

xlim(ax,[2.6e6,2.8e6])
lines = findobj(fig,"Type","Line");
set(lines,"MarkerSize",8);
%--
hold(ax,"on")
plot(ax,2686390,0.000875525,"^","MarkerSize",6,"MarkerFaceColor","w")
plot(ax,2705470,0.000476517,"^","MarkerSize",6,"MarkerFaceColor","w")
hold(ax,"off")
%--
lines = findobj(fig,"Type","Line");
set(lines,"LineWidth",2,"Color",get_plot_colours(3));
set(lines((end-1):end),"Color","k")
%--
arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines)
ylim(ax,[0,1.9])
%--
ylabel("Max deflection (μm)")

%---------
save_fig(fig,fig_name)