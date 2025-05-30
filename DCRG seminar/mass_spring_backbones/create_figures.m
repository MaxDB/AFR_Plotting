clear
close all
fig_name = "energy_backbone_comp";

max_energy = 0.05;
backbone_1_line = 8;

colour = get_plot_colours(3);
line_width = 2; %1
marker_size = 6; %6

x_point = [1.42562, 1.84174, 1.98323];
y_point = [4.37274e-5, 0.0413184, 0.0046976];
%--------------------------------------------------
data_directory = get_project_path + "\examples\3_dof_mass_spring";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
data_dir_execute(@compare_solutions,"energy","mass_spring_roller_1",1,"mass_spring_roller_12",1);


fig = gcf();
ax = gca();
leg = fig.Children(1);
delete(leg)
%------------------------------------------
 swap_colours(ax,1,3)

ylim(ax,[0,max_energy ])
xlim(ax,[1.4,3.2]);
ylabel(ax,"Energy (J)")
% 
% leg.Interpreter = "latex";
% 
lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    line.LineWidth = line_width;
    line.MarkerSize = marker_size;
end


num_points = size(x_point,2);
point_colours = get_plot_colours([4,5,6]);

hold(ax,"on")
for iPoint = 1:num_points
    plot(ax,x_point(iPoint),y_point(iPoint),"*","MarkerSize",14,"LineWidth",line_width,"Color",point_colours(iPoint,:));
    if iPoint == 2
        uistack(ax.Children(8),"top")
        uistack(ax.Children(3),"top")
    end
end
hold(ax,"off")


% p.Annotation.LegendInformation.IconDisplayStyle = "off";
% uistack(ax.Children(1),"bottom")
%-----------------------------------------
save_fig(fig,fig_name)