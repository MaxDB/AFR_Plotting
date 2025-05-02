clear 
close all

rom_1 = "mass_spring_roller_1";
rom_12 = "mass_spring_roller_12";


data_directory = get_project_path + "\examples\3_dof_mass_spring";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Dyn_Data_1 = data_dir_execute(@initalise_dynamic_data,rom_1);
Dyn_Data_12 = data_dir_execute(@initalise_dynamic_data,rom_12);
Rom = Dyn_Data_12.Dynamic_Model;
Model = Dyn_Data_12.Dynamic_Model.Model;

fig = figure;
ax = axes(fig);

System = draw_system(Model,ax);

%------------------------------------------
System_1 = System.setup_animation_function(Dyn_Data_1,data_dir_execute);
System_12 = System.setup_animation_function(Dyn_Data_12,data_dir_execute);


sol_id_12 = 1;
orbit_id_12 = 526;
System_12.animate_orbit(sol_id_12,orbit_id_12);

sol_id_1 = 1;
orbit_id_1 = 298;
System_1.animate_orbit(sol_id_1,orbit_id_1);


% data_dir_execute(@plot_orbit,Dyn_Data_1,"displacement",sol_id_1,orbit_id_1);
% data_dir_execute(@plot_orbit,Dyn_Data_12,"displacement",sol_id_12,orbit_id_12);


% data_dir_execute(@compare_solutions,"amplitude",Dyn_Data_1,1);
% data_dir_execute(@compare_solutions,"amplitude",Dyn_Data_12,1);