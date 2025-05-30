clear
error_fig_name = "two_mode_resonance_error_base";
amp_backbone_fig_name = "two_mode_resonance_amp_backbone_base";
phy_backbone_fig_name = "two_mode_resonance_phy_backbone_base";

sol_num = [1,6];
%--------
data_directory = get_project_path + "\examples\size_test";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

data_dir_execute(@set_visualisation_level,1)
error_ax = data_dir_execute(@compare_validation,"mems_arch_16","validation error",sol_num(1),1:14);
error_ax = data_dir_execute(@compare_validation,"mems_arch_16","validation error",sol_num(2),1:14,"axes",error_ax);
error_fig = gcf;

Dyn_Data = data_dir_execute(@initalise_dynamic_data,"mems_arch_16");
% Dyn_Data_1 = data_dir_execute(@Dyn_Data_1.validate_solution,1,"all");
% ax = data_dir_execute(@plot_h_predicition,Dyn_Data_1,"validation error",1,"axes",ax);

% Dyn_Data_12 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_12");
% Dyn_Data_12 = data_dir_execute(@Dyn_Data_12.validate_solution,1,"all");
% ax = data_dir_execute(@plot_h_predicition,Dyn_Data_12,"validation error",1);
Dyn_Data = data_dir_execute(@Dyn_Data.validate_solution,sol_num(1),11);
Dyn_Data = data_dir_execute(@Dyn_Data.validate_solution,sol_num(2),11);
amp_backbone_ax = data_dir_execute(@compare_solutions,"amplitude","mems_arch_16",sol_num,"validation",1);
amp_backbone_fig = gcf;

phy_backbone_ax = data_dir_execute(@compare_solutions,"physical amplitude","mems_arch_16",sol_num,"validation",1);
phy_backbone_fig = gcf;

save_fig(error_fig,error_fig_name)
save_fig(amp_backbone_fig,amp_backbone_fig_name)
save_fig(phy_backbone_fig,phy_backbone_fig_name)