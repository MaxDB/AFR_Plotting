clear
fig_name = "two_mode_validation_error_base";

sol_num = [1,6];
%--------
data_directory = get_project_path + "\examples\size_test";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

data_dir_execute(@set_visualisation_level,1)
ax = data_dir_execute(@compare_validation,"mems_arch_16","validation error",sol_num(1),1:10);
ax = data_dir_execute(@compare_validation,"mems_arch_16","validation error",sol_num(2),1:10,"axes",ax);
fig = gcf;

% Dyn_Data_1 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_1");
% Dyn_Data_1 = data_dir_execute(@Dyn_Data_1.validate_solution,1,"all");
% ax = data_dir_execute(@plot_h_predicition,Dyn_Data_1,"validation error",1,"axes",ax);

% Dyn_Data_12 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_12");
% Dyn_Data_12 = data_dir_execute(@Dyn_Data_12.validate_solution,1,"all");
% ax = data_dir_execute(@plot_h_predicition,Dyn_Data_12,"validation error",1);


save_fig(fig,fig_name)