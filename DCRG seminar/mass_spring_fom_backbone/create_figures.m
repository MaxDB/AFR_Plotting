clear
close all
fig_name = "energy_backbone";

animation_state = 5;

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
if animation_state == 5
data_dir_execute(@compare_solutions,"energy","mass_spring_roller_1",1,"mass_spring_roller_1",2);
else
data_dir_execute(@compare_solutions,"energy","mass_spring_roller_1",2);
end

fig = gcf();
ax = gca();
leg = fig.Children(1);
delete(leg)
%------------------------------------------
ylim(ax,[0,max_energy ])
xlim(ax,[1.35,3.2]);
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


%-----------------------------------------
xlim(ax.XLim);
ylim(ax.YLim);
zlim(ax.ZLim);

switch animation_state
    case 1
        lines = findobj(ax,"-property","XData");
        set(lines,"Visible","off");
    case 2
        lines = findobj(ax,"-property","XData");
        set(lines,"Visible","off");
        linear_marker = lines(2);
        linear_marker.Visible = "on";
        hold(ax,"on")
        plot(ax,linear_marker.XData*[1,1],[linear_marker.YData,max_energy],"k-","LineWidth",line_width)
        hold(ax,"off")
        uistack(linear_marker,"up",2)
    case 3
        lines = findobj(ax,"-property","XData");
        % set(lines,"Visible","off");
        hide_lines = [4,9,10];
        set(lines(hide_lines),"Visible","off");

        res_line_2 = lines(8);
        res_line_2.XData = res_line_2.XData(8:end);
        res_line_2.YData = res_line_2.YData(8:end);
        
        res_line_1 = lines(3);
        res_line_1.XData = [res_line_1.XData(1:20), res_line_2.XData(1)];
        res_line_1.YData = [res_line_1.YData(1:20), res_line_2.YData(1)];

        lines(7).LineStyle = "-";


    case 5
    swap_colours(ax,1,0);
end




%-----------------------------------------
save_fig(fig,fig_name +"_"+animation_state)