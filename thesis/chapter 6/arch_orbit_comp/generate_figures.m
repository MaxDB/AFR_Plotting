clear

system_name = "mems_arch_1";


%--------
data_directory = get_project_path + "\examples\validation\mems_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

data_dir_execute(@set_visualisation_level,1)
Dyn_Data = data_dir_execute(@initalise_dynamic_data,system_name);
Dyn_Data = data_dir_execute(@Dyn_Data.validate_solution,1,6);
% error_ax = data_dir_execute(@compare_validation,"mems_arch_16","validation error",sol_num,[5,11,13]);

