clear
error_fig_name = "validated_backbone";

%--------
data_directory = get_project_path + "\examples\rom_challenge\";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Validation_Opts.legacy_h_prediction = 1;
Validation_Opts.get_stability = 0;
Validation_Opts.verification = "local";

data_dir_execute(@set_visualisation_level,1)
validation_ax_1 = data_dir_execute(@compare_validation,"exhaust_1","physical amplitude",2,"all","opts",Validation_Opts);
validation_ax_17 = data_dir_execute(@compare_validation,"exhaust_17","physical amplitude",1,"all","opts",Validation_Opts);
validation_ax_157 = data_dir_execute(@compare_validation,"exhaust_157","physical amplitude",[1,2],"all","opts",Validation_Opts);
validation_ax_1567 = data_dir_execute(@compare_validation,"exhaust_1567","physical amplitude",[1,2],"all","opts",Validation_Opts);

fig_1 = validation_ax_1.Parent.Parent;
fig_17 = validation_ax_17.Parent.Parent;
fig_157 = validation_ax_157.Parent.Parent;
fig_1567 = validation_ax_1567.Parent.Parent;

save_fig(fig_1,error_fig_name+"_1_base")
save_fig(fig_17,error_fig_name+"_17_base")
save_fig(fig_157,error_fig_name+"_157_base")
save_fig(fig_1567,error_fig_name+"_1567_base")

%----
Dyn_Data = data_dir_execute(@initalise_dynamic_data,"exhaust_1");
Dyn_Data = data_dir_execute(@validate_solution,Dyn_Data,1,1:18,"opts",Validation_Opts);
data_dir_execute(@compare_solutions,"physical amplitude",Dyn_Data,1,"validation",1)
fig = gcf;

save_fig(fig,"validated_backbone_1_all_base")