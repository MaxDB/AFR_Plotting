clear
close all
fig_name = "validation_manifold";


Plot_Settings.plot_type = "physical";
Plot_Settings.coords = [3,2,1];

line_width = 2;
x_lim = [-0.05,0.05];
y_lim = [-0.06,0.06];
z_lim = [-1.2,1.5]*1e-3;
camera_position = [-0.0895   -0.5236    0.0172];
% camera_position = [ -0.1254   -1.2597    0.0301];

orbit_sol_num = 1;

orbit_colour = get_plot_colours(3);
validation_orbit_colour = get_plot_colours(5);

%manifolds
% validation_time_points = [41,68,81,94,120,149,1,14,41];
% validation_time_points = [1,14,41,94,120];
validation_time_points = [90,111,1,11,31];
% manifold_offsets = [-2.5,-2.5,-2.5]*1e-5;
manifold_offsets = -[1,1,1,1,1,1,1]*1e-5;
validation_colour = get_plot_colours(1);
validation_alpha = 0.5;


%orbit points
marker_size = 10;
marker_type = "o";
marker_edge = validation_colour;
marker_line_width = 1;


%--------------------------------------------------
data_directory = get_project_path + "\examples\validation\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Dyn_Data = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_1");
special_points = data_dir_execute(@Dyn_Data.get_special_point,1,"X");
orbit_id = special_points(1);

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
            line.Marker = "none";
            % line.Visible = "off";
        case "vo-1-" + orbit_sol_num + "," + orbit_id
            line.Annotation.LegendInformation.IconDisplayStyle = "off";
            line.LineWidth = line_width;
            line.Color = validation_orbit_colour;
            line.Marker = "none";
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
Validated_Sol = data_dir_execute(@Dyn_Data.load_solution,1,"validation");
Static_Data = data_dir_execute(@Static_Data.add_validation_data,Validated_Sol.validation_modes);
Rom = data_dir_execute(@Reduced_System,Static_Data);

Dyn_Data.Dynamic_Model = Rom;

orbit_point_style = {"Marker",marker_type,"MarkerSize",marker_size,"MarkerEdgeColor",marker_edge,"LineWidth",marker_line_width};
validation_style  = {"EdgeColor","k","FaceColor",validation_colour,"FaceLighting","gouraud","FaceAlpha",validation_alpha};
num_time_points = size(validation_time_points,2);
for iTime = 1:num_time_points
    time_point = validation_time_points(iTime);
    [x_hat,orbit_point,validation_point] = data_dir_execute(@get_validation_manifold,time_point,Dyn_Data,[orbit_sol_num,orbit_id],ax_lims,manifold_offsets(iTime));
    hold on
    p_manifold = mesh(x_hat(:,:,Plot_Settings.coords(1)),x_hat(:,:,Plot_Settings.coords(2)),x_hat(:,:,Plot_Settings.coords(3)),validation_style{:});
    p_orbit_point = plot3(orbit_point(Plot_Settings.coords(1)),orbit_point(Plot_Settings.coords(2)),orbit_point(Plot_Settings.coords(3)),"MarkerFaceColor",orbit_colour,orbit_point_style{:});
    p_validation_orbit_point = plot3(validation_point(Plot_Settings.coords(1)),validation_point(Plot_Settings.coords(2)),validation_point(Plot_Settings.coords(3)),"MarkerFaceColor",validation_orbit_colour,orbit_point_style{:});
    hold off
    if iTime > 1
        p_manifold.Annotation.LegendInformation.IconDisplayStyle = "off";
    else
        p_manifold.DisplayName = "$\mathcal V_{\mathbf r_2^*}$";
    end
    p_orbit_point.Annotation.LegendInformation.IconDisplayStyle = "off";
    p_validation_orbit_point.Annotation.LegendInformation.IconDisplayStyle = "off";
end

%------------------------------------------

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

ax.CameraPosition = camera_position;

%------------------------------------------
delete(findobj(fig,"Type","legend"))
save_fig(fig,fig_name)



%-----------------------------------------
