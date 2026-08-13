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
% fig.Position = [0,0,1920,1080];
ax = axes(fig,"Position",[0,0,1,1]);

System = draw_system(Model,ax);

%------------------------------------------
System_1 = System.setup_animation_function(Dyn_Data_1,data_dir_execute);
System_12 = System.setup_animation_function(Dyn_Data_12,data_dir_execute);


sol_id = 1;
%--
orbit_id = 10;
disp_scale_factor = 10;

animation = System_12.animate_orbit(sol_id,orbit_id,disp_scale_factor);
export_animation(animation)
play_animation(animation,100)
%--

%--
orbit_id = 66;
disp_scale_factor = 2;

animation = System_12.animate_orbit(sol_id,orbit_id,disp_scale_factor);
export_animation(animation)
play_animation(animation,100)
%--

%--
orbit_id = 90;
disp_scale_factor = 2;

animation = System_12.animate_orbit(sol_id,orbit_id,disp_scale_factor);
export_animation(animation)
%--



% data_dir_execute(@plot_orbit,Dyn_Data_1,"displacement",sol_id_1,orbit_id_1);
% data_dir_execute(@plot_orbit,Dyn_Data_12,"displacement",sol_id_12,orbit_id_12);


% data_dir_execute(@compare_solutions,"amplitude",Dyn_Data_1,1);
% data_dir_execute(@compare_solutions,"amplitude",Dyn_Data_12,1);
