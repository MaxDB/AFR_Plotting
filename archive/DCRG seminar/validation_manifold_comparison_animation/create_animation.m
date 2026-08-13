clear 
close all

rom = "mass_spring_roller_1";
frame_rate = 60;

data_directory = get_project_path + "\examples\3_dof_mass_spring";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Dyn_Data = data_dir_execute(@initalise_dynamic_data,rom);
Rom = Dyn_Data.Dynamic_Model;
Model = Dyn_Data.Dynamic_Model.Model;

fig = figure;
% fig.Position = [0,0,1920,1080];
ax = axes(fig,"Position",[0,0,1,1]);

System = draw_system(Model,ax);

%------------------------------------------
System_Ani = System.setup_animation_function(Dyn_Data,data_dir_execute);


sol_id = 3;
orbit_id = 132;
disp_scale_factor = 5;



%--
mass_colour = get_plot_colours(3);
System_Ani.set_mass_colour(mass_colour)
animation = System_Ani.animate_orbit(sol_id,orbit_id,frame_rate,"scale_factor",disp_scale_factor);
export_animation(animation,"one_rom_orbit")
%--
mass_colour = get_plot_colours(5);
System_Ani.set_mass_colour(mass_colour)
animation = System_Ani.animate_orbit(sol_id,orbit_id,frame_rate,"scale_factor",disp_scale_factor,"validation",1);
export_animation(animation,"one_rom_orbit_validated")