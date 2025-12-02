clear
close all
fig_name = "manifold_comparison";


Plot_Settings.plot_type = "physical";
Plot_Settings.coords = [3,2,1];
Plot_Settings.energy_limit = 0.025;
Plot_Settings.mesh_alpha = 0.5;

line_width = 3;
x_lim = [-0.05,0.05];
y_lim = [-0.06,0.06];
z_lim = [-1.2,1.5]*1e-3;

camera_position = [-0.0895   -0.5236    0.0172];
% camera_position = [-0.1177   -0.6994    0.0172];


orbit_sol_num = 1;
% orbit_id = 134;
orbit_id = 141;

orbit_colour = get_plot_colours(3);
validation_orbit_colour = get_plot_colours(5);

%manifolds
% validation_time_points = [1,14,39,94,125]; %[1,161]
validation_time_points = 40;
% manifold_offsets = [-2.5,-2.5,-2.5]*1e-5;
manifold_offsets = -5*1e-5;
validation_colour = get_plot_colours(1);
validation_alpha = 1;

manifold_colour = get_plot_colours(2);

%orbit points
marker_size = 10;
marker_type = "o";
marker_edge = validation_colour;
marker_line_width = 1;

text_style = {"FontName","Times New Roman","FontSize",8,"FontUnits","points"};
%--------------------------------------------------
data_directory = get_project_path + "\examples\validation\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

fig = figure;
ax = axes(fig);

Manifold_One.system = "mass_spring_roller_1";
Manifold_One.orbit = [orbit_sol_num,orbit_id];
Manifold_One.plot_validation_orbit = 1;
Manifold_Two.system = "mass_spring_roller_12";

data_dir_execute(@set_visualisation_level,0);
ax = data_dir_execute(@compare_stress_manifold,{Manifold_One,Manifold_Two},"opts",Plot_Settings,"axes",ax);


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

ax = cut_y_section(ax,-0.0454,1);
ax = cut_y_section(ax,y_lim(2),-1);

% 
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

orbit_point_style = {"Marker",marker_type,"MarkerSize",marker_size,"MarkerEdgeColor",marker_edge,"LineWidth",marker_line_width,"LineStyle","none"};
validation_style  = {"EdgeColor","k","FaceColor",validation_colour,"FaceLighting","gouraud","FaceAlpha",validation_alpha,"Tag","validation_manifold"};


time_point = validation_time_points;
[x_hat,orbit_point,validation_point] = data_dir_execute(@get_validation_manifold,time_point,Dyn_Data,[orbit_sol_num,orbit_id],ax_lims,manifold_offsets);



hold on
mesh(x_hat(:,:,Plot_Settings.coords(1)),x_hat(:,:,Plot_Settings.coords(2)),x_hat(:,:,Plot_Settings.coords(3)),validation_style{:});
plot3(validation_point(Plot_Settings.coords(1)),validation_point(Plot_Settings.coords(2)),validation_point(Plot_Settings.coords(3)),"MarkerFaceColor",validation_orbit_colour,orbit_point_style{:},"Tag","validation_point");


plot3(orbit_point(Plot_Settings.coords(1)),orbit_point(Plot_Settings.coords(2)),orbit_point(Plot_Settings.coords(3)),"MarkerFaceColor",orbit_colour,orbit_point_style{:},"Tag","orbit_point");
hold off;


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
delete(leg)
%------------------------------------------

save_fig(fig,fig_name)



%-----------------------------------------
