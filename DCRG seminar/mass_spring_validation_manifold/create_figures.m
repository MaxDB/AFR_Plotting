clear
close all
fig_name = "validation_manifold";
%---
Export_Settings.width = 60;
Export_Settings.height = 40;
Export_Settings.font_size = 22;
frame_rate = 60;
%------
Plot_Settings.plot_type = "physical";
Plot_Settings.coords = [3,2,1];

line_width = 3;
x_lim = [-0.05,0.05];
y_lim = [-0.06,0.06];
z_lim = [-1.2,1.5]*1e-3;
camera_position = [-0.0895   -0.5236    0.0172];

orbit_sol_num = 3;
orbit_id = 132;

orbit_colour = get_plot_colours(3);
validation_orbit_colour = get_plot_colours(5);


manifold_offsets = -1e-5;
validation_colour = get_plot_colours(1);
validation_alpha = 0.5;


%orbit points
marker_size = 18;
marker_type = "o";
marker_edge = validation_colour;
marker_line_width = 2;


%--------------------------------------------------
data_directory = get_project_path + "\examples\3_dof_mass_spring";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

fig = figure;
ax = axes(fig);
Plot_Settings.energy_limit = 0.03;
Plot_Settings.light_on = true;
Manifold_One.system = "mass_spring_roller_1";
Manifold_One.orbit = [orbit_sol_num,orbit_id];
Manifold_One.plot_validation_orbit = 1;
Manifold_Two.system = "mass_spring_roller_12";


ax = data_dir_execute(@compare_stress_manifold,{Manifold_One},"opts",Plot_Settings,"axes",ax);


%---------------------------------------------------------------------------------------------
lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    switch line.Tag
        case "m-1"
            line_x = line.XData;
            line_y = line.YData;
            line_z = line.ZData;
            line.LineStyle = "-";
            line.Visible = "off";
            line.Annotation.LegendInformation.IconDisplayStyle = "off";
            % line.EdgeColor = "none";
        case "o-1-" + orbit_sol_num + "," + orbit_id
            line.Annotation.LegendInformation.IconDisplayStyle = "off";
            uistack(line,"top")
            line.LineStyle = "-";
            line.Color = get_plot_colours(3);
            line.LineWidth = line_width;
            % line.Visible = "off";
        case "vo-1-" + orbit_sol_num + "," + orbit_id
            line.Annotation.LegendInformation.IconDisplayStyle = "off";
            line.LineWidth = line_width;
            line.Color = validation_orbit_colour;
            % line.Visible = "off";
            
    end
end


xlim(x_lim)
ylim(y_lim)
zlim(ax,z_lim)

xlabel(ax.XLabel.String + " (m)")
ylabel(ax.YLabel.String + " (m)")
zlabel(ax.ZLabel.String + " (m)")



ax_lims(Plot_Settings.coords(1),:) = x_lim;
ax_lims(Plot_Settings.coords(2),:) = y_lim;
ax_lims(Plot_Settings.coords(3),:) = z_lim;


Dyn_Data = data_dir_execute(@initalise_dynamic_data,Manifold_One.system);
Rom = Dyn_Data.Dynamic_Model;
Static_Data = data_dir_execute(@load_static_data,Rom);
Validated_Sol = data_dir_execute(@Dyn_Data.load_solution,orbit_sol_num,"validation");
Static_Data = data_dir_execute(@Static_Data.add_validation_data,Validated_Sol.validation_modes);
Rom = data_dir_execute(@Reduced_System,Static_Data);

Dyn_Data.Dynamic_Model = Rom;
%--------
% line style
lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    switch line.Tag
        case "m-1"
            line.LineWidth = line_width;
            line.Annotation.LegendInformation.IconDisplayStyle = "off";
        case "m-1,2"
            line.Annotation.LegendInformation.IconDisplayStyle = "off";
    end
end

% plot style
fig.Color = "w";
delete(fig.Children(1))
ax.CameraPosition = camera_position;
%---------


orbit_point_style = {"Marker",marker_type,"MarkerSize",marker_size,"MarkerEdgeColor",marker_edge,"LineWidth",marker_line_width};
validation_style  = {"EdgeColor","k","FaceColor",validation_colour,"FaceLighting","gouraud","FaceAlpha",validation_alpha};

hold on
p_manifold = mesh(zeros(2),zeros(2),zeros(2),validation_style{:});
p_orbit_point = plot3(0,0,0,"MarkerFaceColor",orbit_colour,orbit_point_style{:});
p_validation_orbit_point = plot3(0,0,0,"MarkerFaceColor",validation_orbit_colour,orbit_point_style{:});
hold off
p_manifold.Annotation.LegendInformation.IconDisplayStyle = "off";
p_manifold.DisplayName = "$\mathcal V_{\mathbf r_2^*}$";
p_orbit_point.Annotation.LegendInformation.IconDisplayStyle = "off";
p_validation_orbit_point.Annotation.LegendInformation.IconDisplayStyle = "off";


