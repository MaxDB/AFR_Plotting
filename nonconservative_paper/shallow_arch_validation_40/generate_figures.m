clear
close all

fig_name = "validation_40_base";

%--------
data_directory = get_project_path + "\examples\nonconservative\shallow_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

%--
Dyn_Data_1 = data_dir_execute(@initalise_dynamic_data,"shallow_arch_1");

ax = data_dir_execute(@compare_validation,"shallow_arch_1","validation error",3,1:10);
ax.Title = [];
%---
Model = Dyn_Data_1.Dynamic_Model.Model;
freq_1 = sqrt(Model.reduced_eigenvalues(1));
ax = scale_axis(ax,1,1/freq_1);

xlabel(ax,"$\Omega/\omega_1$","Interpreter","latex")
%---
fig = ax.Parent;
save_fig(fig,fig_name)



