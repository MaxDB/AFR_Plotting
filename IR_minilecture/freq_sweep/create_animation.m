clear 
close all

rom = "mass_spring_roller_12";
frame_rate = 30;

data_directory = get_project_path + "\examples\validation\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
%---
Model = data_dir_execute(@load_analytic_system,"mass_spring_roller");

fig = figure;
% fig.Position = [0,0,1920,1080];
ax = axes(fig,"Position",[0,0,1,1]);

System = draw_system(Model,ax);
load("data.mat","Plot_Data")
%------------------------------------------
System_Ani = System.setup_animation_function(Plot_Data,data_dir_execute);


disp_scale_factors = [3,3,3];
mass_colours = get_plot_colours([4,5,6]);
%--



%--
num_sols = 3;
for iSol = 1:num_sols
    System_Ani.set_mass_colour(mass_colours(iSol,:))
    animation = System_Ani.animate_orbit(0,iSol,frame_rate,"scale_factor",disp_scale_factors(iSol),"total_time",2);
    % export_animation(animation,"videos/mass_spring_fom_" + iSol)
     export_animation(animation,"videos/mass_spring_small_force_" + iSol)
end
