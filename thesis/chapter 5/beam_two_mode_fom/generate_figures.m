clear
close all
%--------------------------------------------------
data_directory = get_project_path + "\examples\JH_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Static_Data = data_dir_execute(@load_static_data,"JH_beam_2d_13");
Rom = data_dir_execute(@Reduced_System,Static_Data);


%-----
%get limit contour
Energy_Poly = Rom.Potential_Polynomial;
ax_potential = data_dir_execute(@Energy_Poly.plot_polynomial,"potential",{Energy_Poly,Rom.Model.energy_limit});
ax_potential = ax_potential{1};
potential_surface = ax_potential.Children;

limit_X = potential_surface.XData(:,end)';
limit_Y = potential_surface.YData(:,end)';
limit_Z = potential_surface.ZData(:,end)';


Force_Poly = Rom.Force_Polynomial;

limit_force = Force_Poly.evaluate_polynomial([limit_X;limit_Y]);
close(gcf())

%---
%force points
radial_density = 11;

force_radius = sqrt(sum(limit_force.^2,1));
force_angle = atan2(limit_force(2,:),limit_force(1,:));

[radius_mesh,angle_mesh] = meshgrid(force_radius,force_angle);
radius_mesh = radius_mesh(1:radial_density,:);
angle_mesh = angle_mesh(:,1:radial_density);

radial_scale_factos = linspace(1,0,radial_density)';

radius_mesh = radius_mesh.*radial_scale_factos;

force_x_mesh = radius_mesh.*cos(angle_mesh');
force_y_mesh = radius_mesh.*sin(angle_mesh');

% plot(force_x_mesh',force_y_mesh')
%------
num_force_points = numel(force_x_mesh);
applied_force = [reshape(force_x_mesh,[1,num_force_points]);reshape(force_y_mesh,[1,num_force_points])];


Model = Static_Data.Model; 
Model.Static_Options.num_loadcases = 50;
Model.Static_Options.max_parallel_jobs = 43;
Closest_Point = [];
[reduced_disp,physical_disp,restoring_force] = data_dir_execute(@Model.add_point,applied_force,"none",Closest_Point);


linear_to_mesh = @(data)reshape(data,size(force_x_mesh));
Fom_Data.reduced_disp = reduced_disp;
Fom_Data.physical_disp = physical_disp;
Fom_Data.restoring_force = restoring_force;
Fom_Data.mesh_shape = size(force_x_mesh);

save("Fom_Data","Fom_Data")
