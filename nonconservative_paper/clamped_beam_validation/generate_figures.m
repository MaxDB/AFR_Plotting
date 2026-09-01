clear
close all

fig_name = "validation";
fig_num = 2;
%--------
data_directory = get_project_path + "\examples\nonconservative\clamped_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
%---


%---
Force_Data.type = "point";
Force_Data.dof = 248;




switch fig_num
    case 1
        Dyn_Data_1 = data_dir_execute(@initalise_dynamic_data,"clamped_beam_1");
        Dyn_Data_1 = data_dir_execute(@add_nc_validation_shape,Dyn_Data_1,Force_Data);
        data_dir_execute(@compare_validation,"clamped_beam_1","physical amplitude",2,[2,1001]);
    case 2
        Dyn_Data_12 = data_dir_execute(@initalise_dynamic_data,"clamped_beam_12");
        Dyn_Data_12 = data_dir_execute(@add_nc_validation_shape,Dyn_Data_12,Force_Data);
        data_dir_execute(@compare_validation,"clamped_beam_12","physical amplitude",2,1001);
   
    case 3
end

fig = gcf;
%---
save_fig(fig,fig_name+"_"+fig_num + "_base");



