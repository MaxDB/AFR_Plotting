clear
close all

fig_name = "validation";
%--------
data_directory = get_project_path + "\examples\nonconservative\mems_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
%---


%---

Dyn_Data_16 = data_dir_execute(@initalise_dynamic_data,"mems_arch_16");
Dyn_Data_16 = data_dir_execute(@validate_solution,Dyn_Data_16,6,11);
Dyn_Data_16 = data_dir_execute(@validate_solution,Dyn_Data_16,7,11);

ax = data_dir_execute(@compare_solutions,"energy","mems_arch_16",1:7);
data_dir_execute(@plot_h_predicition,"mems_arch_16","energy",6,"axes",ax,"backbone",0);
data_dir_execute(@plot_h_predicition,"mems_arch_16","energy",7,"axes",ax,"backbone",0);

fig = gcf;
%---
save_fig(fig,fig_name+"_base");



