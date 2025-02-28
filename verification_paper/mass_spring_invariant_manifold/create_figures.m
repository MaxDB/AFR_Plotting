clear
close all

fig_3d_name = "invariant_manifold_3d";
fig_2d_name = "invariant_manifold_2d";
%----
system_name = "cubic_mass_spring_12";
sol_num = [2,3,4];

max_x1 =  0.42;
freq_range = [0.65,1];


[ax_2d,ax_3d] = plot_invariant_manifold(system_name,sol_num,max_x1,freq_range);




% xlim(ax_3d,[-0.6,0.4])
% ylim(ax_3d,[-0.6,0.6])
% zlim(ax_3d,[-0.4,0.2])

xlabel(ax_3d,"$x_1$ (m)",Interpreter="latex")
ylabel(ax_3d,"$\dot{x}_1$ (m/s)",Interpreter="latex")
zlabel(ax_3d,"$x_2$ (m)",Interpreter="latex")



ax_3d.CameraPosition = [-4.5710   -5.4243    3.5746];
%------------------------------------------
[x1,x2,f] = get_stress_manifold([-1.5,1.5]);

hold(ax_2d,"on")
plot(ax_2d,x1{1},x2{1},"--","LineWidth",2,"Color",get_plot_colours(3))
hold(ax_2d,"off")






xlabel(ax_2d,"$x_1$ (m)",Interpreter="latex")
ylabel(ax_2d,"$x_2$ (m)",Interpreter="latex")

xlim(ax_2d,[-0.6,0.6])
ylim(ax_2d,[-0.3,0.01])
%------------------------------------------
fig_3d = ax_3d.Parent;
fig_2d = ax_2d.Parent;
save_fig(fig_3d,fig_3d_name)
save_fig(fig_2d,fig_2d_name)





