clear
close all
validation_one_name = "validation_one_base";

validation_two_name = "validation_two_base";
resonance_two_name = "resonance_two_base";


%--------
data_directory = get_project_path + "\examples\size_test";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});





data_dir_execute(@set_visualisation_level,1)
ax = data_dir_execute(@compare_validation,"mems_arch_1",["validation error"],1,1:6);
validation_one_fig = gcf();




ax = data_dir_execute(@compare_validation,"mems_arch_16",["validation error"],[1,2],1:20);
validation_two_fig = gcf();

ax = data_dir_execute(@compare_validation,"mems_arch_16",["validation error"],3,[5,11,13]);
resonance_two_fig = gcf();

% 
save_fig(validation_one_fig,validation_one_name)
save_fig(validation_two_fig,validation_two_name)
save_fig(resonance_two_fig,resonance_two_name)