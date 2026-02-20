clear
close all

force1_fig_name = "force1";
force2_fig_name = "force2";
%----

x1_lim = [-1.3,1.2];
x2_lim = [-2,0.1];


zero_colour = get_plot_colours(1);
camera_position = [-14.8530  -12.6697  124.4440];

plot_colours = get_plot_colours([3,5]);
line_width = 4;
zero_style = {"EdgeColor","k","LineWidth",1,"FaceColor",zero_colour,"FaceLighting","gouraud","FaceAlpha",0.9,"Tag","zero"};
%------------------------------------------
[r,x2_tilde,f1_tilde] = get_stress_manifold(x1_lim.*[1,0.97]);
[x1,x2,f1,f2,Grid_Data] = get_restoring_force(x1_lim,x2_lim);
%------------------------------------------
force2_fig = figure;
ax = gca();
box(ax,"on")

ax = plot_manifold(ax,x1,x2,f2,2,Grid_Data);
xlim(ax,x1_lim)
ylim(ax,x2_lim)


[zero_x,zero_y] = meshgrid(x1_lim,x2_lim);
zero_z = zeros(2);
hold(ax,"on")
mesh(ax,zero_x,zero_y,zero_z,zero_style{:})
hold(ax,"off")

hold(ax,"on")
for iBranch = 1:2
    f2_branch = zeros(size(r{iBranch}));
    plot3(ax,r{iBranch},x2_tilde{iBranch},f2_branch,"LineWidth",line_width,"Color",plot_colours(iBranch,:))
end
hold(ax,"off")
xlabel("$x_1$ (m)","Interpreter","latex")
ylabel("$x_2$ (m)","Interpreter","latex")
zlabel("$f_2$ (N)","Interpreter","latex")

ax.CameraPosition = camera_position;
%------------------------------------------
%------------------------------------------

camera_position = [-14.8530  -12.6697  124.4440];
x2_lim = [-2,0.5];
f1_lim = [-25,15];
%------------------------------------------
force1_fig = figure;
ax = gca();
box(ax,"on")

ax = plot_manifold(ax,x1,x2,f1,1,Grid_Data);
xlim(ax,x1_lim)
ylim(ax,x2_lim)
zlim(ax,f1_lim)
hold(ax,"on")
for iBranch = 1:2
    z_bottom = ones(size(r{iBranch}))*f1_lim(1);
    x2_left = ones(size(r{iBranch}))*x2_lim(2);

    plot3(ax,r{iBranch},x2_tilde{iBranch},f1_tilde{iBranch},"LineWidth",line_width,"Color",plot_colours(iBranch,:))
    plot3(ax,r{iBranch},x2_tilde{iBranch},z_bottom,"LineWidth",line_width/4,"Color",plot_colours(iBranch,:))
    plot3(ax,r{iBranch},x2_left,f1_tilde{iBranch},"LineWidth",line_width/4,"Color",plot_colours(iBranch,:))
end
hold(ax,"off")
xlabel("$x_1$ (m)","Interpreter","latex")
ylabel("$x_2$ (m)","Interpreter","latex")
zlabel("$f_1$ (N)","Interpreter","latex")

ax.CameraPosition = camera_position;

%------------------------------------------
save_fig(force1_fig,force1_fig_name)
save_fig(force2_fig,force2_fig_name)