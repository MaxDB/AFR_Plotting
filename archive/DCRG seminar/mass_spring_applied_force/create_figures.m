clear
close all

animation_stage = 2;


%--------------------------------
fig_name = "applied_force_"+animation_stage;

Plot_Settings.energy_limit = 0.05;
Plot_Settings.plot_type = "physical";
Plot_Settings.coords = [3,2,1];

line_width = 4;
z_limit = [-1.75,2]*1e-3;
camera_position = [-0.2404   -1.8429    0.0217];


% mesh style
manifold1_width = 4;
manifold1_colour = [get_plot_colours(3),0.5];
manifold2_colour = get_plot_colours(2);

%--------------------------------------------------
data_directory = get_project_path + "\examples\3_dof_mass_spring";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

fig = figure;
ax = axes(fig);

Plot_Settings.legend = false;
Manifold_One.system = "mass_spring_roller_1";
Manifold_Two.system = "mass_spring_roller_12";

ax = data_dir_execute(@compare_stress_manifold,{Manifold_One,Manifold_Two},"opts",Plot_Settings,"axes",ax);

xlim(ax.XLim);
ylim(ax.YLim);
zlim(ax.ZLim);

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
            line.LineWidth = manifold1_width;
            if animation_stage < 2
                line.Visible = "off";
            end
        case "m-1,2"
            line.DisplayName = "$\mathcal W_2$";
            manifold_x = line.XData;
            manifold_y = line.YData;
            manifold_z = line.ZData;
            line.FaceColor = manifold2_colour;
            line.Visible = "off";
        case {"outline","grid_line"}
             line.Visible = "off";
    end
    if startsWith(line.Tag,"o-")
        tag_parts = split(line.Tag,",");
        orbit_num = str2double(tag_parts{end});
        orbit_index = find(orbit_num == orbit_ids);
        line.Color = [orbit_colours(orbit_index,:),0.1];
        
       
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