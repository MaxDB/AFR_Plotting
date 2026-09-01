clear
close all

fig_name = "frc";
fig_num = 3;
%--------
data_directory = get_project_path + "\examples\nonconservative\clamped_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

%---

switch fig_num
    case 1
        data_dir_execute(@compare_solutions,"physical amplitude","clamped_beam_13",1,"clamped_beam_0",1);
    case 2
        data_dir_execute(@compare_solutions,"physical amplitude","clamped_beam_13",1,"clamped_beam_0",1,"clamped_beam_121001",1)
    case 3
        data_dir_execute(@compare_solutions,"physical amplitude","clamped_beam_0",1,"clamped_beam_1",2,"clamped_beam_121001",1,"clamped_beam_12",2,"clamped_beam_11001",1)

end

fig = gcf;
%---
save_fig(fig,fig_name+"_"+fig_num + "_base");



