clear
close all
fig_name = "validation_error_base";

%--------
data_directory = get_project_path + "\examples\validation\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

ax = data_dir_execute(@compare_validation,"mass_spring_roller_1","validation error",1,[2,3]);
fig = gcf;

% Dyn_Data_1 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_1");
% Dyn_Data_1 = data_dir_execute(@Dyn_Data_1.validate_solution,1,"all");
% ax = data_dir_execute(@plot_h_predicition,Dyn_Data_1,"validation error",1,"axes",ax);

% Dyn_Data_12 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_12");
% Dyn_Data_12 = data_dir_execute(@Dyn_Data_12.validate_solution,1,"all");
% ax = data_dir_execute(@plot_h_predicition,Dyn_Data_12,"validation error",1);


save_fig(fig,fig_name)