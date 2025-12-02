clear
close all
fig_name = "energy_backbone";

orbit_id = 141;
max_energy = 0.05;

colour = get_plot_colours(3);
line_width = 1;
marker_size = 6;

orbit_style = {"Marker","*","Color",colour,"LineWidth",line_width,"MarkerSize",marker_size};
%--------------------------------------------------
data_directory = get_project_path + "\examples\validation\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
data_dir_execute(@compare_solutions,"energy","mass_spring_roller_1",1,"mass_spring_roller_12",1);


fig = gcf();
ax = gca();
leg = findobj(fig,"Type","legend");
delete(leg)
%------------------------------------------
ylim(ax,[0,max_energy ])
ylabel(ax,"Energy (J)")

lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    line.LineWidth = line_width;
    line.MarkerSize = marker_size;
end

bb_line = findobj(ax,"Color",get_plot_colours(1),"DisplayName",'');
x_orbit = bb_line.XData(orbit_id);
y_orbit = bb_line.YData(orbit_id);


hold(ax,"on")
p = plot(ax,x_orbit,y_orbit,orbit_style{:});
hold(ax,"off")
% p.Annotation.LegendInformation.IconDisplayStyle = "off";
% uistack(ax.Children(1),"bottom")
%-----------------------------------------
save_fig(fig,"energy_backbone")