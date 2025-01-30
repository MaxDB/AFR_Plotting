clear
close all
fig_name = "manifold_comparison";


Plot_Settings.plot_type = "physical";
Plot_Settings.coords = [3,2,1];

line_width = 3;
x_lim = [-0.05,0.05];
y_lim = [-0.06,0.06];
z_lim = [-1.1,1.1]*1e-3;
camera_position = [-0.0895   -0.5236    0.0172];
% camera_position = [-0.1841   -1.4300    0.0286];

orbit_sol_num = 1;
orbit_id = 134;

orbit_colour = get_plot_colours(3);
validation_orbit_colour = get_plot_colours(5);

%manifolds
% validation_time_points = [1,14,39,94,125]; %[1,161]
validation_time_points = 39;
% manifold_offsets = [-2.5,-2.5,-2.5]*1e-5;
manifold_offsets = -3.1*1e-5;
validation_colour = get_plot_colours(1);
validation_alpha = 0.5;

manifold_colour = get_plot_colours(2);

%orbit points
marker_size = 8;
marker_type = "o";
marker_edge = validation_colour;
marker_line_width = 1;


%--------------------------------------------------
fig = figure;
ax = axes(fig);
Plot_Settings.energy_limit = false;
Manifold_One.system = "mass_spring_roller_1";
Manifold_One.orbit = [orbit_sol_num,orbit_id];
Manifold_One.plot_validation_orbit = 1;
Manifold_Two.system = "mass_spring_roller_12";

current_directory = pwd;
data_directory = get_project_path+"\examples\3_dof_mass_spring";

cd(data_directory)
ax = compare_stress_manifold({Manifold_One,Manifold_Two},"opts",Plot_Settings,"axes",ax);
cd(current_directory)




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
        case "m-1,2"
            line.DisplayName = "$\mathcal W_2$";
            manifold_x = line.XData;
            manifold_y = line.YData;
            manifold_z = line.ZData;
            % line.Visible = "off";
            % line.Annotation.LegendInformation.IconDisplayStyle = "off";
            line.FaceColor = manifold_colour;
            uistack(line,"bottom")
            line.EdgeColor = manifold_colour;
        case "o-1-" + orbit_sol_num + "," + orbit_id
            line.DisplayName = "$\tilde{\mathbf x}^*(t)$";
            uistack(line,"top")
            line.LineStyle = "-";
            line.Color = get_plot_colours(3);
            line.LineWidth = line_width;
            % line.Visible = "off";
        case "vo-1-" + orbit_sol_num + "," + orbit_id
            line.DisplayName = "$\hat{\mathbf x}^*(t)$";
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

cd(data_directory)
Dyn_Data = initalise_dynamic_data(Manifold_One.system);
Rom = Dyn_Data.Dynamic_Model;
Static_Data = load_static_data(Rom);
Validated_Sol = Dyn_Data.load_solution(1,"validation");
Static_Data = Static_Data.add_validation_data(Validated_Sol.validation_modes);
Rom = Reduced_System(Static_Data);
cd(current_directory)

Dyn_Data.Dynamic_Model = Rom;

orbit_point_style = {"Marker",marker_type,"MarkerSize",marker_size,"MarkerEdgeColor",marker_edge,"LineWidth",marker_line_width,"LineStyle","none"};
validation_style  = {"EdgeColor","k","FaceColor",validation_colour,"FaceLighting","gouraud","FaceAlpha",validation_alpha,"Tag","validation_manifold"};
num_time_points = size(validation_time_points,2);
for iTime = 1:num_time_points
    time_point = validation_time_points(iTime);
    cd(data_directory)
    [x_hat,orbit_point,validation_point] = get_validation_manifold(time_point,Dyn_Data,[orbit_sol_num,orbit_id],ax_lims,manifold_offsets(iTime));
    cd(current_directory)
    hold on
    p_manifold = mesh(x_hat(:,:,Plot_Settings.coords(1)),x_hat(:,:,Plot_Settings.coords(2)),x_hat(:,:,Plot_Settings.coords(3)),validation_style{:});
    p_validation_orbit_point = plot3(validation_point(Plot_Settings.coords(1)),validation_point(Plot_Settings.coords(2)),validation_point(Plot_Settings.coords(3)),"MarkerFaceColor",validation_orbit_colour,orbit_point_style{:},"Tag","validation_point");
    p_orbit_point = plot3(orbit_point(Plot_Settings.coords(1)),orbit_point(Plot_Settings.coords(2)),orbit_point(Plot_Settings.coords(3)),"MarkerFaceColor",orbit_colour,orbit_point_style{:},"Tag","orbit_point");
    
    hold off
    % p_manifold.Annotation.LegendInformation.IconDisplayStyle = "off";
    % p_orbit_point.Annotation.LegendInformation.IconDisplayStyle = "off";
    % p_validation_orbit_point.Annotation.LegendInformation.IconDisplayStyle = "off";
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
            line.DisplayName = "$\mathcal W_{\mathcal R_1}$";
        case "m-1,2"
            line.DisplayName = "$\mathcal W_{\mathcal R_2}$";
        case "validation_manifold"
            line.DisplayName = "$\mathcal V_{\mathbf r^*_2(t_j)}$";
        case "orbit_point"
            line.DisplayName = "$\tilde{\mathbf x}^*(t_j)$";
        case "validation_point"
            line.DisplayName = "$\hat{\mathbf x}^*(t_j)$";
    end
end

% plot style

ax.CameraPosition = camera_position;
%------------------------------------------
leg = fig.Children(1);
leg.NumColumns = 2;
%------------------------------------------

save_fig(fig,fig_name)



%-----------------------------------------
