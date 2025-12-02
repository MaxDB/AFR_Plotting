clear
error_fig_name = "validation_error_base";
amp_backbone_fig_name = "amp_backbone_base";
phy_amp_backbone_fig_name = "phy_amp_backbone_base";


sol_num = 1;
%--------
data_directory = get_project_path + "\examples\validation\mems_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

data_dir_execute(@set_visualisation_level,1)
ax = data_dir_execute(@compare_validation,"mems_arch_1","validation error",sol_num,"all");
error_fig = gcf;

Dyn_Data = data_dir_execute(@initalise_dynamic_data,"mems_arch_1");
Dyn_Data = data_dir_execute(@Dyn_Data.validate_solution,sol_num,6);
amp_backbone_ax = data_dir_execute(@compare_solutions,"amplitude","mems_arch_1",sol_num,"validation",1);
amp_backbone_fig = gcf;

phy_amp_backbone_ax = data_dir_execute(@compare_solutions,"physical amplitude","mems_arch_1",sol_num,"validation",1);
phy_amp_backbone_fig = gcf;

save_fig(error_fig,error_fig_name)
save_fig(amp_backbone_fig,amp_backbone_fig_name)
save_fig(phy_amp_backbone_fig,phy_amp_backbone_fig_name)