clear
close all

%----
data_directory = get_project_path + "\examples\rom_challenge";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Static_Data = data_dir_execute(@load_static_data,"exhaust_157");

global_verificaiton = size(Static_Data,2) == 885;

if global_verificaiton
    fig_name = "static_global";
    loadcase_indicies = [1,54;55,133;134,485;486,749;750,885];
else
    fig_name = "static_local";
    loadcase_indicies = [1,54;55,133;134,167;168,196;197,197;198,270];
end

r_disp = Static_Data.get_dataset_values("reduced_displacement");

%---
fig = figure;
ax = axes;
hold(ax,"on")
num_steps = size(loadcase_indicies,1);
for iStep = 1:num_steps
    step_index = loadcase_indicies(iStep,1):loadcase_indicies(iStep,2);
    step_data = r_disp(:,step_index);
    plot3(step_data(1,:),step_data(2,:),step_data(3,:),"x","Tag","step: " + iStep);
end
hold(ax,"off")


%------------------------------------------
save_fig(fig,fig_name)

