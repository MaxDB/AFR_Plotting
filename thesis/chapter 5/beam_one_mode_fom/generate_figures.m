clear
close all
%--------- Software Settings ---------%
set_logging_level(3)
set_visualisation_level(1)
%-------------------------------------%

%--------- System Settings ---------%
system_name = "JH_beam_2d_comp";
energy_limit = 0.015; %0.01 J
initial_modes = [1];
%-----------------------------------%

%--------- Static Solver Settings ---------%
Static_Opts.max_parallel_jobs =  4; %be careful!
Static_Opts.num_loadcases = 50;
%------------------------------------------%



%--------- Static Verification Settings ---------%
Verification_Opts.maximum_iterations = 0;
% [1e-3] works for three modes and 5e-3 works for two modes]
%----------------------------------------------%

data_directory = get_project_path + "\examples\JH_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Model = data_dir_execute(@Dynamic_System,system_name,energy_limit,initial_modes,"static_opts",Static_Opts);

Static_Data = data_dir_execute(@Static_Dataset,Model,"verification_opts",Verification_Opts);
data_dir_execute(@Static_Data.save_data);

