clear
error_fig_name = "resonance_error_base";
amp_backbone_fig_name = "resonance_amp_backbone_base";
energy_backbone_fig_name = "resonance_energy_backbone_base";

sol_num = 2;
%--------
data_directory = get_project_path + "\examples\validation\clamped_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

data_dir_execute(@set_visualisation_level,1)
error_ax = data_dir_execute(@compare_validation,"clamped_beam_1","validation error",sol_num,[3,6]);
error_fig = gcf;

Dyn_Data = data_dir_execute(@initalise_dynamic_data,"clamped_beam_1");
% Dyn_Data_1 = data_dir_execute(@Dyn_Data_1.validate_solution,1,"all");
% ax = data_dir_execute(@plot_h_predicition,Dyn_Data_1,"validation error",1,"axes",ax);

% Dyn_Data_12 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_12");
% Dyn_Data_12 = data_dir_execute(@Dyn_Data_12.validate_solution,1,"all");
% ax = data_dir_execute(@plot_h_predicition,Dyn_Data_12,"validation error",1);
Dyn_Data = data_dir_execute(@Dyn_Data.validate_solution,sol_num,3);
amp_backbone_ax = data_dir_execute(@compare_solutions,"amplitude","clamped_beam_1",sol_num,"validation",1);
amp_backbone_fig = gcf;

energy_backbone_ax = data_dir_execute(@compare_solutions,"energy","clamped_beam_1",sol_num,"validation",1);
energy_backbone_fig = gcf;

save_fig(error_fig,error_fig_name)
save_fig(amp_backbone_fig,amp_backbone_fig_name)
save_fig(energy_backbone_fig,energy_backbone_fig_name)