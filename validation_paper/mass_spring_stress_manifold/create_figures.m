clear
close all

fig_name = "stress_manifold_comp";

Plot_Settings.energy_limit = 0.05;
Plot_Settings.plot_type = "physical";
Plot_Settings.coords = [3,2,1];

line_width = 2;
z_limit = [-1.75,2]*1e-3;
camera_position = [-0.2404   -1.8429    0.0217];

orbit_sol_num = 1;
orbit_id = 141;


% mesh style
manifold1_colour = get_plot_colours(1);
manifold2_colour = get_plot_colours(2);
%--------------------------------------------------
data_directory = get_project_path + "\examples\validation\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

fig = figure;
ax = axes(fig);

Plot_Settings.legend = false;
Manifold_One.system = "mass_spring_roller_1";
Manifold_One.orbit = [orbit_sol_num,orbit_id];
Manifold_One.plot_validation_orbit = 0;
Manifold_Two.system = "mass_spring_roller_12";

ax = data_dir_execute(@compare_stress_manifold,{Manifold_One,Manifold_Two},"opts",Plot_Settings,"axes",ax);

% contour
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
            line.Color = manifold1_colour;
        case "m-1,2"
            line.DisplayName = "$\mathcal W_2$";
            manifold_x = line.XData;
            manifold_y = line.YData;
            manifold_z = line.ZData;
            line.FaceColor = manifold2_colour;
        case "o-1-" + orbit_sol_num + "," + orbit_id
            line.DisplayName = "$\tilde{\mathbf x}^*(t)$";
            uistack(line,"top")
            line.LineStyle = "-";
            line.Color = get_plot_colours(3);
    end
end


y_limit = ax.YLim;
x_limit = ax.XLim;

xlim(ax,x_limit)
ylim(ax,y_limit)
zlim(ax,z_limit)

xlabel(ax.XLabel.String + " (m)")
ylabel(ax.YLabel.String + " (m)")
zlabel(ax.ZLabel.String + " (m)")

% plane_data = ones(size(line_z));
% line_style = {"--k","DisplayName",""};
% hold(ax_3d,"on")
% plot3(ax_3d,line_x,line_y,z_limit(1)*plane_data,line_style{:})
% plot3(ax_3d,x_limit(2)*plane_data,line_y,line_z,line_style{:})
% plot3(ax_3d,line_x,y_limit(2)*plane_data,line_z,line_style{:})
% hold(ax_3d,"off")

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
    end
end

% plot style
zlim(ax,z_limit)
ax.CameraPosition = camera_position;

%------------------------------------------

save_fig(fig,fig_name)