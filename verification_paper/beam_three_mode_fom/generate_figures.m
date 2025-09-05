clear
close all
%--------------------------------------------------
data_directory = get_project_path + "\examples\JH_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Static_Data = data_dir_execute(@load_static_data,"JH_beam_2d_135");
Rom = data_dir_execute(@Reduced_System,Static_Data);


%-----
%get limit contour


Energy_Poly = Rom.Potential_Polynomial;
input_limits = Energy_Poly.input_limit;

point_resolution = 29;
r1 = linspace(input_limits(1,1),input_limits(1,2),point_resolution);
r2 = linspace(input_limits(2,1),input_limits(2,2),point_resolution);
r3 = linspace(input_limits(3,1),input_limits(3,2),point_resolution);

[r1_mesh,r2_mesh,r3_mesh] = meshgrid(r1,r2,r3);

r_vec = [reshape(r1_mesh,[1,point_resolution^3]);reshape(r2_mesh,[1,point_resolution^3]);reshape(r3_mesh,[1,point_resolution^3])];
energy_vec = Energy_Poly.evaluate_polynomial(r_vec);

removal_index = energy_vec > Rom.Model.energy_limit;
r_vec(:,removal_index) = [];
energy_vec(:,removal_index) = [];

force_vec = Rom.Force_Polynomial.evaluate_polynomial(r_vec);

%
applied_force = force_vec;


Model = Static_Data.Model; 
Model.Static_Options.num_loadcases = 50;
Model.Static_Options.max_parallel_jobs = 4;
Closest_Point = [];
[reduced_disp,physical_disp,restoring_force] = data_dir_execute(@Model.add_point,applied_force,"none",Closest_Point);


linear_to_mesh = @(data)reshape(data,size(force_x_mesh));
Fom_Data.reduced_disp = reduced_disp;
Fom_Data.physical_disp = physical_disp;
Fom_Data.restoring_force = restoring_force;
Fom_Data.mesh_shape = size(force_x_mesh);

save("Fom_Data","Fom_Data")
