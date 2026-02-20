clear
close all

fig_name = "manifold_comp";
freq_lim = [0.85,1];
%----
mesh_style = {"EdgeColor","none","LineWidth",0.01,"FaceColor",get_plot_colours(3),"FaceLighting","gouraud","FaceAlpha",0.75,"Tag","stress_manifold"};
outline_style = {"Color","k","LineWidth",1};
Invariant_Opts.Colour = get_plot_colours(5);

%----
data_directory = get_project_path+"\examples\verification";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

fig = figure;
ax = axes(fig);
box(ax,"on")


% 
% ax = data_dir_execute(@plot_invariant_manifold,"cubic_mass_spring_1",1,"opts",Stress_Opts,"frequency limit",freq_lim,"axes",ax);
ax = data_dir_execute(@plot_invariant_manifold,"cubic_mass_spring_1",3,"opts",Invariant_Opts,"frequency limit",freq_lim,"axes",ax);

im_line = ax.Children(end);
x_limit = [min(im_line.XData,[],"all"),max(im_line.XData,[],"all")]*1;
y_limit = [min(im_line.YData,[],"all"),max(im_line.YData,[],"all")]*1;

%-----------------------------------------
[x1,x2,f] = get_stress_manifold(x_limit);
x1_mesh = [x1{1};x1{1}];
x2_mesh = [x2{1};x2{1}];
num_points = size(x1_mesh,2);
x1_dot_mesh = y_limit'.*ones(2,num_points);

hold(ax,"on")
stress_line = mesh(ax,x1_mesh,x1_dot_mesh,x2_mesh,mesh_style{:});
plot3(ax,x1_mesh(1,:),x1_dot_mesh(1,:),x2_mesh(1,:),outline_style{:})
plot3(ax,x1_mesh(2,:),x1_dot_mesh(2,:),x2_mesh(2,:),outline_style{:})
plot3(ax,x1_mesh(:,1),x1_dot_mesh(:,1),x2_mesh(:,1),outline_style{:})
plot3(ax,x1_mesh(:,end),x1_dot_mesh(:,end),x2_mesh(:,end))
hold(ax,"off")

ax.CameraPosition = [-4.7526   -4.0156    0.1488];

%------------------------------------------
im_line.DisplayName = "Invariant Manifold";
stress_line.DisplayName = "Stress Manifold";
legend(ax,[stress_line,im_line],"Position","north east")
%------------------------------------------
zlim(ax.ZLim)
save_fig(fig,fig_name)