Orbit = data_dir_execute(@Dyn_Data.get_orbit,orbit_sol_num,orbit_id);
orbit_time = Orbit.tbp';
num_time_points = size(orbit_time,2);


manifold_data = zeros(2,2,3,num_time_points);
orbit_data = zeros(3,num_time_points);
validation_orbit_data = zeros(3,num_time_points);
for iTime = 1:num_time_points
    [x_hat,orbit_point,validation_point] = data_dir_execute(@get_validation_manifold,iTime,Dyn_Data,[orbit_sol_num,orbit_id],ax_lims,manifold_offsets);
    
    manifold_data(:,:,1,iTime) = x_hat(:,:,Plot_Settings.coords(1));
    manifold_data(:,:,2,iTime) = x_hat(:,:,Plot_Settings.coords(2));
    manifold_data(:,:,3,iTime) = x_hat(:,:,Plot_Settings.coords(3));
    % p_manifold.XData = x_hat(:,:,Plot_Settings.coords(1));
    % p_manifold.YData = x_hat(:,:,Plot_Settings.coords(2));
    % p_manifold.ZData = x_hat(:,:,Plot_Settings.coords(3));
    
    orbit_data(1,iTime) = orbit_point(Plot_Settings.coords(1));
    orbit_data(2,iTime) = orbit_point(Plot_Settings.coords(2));
    orbit_data(3,iTime) = orbit_point(Plot_Settings.coords(3));
    % p_orbit_point.XData = orbit_point(Plot_Settings.coords(1));
    % p_orbit_point.YData = orbit_point(Plot_Settings.coords(2));
    % p_orbit_point.ZData = orbit_point(Plot_Settings.coords(3));

    validation_orbit_data(1,iTime) = validation_point(Plot_Settings.coords(1));
    validation_orbit_data(2,iTime) = validation_point(Plot_Settings.coords(2));
    validation_orbit_data(3,iTime) = validation_point(Plot_Settings.coords(3));
    % p_validation_orbit_point.XData = validation_point(Plot_Settings.coords(1));
    % p_validation_orbit_point.YData = validation_point(Plot_Settings.coords(2));
    % p_validation_orbit_point.ZData = validation_point(Plot_Settings.coords(3));
    
    % drawnow
end

%------------------------------------------

%------------------------------------------
frame_t = orbit_time(1):1/frame_rate:orbit_time(end);
num_frames = size(frame_t,2);

frame_manifold = zeros(2,2,3,num_frames);
frame_orbit = zeros(3,num_frames);
frame_validation = zeros(3,num_frames);


for iDof = 1:3
    frame_orbit(iDof,:) = interp1(orbit_time,orbit_data(iDof,:),frame_t);
    frame_validation(iDof,:) = interp1(orbit_time,validation_orbit_data(iDof,:),frame_t);

    for iCounter = 1:2
        for jCounter = 1:2
            frame_manifold(iCounter,jCounter,iDof,:) = interp1(orbit_time,squeeze(manifold_data(iCounter,jCounter,iDof,:)),frame_t);
        end
    end
end
%-----------------------------------------
fig = set_fig_style(fig,Export_Settings);
% fig_dims = fig.Position;
% fig_width = fig_dims(3);
% fig_height = fig_dims(4);
% max_scale_factor = min(1920/fig_width,1080/fig_height);
% 
% fig.Position = [10,100,fig_width*max_scale_factor,fig_height*max_scale_factor];

%-----------------------------------------
system_frames(num_frames) = struct('cdata',[],'colormap',[]);
for iFrame = 1:num_frames
    p_manifold.XData = frame_manifold(:,:,1,iFrame);
    p_manifold.YData = frame_manifold(:,:,2,iFrame);
    p_manifold.ZData = frame_manifold(:,:,3,iFrame);

    p_orbit_point.XData = frame_orbit(1,iFrame);
    p_orbit_point.YData = frame_orbit(2,iFrame);
    p_orbit_point.ZData = frame_orbit(3,iFrame);

    p_validation_orbit_point.XData = frame_validation(1,iFrame);
    p_validation_orbit_point.YData = frame_validation(2,iFrame);
    p_validation_orbit_point.ZData = frame_validation(3,iFrame);

    drawnow
    system_frames(iFrame) = getframe(fig);
end
animation.frames = system_frames;
animation.frame_rate = frame_rate;
animation.num_frames = num_frames;
animation.size = fig.Position;

% fig.Position = fig_dims;
%-----------------------------------------



export_animation(animation,"validation_manifold")