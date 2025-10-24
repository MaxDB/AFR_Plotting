clear
close all


load("Fom_Data.mat","Fom_Data")
centre_node = 20; %accounting for removed BCs


%--------------------------------------------------
data_directory = get_project_path + "\examples\JH_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});


Static_Data = data_dir_execute(@load_static_data,"JH_beam_2d_135");
Rom = data_dir_execute(@Reduced_System,Static_Data);

%-----
f_rom = Rom.Force_Polynomial.evaluate_polynomial(Fom_Data.reduced_disp);


coeff_determination_f1 = get_coeff_determination(Fom_Data.restoring_force(1,:),f_rom(1,:));
coeff_determination_f2 = get_coeff_determination(Fom_Data.restoring_force(2,:),f_rom(2,:));
coeff_determination_f3 = get_coeff_determination(Fom_Data.restoring_force(3,:),f_rom(3,:));
%--
centre_dof = (centre_node-1)*3 + 2;
centre_rom = Rom.Physical_Displacement_Polynomial.evaluate_polynomial(Fom_Data.reduced_disp,centre_dof);

coeff_determination_disp = get_coeff_determination(Fom_Data.physical_disp(centre_dof,:),centre_rom);



function coeff_determination = get_coeff_determination(y_observed,y_predicted)   
ss_res = sum((y_observed-y_predicted).^2);

y_observed_mean = mean(y_observed);
ss_tot = sum((y_observed-y_observed_mean).^2);

coeff_determination = 1- ss_res/ss_tot;
end


