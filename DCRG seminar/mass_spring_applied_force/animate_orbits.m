clear
close all

period = 30;
frame_rate = 20;
start_index = 11;

            
marker_colour = get_plot_colours(3);
%--------------------

%--------------------
open("figures\applied_force_2_export.fig")
fig = gcf;

fig.Position(4) = fig.Position(4)*1.09;
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
ani_marker = plot3(ax,0,0,0,"o","MarkerSize",8,"LineWidth",1,"MarkerEdgeColor","w","MarkerFaceColor",marker_colour);
hold(ax,"off")


% for iFrame = 1:num_frames
%     iDisp = frame_x(:,iFrame);
%     ani_marker.XData = iDisp(1);
%     ani_marker.YData = iDisp(2);
%     ani_marker.ZData = iDisp(3);
% 
%     drawnow
%     system_frames(iFrame) = getframe(fig);
%     if iFrame == num_frames
%         break
%     end
% end
% 
% animation.frames = system_frames;
% animation.frame_rate = frame_rate;
% animation.num_frames = num_frames;
% animation.fig_size = fig.Position;
% animation.ax_size = ax.Position;
% %-----------------
% export_gif(animation,"manifold_marker")
close all


%-------------------------------------------------

            

%--------------------


rom = "mass_spring_roller_12";
data_directory = get_project_path + "\examples\3_dof_mass_spring";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Dyn_Data = data_dir_execute(@initalise_dynamic_data,rom);
Rom = Dyn_Data.Dynamic_Model;
Model = Dyn_Data.Dynamic_Model.Model;

fig = figure;
% fig.Position = [0,0,1920,1080];
ax = axes(fig,"Position",[0,0,1,1]);

System = draw_system(Model,ax);

%------------------------------------------
System_Ani = System.setup_animation_function(Dyn_Data,data_dir_execute);



%--
displacement = frame_x([3,2,1],:);


System_Ani.set_mass_colour(marker_colour)
animation = System_Ani.animate_displacement(time,displacement);
export_animation(animation,"mass_spring_forced")

