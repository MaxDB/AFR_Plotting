clear
close all

fig_name = "calibration_pre";
%--
data_directory = get_project_path + "\examples\rom_challenge";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

%--------- Software Settings ---------%
set_logging_level(3)
set_visualisation_level(1)
%-------------------------------------%


%--------- System Settings ---------%
system_name = "exhaust";
energy_limit = 1.8;
initial_modes = [1];

Calibration_Opts.calibration_scale_factor = 1.5;

Static_Opts.max_parallel_jobs = 4; %be careful!

%-----
data_dir_execute(@delete_cache,system_name,"force")
Model = data_dir_execute(@Dynamic_System,system_name,energy_limit,initial_modes,"calibration_opts",Calibration_Opts,"static_opts",Static_Opts);

%----
fig = gcf;
save_fig(fig,fig_name)