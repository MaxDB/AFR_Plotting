clear
close all

fig_3d_name = "invariant_manifold_3d";
fig_2d_name = "invariant_manifold_2d";
%----
system_name = "cubic_mass_spring_12";
sol_num = [2,3];

max_x1 = 0.65;
freq_range = [0.78,1];

lower_range = [-0.404,0.278;
               -0.0895,-0.0449];
%--------

[ax_2d,ax_3d] = plot_invariant_manifold(system_name,sol_num,max_x1,freq_range);




% xlim(ax_3d,[-0.6,0.4])
% ylim(ax_3d,[-0.6,0.6])
% zlim(ax_3d,[-0.4,0.2])

xlabel(ax_3d,"$x_1$ (m)",Interpreter="latex")
ylabel(ax_3d,"$\dot{x}_1$ (m/s)",Interpreter="latex")
zlabel(ax_3d,"$x_2$ (m)",Interpreter="latex")



ax_3d.CameraPosition = [-4.5710   -5.4243    3.5746];
%------------------------------------------
[x1,x2,f] = get_stress_manifold([-0.4926,0.311]);



hold(ax_2d,"on")
stress_line = plot(ax_2d,x1{1},x2{1},"-","LineWidth",1,"Color",get_plot_colours(3),"DisplayName","Stress Manifold");
hold(ax_2d,"off")

invariant_line = ax_2d.Children(end);
invariant_line.DisplayName = "Invariant Manifold";

legend(ax_2d,[stress_line,invariant_line],"Location","northwest","AutoUpdate","off")
%------------------------------------------
hold(ax_2d,"on")
ax_2d = plot_range_marker(ax_2d,lower_range);
hold(ax_2d,"off")





xlabel(ax_2d,"$x_1$ (m)",Interpreter="latex")
ylabel(ax_2d,"$x_2$ (m)",Interpreter="latex")

xlim(ax_2d,[-0.65,0.45])
ylim(ax_2d,[-0.45,0.2])
%------------------------------------------
fig_3d = ax_3d.Parent;
fig_2d = ax_2d.Parent;
save_fig(fig_3d,fig_3d_name)
save_fig(fig_2d,fig_2d_name)



function ax = plot_range_marker(ax,range_points)
left_angle = 35;
right_angle = -25;
line_length = 0.15;

left_point = range_points(:,1);
right_point = range_points(:,2);

left_angle = left_angle*pi/180;
right_angle = right_angle*pi/180;

left_line = [left_point + line_length/2 * [-sin(left_angle);cos(left_angle)],left_point + line_length/2 * [sin(left_angle);-cos(left_angle)]];
right_line = [right_point + line_length/2 * [-sin(right_angle);cos(right_angle)],right_point + line_length/2 * [sin(right_angle);-cos(right_angle)]];

p1 = plot(ax,left_line(1,:),left_line(2,:),"k--");
p2 = plot(ax,right_line(1,:),right_line(2,:),"k--");

text(left_line(1,2),left_line(2,2)+0.005," \leftarrow L_2")
text(right_line(1,2)-0.14,right_line(2,2)+0.005,"L_2 \rightarrow")
uistack(p1,"bottom")
uistack(p2,"bottom")
end

