clear
error_fig_name = "two_mode_validation_error_base";
energy_backbone_fig_name = "two_mode_validation_energy_backbone_base";
phy_backbone_fig_name = "two_mode_validation_phy_backbone_base";
amp_backbone_fig_name = "two_mode_validation_amp_backbone_base";

sol_num = [1,2];
validation_basis = [5,11,13];
%--------
data_directory = get_project_path + "\examples\validation\mems_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

data_dir_execute(@set_visualisation_level,1)
Dyn_Data = data_dir_execute(@initalise_dynamic_data,"mems_arch_16");

Dyn_Data = data_dir_execute(@Dyn_Data.validate_solution,sol_num(1),validation_basis);
Dyn_Data = data_dir_execute(@Dyn_Data.validate_solution,sol_num(2),validation_basis);


error_ax = data_dir_execute(@plot_h_predicition,Dyn_Data,"validation error",sol_num(1));
data_dir_execute(@plot_h_predicition,Dyn_Data,"validation error",sol_num(2),"axes",error_ax);
error_fig = gcf();

data_dir_execute(@compare_solutions,"energy",Dyn_Data,sol_num,"validation",1);
energy_fig = gcf();

data_dir_execute(@compare_solutions,"physical amplitude",Dyn_Data,sol_num,"validation",1);
phy_fig = gcf();

data_dir_execute(@compare_solutions,"amplitude",Dyn_Data,sol_num,"validation",1);
amp_fig = gcf;

save_fig(error_fig,error_fig_name)
save_fig(energy_fig,energy_backbone_fig_name)
save_fig(phy_fig,phy_backbone_fig_name)
save_fig(amp_fig,amp_backbone_fig_name)