clear
close all

fig_name = "validation";
%--------
data_directory = get_project_path + "\examples\nonconservative\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
%---


%---
data_dir_execute(@compare_validation,"mass_spring_isola_1","energy",2,2);


fig = gcf;
%---
save_fig(fig,fig_name+"_base");



