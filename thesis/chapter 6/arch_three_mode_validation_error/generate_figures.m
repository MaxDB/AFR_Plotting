clear
error_fig_name = "three_mode_validation_error_base";

sol_num = [1,2,3];
%--------
data_directory = get_project_path + "\examples\validation\mems_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

data_dir_execute(@set_visualisation_level,1)
error_ax = data_dir_execute(@compare_validation,"mems_arch_1611","validation error",sol_num,"all");
% error_ax = data_dir_execute(@compare_validation,"mems_arch_16","validation error",sol_num(2),"all","axes",error_ax);
error_fig = gcf;


save_fig(error_fig,error_fig_name)
