clear
close all

fig_names = "isola_frc";

%--------
data_directory = get_project_path + "\examples\nonconservative\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

%--
Dyn_Data_0 = data_dir_execute(@initalise_dynamic_data,"mass_spring_isola_0");
Dyn_Data_12 = data_dir_execute(@initalise_dynamic_data,"mass_spring_isola_12");

% data_dir_execute(@compare_solutions,"energy","mass_spring_isola_12",[1,2],"mass_spring_isola_0",[1,2])
data_dir_execute(@compare_solutions,"energy","mass_spring_isola_12",[1,2])


fig = gcf;

save_fig(fig,fig_names + "_base")