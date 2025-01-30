clear
close all

fig_name = "stress_manifold_comp";

Plot_Settings.plot_type = "physical";
Plot_Settings.coords = [3,2,1];

line_width = 2;
z_limit = [-2,2]*1e-3;
camera_position = [  -0.1877   -1.4918    0.0280];

orbit_sol_num = 1;
orbit_id = 134;


% mesh style
manifold_colour = get_plot_colours(2);
%--------------------------------------------------
fig_3d = figure;
ax_3d = axes(fig_3d);
Plot_Settings.energy_limit = false;
Manifold_One.system = "mass_spring_roller_1";
Manifold_One.orbit = [orbit_sol_num,orbit_id];
Manifold_One.plot_validation_orbit = 0;
Manifold_Two.system = "mass_spring_roller_12";

curret_directory = pwd;
data_directory = get_project_path+"\examples\3_dof_mass_spring";

cd(data_directory)
ax_3d = compare_stress_manifold({Manifold_One,Manifold_Two},"opts",Plot_Settings,"axes",ax_3d);
cd(curret_directory)




% contour
lines = ax_3d.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    switch line.Tag
        case "m-1"
            line_x = line.XData;
            line_y = line.YData;
            line_z = line.ZData;
            line.LineStyle = "-";
        case "m-1,2"
            line.DisplayName = "$\mathcal W_2$";
            manifold_x = line.XData;
            manifold_y = line.YData;
            manifold_z = line.ZData;
            line.FaceColor = manifold_colour;
            line.EdgeColor = manifold_colour;
        case "o-1-" + orbit_sol_num + "," + orbit_id
            line.DisplayName = "$\tilde{\mathbf x}^*(t)$";
            uistack(line,"top")
            line.LineStyle = "-";
            line.Color = get_plot_colours(3);
    end
end


y_limit = ax_3d.YLim;
x_limit = ax_3d.XLim;

xlim(ax_3d,x_limit)
ylim(ax_3d,y_limit)
zlim(ax_3d,z_limit)

xlabel(ax_3d.XLabel.String + " (m)")
ylabel(ax_3d.YLabel.String + " (m)")
zlabel(ax_3d.ZLabel.String + " (m)")

% plane_data = ones(size(line_z));
% line_style = {"--k","DisplayName",""};
% hold(ax_3d,"on")
% plot3(ax_3d,line_x,line_y,z_limit(1)*plane_data,line_style{:})
% plot3(ax_3d,x_limit(2)*plane_data,line_y,line_z,line_style{:})
% plot3(ax_3d,line_x,y_limit(2)*plane_data,line_z,line_style{:})
% hold(ax_3d,"off")

%------------------------------------------

% line style
lines = ax_3d.Children;
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
zlim(ax_3d,z_limit)
ax_3d.CameraPosition = camera_position;

%------------------------------------------

save_fig(fig_3d,fig_name)