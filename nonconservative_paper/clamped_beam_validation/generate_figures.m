clear
close all

fig_name = "validation";
fig_num = 3;
%--------
data_directory = get_project_path + "\examples\nonconservative\clamped_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
%---


%---
Force_Data.type = "point";
Force_Data.dof = 122;




switch fig_num
    case 1
        Dyn_Data_1 = data_dir_execute(@initalise_dynamic_data,"clamped_beam_1");
        data_dir_execute(@compare_validation,"clamped_beam_1","physical amplitude",2,[2,3,1001]);
    case 2
        Dyn_Data_12 = data_dir_execute(@initalise_dynamic_data,"clamped_beam_11001");
        data_dir_execute(@compare_validation,"clamped_beam_11001","physical amplitude",1,[2,3]);
   
    case 3
        Dyn_Data_121001 = data_dir_execute(@initalise_dynamic_data,"clamped_beam_121001");
        data_dir_execute(@compare_validation,"clamped_beam_121001","validation error",1,1:10);
    case 4
        Dyn_Data_1 = data_dir_execute(@initalise_dynamic_data,"clamped_beam_1");
        data_dir_execute(@compare_validation,"clamped_beam_1","physical amplitude",3,[2,3]);
end

fig = gcf;
%---
save_fig(fig,fig_name+"_"+fig_num + "_base");



