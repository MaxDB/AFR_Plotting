clear
close all
fig_name = "validation_orbit";

sol_id = 1;
orbit_id = 141;

line_width = 2;
orbit_colour = get_plot_colours(3);
validation_colour = get_plot_colours(5);

% validation_time_points = [1,14,39,94,120];
validation_time_points = [39,69,81,94,120,149,1,14,39];

marker_size = 10;
marker_type = "o";
marker_edge = "k";
marker_line_width = 1;

text_style = {"FontName","Times New Roman","FontSize",8,"FontUnits","points","HorizontalAlignment","center"};
%--------------------------------------------------
fig = figure;
ax = axes(fig);
box on

%--------------------------------------------------
data_directory = get_project_path + "\examples\validation\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});


Dyn_Data = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_1");
Dyn_Data_12 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_12");
%------------------------------------------
Rom = Dyn_Data.Dynamic_Model;
num_modes = 1;
Rom_12 = Dyn_Data_12.Dynamic_Model;

evec_2 = Rom_12.Model.reduced_eigenvectors;
mass = Rom.Model.mass;

Disp_Poly = Rom.Physical_Displacement_Polynomial;
r1_lims = Disp_Poly.input_limit;
r1 = linspace(r1_lims(1),r1_lims(2),100);
x1 = Disp_Poly.evaluate_polynomial(r1);

%------------------------------------------
orbit_style = {"LineWidth",line_width};


[orbit,validation_orbit] = data_dir_execute(@Dyn_Data.get_orbit,sol_id,orbit_id,1);


r1_orbit = orbit.xbp(:,1:num_modes)';
x_orbit = Disp_Poly.evaluate_polynomial(r1_orbit);
r2_orbit = evec_2'*mass*x_orbit;

r2_validation_orbit = r2_orbit + validation_orbit.h;


hold on
plot(r2_orbit(2,:),r2_orbit(1,:),orbit_style{:},"Color",orbit_colour)
plot(r2_validation_orbit(2,:),r2_validation_orbit(1,:),"-",orbit_style{:},"Color",validation_colour)
hold off
%------------------------------------------

orbit_point_style = {"Marker",marker_type,"MarkerSize",marker_size,"MarkerEdgeColor",marker_edge,"LineWidth",marker_line_width};

time_labels = [1,2,3,4,5];
num_time_points = length(time_labels);
for iTime = 1:num_time_points
    time_point = validation_time_points(iTime);
    hold on
    plot(r2_orbit(2,time_point),r2_orbit(1,time_point),"MarkerFaceColor",orbit_colour,orbit_point_style{:});
    text(r2_orbit(2,time_point),r2_orbit(1,time_point),string(time_labels(iTime)),text_style{:});

    plot(r2_validation_orbit(2,time_point),r2_validation_orbit(1,time_point),"MarkerFaceColor",validation_colour,orbit_point_style{:});
    text(r2_validation_orbit(2,time_point),r2_validation_orbit(1,time_point),string(time_labels(iTime)),text_style{:});
    hold off
end
%------------------------------------------

xlabel("$q_2$",Interpreter="latex")
ylabel("$q_1$",Interpreter="latex")

xlim([-0.05,0.05])
ylim([-0.05,0.05])

leg = legend("Reduced","Validation","Location","northeast");
leg.IconColumnWidth = leg.IconColumnWidth/3;
%------------------------------------------
main_position = ax.Position;
bottom_left = main_position(1:2).*[1.1,1.3];
phase_ax = axes(fig,"Position",[bottom_left,0.15,0.15]);
% box(phase_ax,"on")

r = orbit.xbp(:,1)';
r_dot = orbit.xbp(:,2)';
hold(phase_ax,"on")
plot(phase_ax,r,r_dot,"Color",orbit_colour)
num_time_points = size(validation_time_points,2);
for iTime = 1:num_time_points
    time_point = validation_time_points(iTime);
    plot(phase_ax,r(time_point),r_dot(time_point),"k.")
    % text(phase_ax,r(time_point),r_dot(time_point),string(iTime),"FontName", "Times New Roman","FontSize",8,"FontUnits","points")
end
hold(phase_ax,"off")

% xlabel(phase_ax,"$q_1$",Interpreter="latex")
% ylabel(phase_ax,"$\dot{q}_1$",Interpreter="latex")

xticks(phase_ax,[])
yticks(phase_ax,[])
%------------------------------------------
save_fig(fig,fig_name)