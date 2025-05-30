clear 
close all

rom = "mass_spring_roller_12";
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


sol_ids = [1,1,1];
orbit_ids = [10,66,90];
disp_scale_factors = [10,2,2];
speed_scale_factors = [1,1,1];
mass_colours = get_plot_colours([4,5,6]);
%--
num_sols = length(sol_ids);
for iSol = 1:num_sols
    System_Ani.set_mass_colour(mass_colours(iSol,:))
    animation = System_Ani.animate_orbit(sol_ids(iSol),orbit_ids(iSol),disp_scale_factors(iSol),frame_rate);
    export_animation(animation,"mass_spring_fom_" + iSol)
end
