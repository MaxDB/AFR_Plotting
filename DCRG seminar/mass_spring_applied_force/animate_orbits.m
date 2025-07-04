clear
close all

period = 30;
frame_rate = 10;%
start_index = 11;

            
marker_colour = get_plot_colours(3);
%--------------------

%--------------------
open("figures\applied_force_2_export.fig")
fig = gcf;

fig.Position(4) = fig.Position(4)*0.92;
fig.Color = [0.8,0.8,0.8];
ax = gca;
xlim(ax,ax.XLim);
ylim(ax,ax.YLim);
zlim(ax,ax.ZLim);

manifold = findobj(ax,"Tag","m-1");
lines = findobj(ax,"-property","XData");
set(lines,"Visible","off")
axis("off")

%-----------------
manifold_x = manifold.XData;
manifold_y = manifold.YData;
manifold_z = manifold.ZData;

manifold_reorder = @(data) [data(start_index:end),flip(data(1:(end-1))),data(2:(start_index))];
manifold_x = manifold_reorder(manifold_x);
manifold_y = manifold_reorder(manifold_y);
manifold_z = manifold_reorder(manifold_z);

num_frames = period*frame_rate;
manifold_time = linspace(0,period,size(manifold_x,2));
time = linspace(0,period,num_frames);

marker_x = interp1(manifold_time,manifold_x,time);
marker_y = interp1(manifold_time,manifold_y,time);
marker_z = interp1(manifold_time,manifold_z,time);

num_dof = 3;
frame_x = zeros(num_dof,num_frames);
frame_x(1,:) = marker_x;
frame_x(2,:) = marker_y;
frame_x(3,:) = marker_z;


system_frames(num_frames) = struct('cdata',[],'colormap',[]); 
hold(ax,"on")
ani_marker = plot3(ax,0,0,0,"o","MarkerSize",14,"LineWidth",2,"MarkerEdgeColor","w","MarkerFaceColor",marker_colour);
hold(ax,"off")


for iFrame = 1:num_frames
    iDisp = frame_x(:,iFrame);
    ani_marker.XData = iDisp(1);
    ani_marker.YData = iDisp(2);
    ani_marker.ZData = iDisp(3);

    drawnow
    system_frames(iFrame) = getframe(fig);
    if iFrame == num_frames
        break
    end
end

animation.frames = system_frames;
animation.frame_rate = frame_rate;
animation.num_frames = num_frames;
animation.fig_size = fig.Position;
animation.ax_size = ax.Position;
%-----------------
export_gif(animation,"manifold_marker")
close all


%-------------------------------------------------

            

%--------------------


rom = "mass_spring_roller_1";
data_directory = get_project_path + "\examples\3_dof_mass_spring";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Dyn_Data = data_dir_execute(@initalise_dynamic_data,rom);
Rom = Dyn_Data.Dynamic_Model;
Model = Dyn_Data.Dynamic_Model.Model;

fig = figure;
% fig.Position = [0,0,1920,1080];
ax = axes(fig,"Position",[0,0,1,1]);

System = draw_system(Model,ax);
ax = System.animation_ax;
%------------------------------------------
System_Ani = System.setup_animation_function(Dyn_Data,data_dir_execute);



%--
sf = 2;
displacement = frame_x([3,2,1],:)*sf;


System_Ani.set_mass_colour(marker_colour)
animation = System_Ani.animate_displacement(time,displacement);
%------------
export_animation(animation,"mass_spring_forced")
%------------
% create arrow
r_evec = Rom.Model.reduced_eigenvectors;
r_disp = r_evec'*displacement/sf;
f_r = Rom.Force_Polynomial.evaluate_polynomial(r_disp);

fig = figure;
fig.Position = animation.size;
fig.Position(4) = fig.Position(4)*0.8; %0.74
fig.Color = [0.8,0.8,0.8];
ax_arrow = axes(fig);

ax_arrow.Color = [0.8,0.8,0.8];


arm_length = 0.15;
head_width = 0.075;
arrow_width = 0.05;

arrow_start = [1.2,1.2];
arrow_end = [1.2,1.2];
arrow_left_end = arrow_end - [arm_length,0];
arrow_right_end = arrow_end + [arm_length,0];


zero_angle = 0;
max_angle = pi/3;

max_height = 1;
max_force = max(abs(f_r));

hold on
% arrow = plot(ax_arrow,[arrow_start(1),arrow_end(1)],[arrow_start(2),arrow_end(2)],"-","LineWidth",arrow_width,"Color",get_plot_colours(3));
arrow = rectangle("Position",[arrow_start(1)-arrow_width/2,arrow_start(2),arrow_width,0],"FaceColor",get_plot_colours(3),"EdgeColor","w","LineWidth",3);
arrow_head_def = polyshape([0,arm_length,arm_length,0,-arm_length,-arm_length] + arrow_end(1),[head_width/2,head_width/2,-head_width/2,-head_width/2,-head_width/2,head_width/2] + arrow_end(2),"Simplify",false);
arrow_head = plot(arrow_head_def,"FaceColor",get_plot_colours(3),"EdgeColor","w","LineWidth",3,"FaceAlpha",1);
hold off
xlim(ax_arrow,ax.XLim);
ylim(ax_arrow,ax.YLim);
axis off


length_ratio = 0.01;
arrow_frames(num_frames) = struct('cdata',[],'colormap',[]);
for iFrame = 1:num_frames
    arrow.Position(2) = arrow_start(2)+displacement(2,iFrame);
    arrow_height = f_r(iFrame)*max_height/max_force;
    if arrow_height >= 0
        arrow.Position(4) = arrow_height;
    else
        arrow.Position(4) = abs(arrow_height);
        arrow.Position(2) = arrow.Position(2) + arrow_height;
    end

    


    head_x = arrow_head_def.Vertices(:,1);
    head_y = arrow_head_def.Vertices(:,2);

    if arrow_height >=0
        arrow_head.Shape.Vertices(:,2) = arrow.Position(2) + arrow.Position(4) + [head_width/2,head_width/2,-head_width/2,-head_width/2,-head_width/2,head_width/2];
    else
        arrow_head.Shape.Vertices(:,2) = arrow.Position(2) + [head_width/2,head_width/2,-head_width/2,-head_width/2,-head_width/2,head_width/2];
    end

    angle = zero_angle + f_r(iFrame)*max_angle/max_force;
    y_diff = -arm_length*sin(angle);
    
    arrow_head.Shape.Vertices(6,2) = arrow_head.Shape.Vertices(1,2) + y_diff;
    arrow_head.Shape.Vertices(5,2) = arrow_head.Shape.Vertices(4,2) + y_diff;

    arrow_head.Shape.Vertices(2,2) = arrow_head.Shape.Vertices(1,2) + y_diff;
    arrow_head.Shape.Vertices(3,2) = arrow_head.Shape.Vertices(4,2) + y_diff;


    drawnow
    arrow_frames(iFrame) = getframe(ax_arrow);
end

arrow_animation = animation;
arrow_animation.frames = arrow_frames;

%-----------------
export_gif(arrow_animation,"arrow")



