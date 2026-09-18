clear
close all

fig_name = "frequency_comb";
%--------
data_directory = get_project_path + "\examples\nonconservative\mems_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Dyn_Data_16 = data_dir_execute(@initalise_dynamic_data,"mems_arch_16");
Rom_16 = Dyn_Data_16.Dynamic_Model;

Dyn_Data_1 = data_dir_execute(@initalise_dynamic_data,"mems_arch_1");
Rom_1 = Dyn_Data_1.Dynamic_Model;
%---
% Forcing

Model = Rom_16.Model;
freq_1 = sqrt(Model.reduced_eigenvalues(1));

Force_Data.type = "modal";
Force_Data.mode_number = 1;
Force_Data.amplitude = 20e3;
Force_Data.continuation_variable = "frequency";

Damping_Data.damping_type = "rayleigh";
Damping_Data.mass_factor = freq_1/500;
Damping_Data.stiffness_factor = 0;

% ---
freq_lim = [0.8,1.2];

forcing_freq = 2.7055e6;
period_range = [1000,1500];
samples_per_period = 100;
%---
Force_Data.frequency = forcing_freq;
period = 2*pi/forcing_freq;
dt = period/samples_per_period;
options = odeset(MaxStep=dt);
%---
Trajectory_Transient = data_dir_execute(@generate_trajectory,Rom_16,[0,period_range(1)]*period,"forcing",Force_Data,"damping",Damping_Data,"ode_opts",options);
ic = [Trajectory_Transient.r(:,end);Trajectory_Transient.r_dot(:,end)];
Trajectory_16 = data_dir_execute(@generate_trajectory,Rom_16,period_range*period,"forcing",Force_Data,"damping",Damping_Data,"ic",ic,"ode_opts",options);
%--
t_16 = Trajectory_16.t;
x_16 = data_dir_execute(@expand,Rom_16,Trajectory_16.r,"index",Dyn_Data_16.Additional_Output.control_dof);

[fourier_freq,P1] = fourier_transform(t_16,x_16,dt);
norm_freq = fourier_freq/forcing_freq;
[x_freq_plot_16,X_plot_16] = get_freq_index(norm_freq,P1,freq_lim);


%--
%Validation
[Validated_Trajectory_16,Validation_Rom] = data_dir_execute(@validate_trajectory,Rom_16,Trajectory_16,1:20);
tv_16 = Validated_Trajectory_16.t;
xv_16 = data_dir_execute(@expand,Validation_Rom,Validated_Trajectory_16.r,"validation_disp",Validated_Trajectory_16.h,"index",Dyn_Data_16.Additional_Output.control_dof);

[fourier_freq_v,P1_v] = fourier_transform(tv_16,xv_16,dt);
norm_freq_v = fourier_freq_v/forcing_freq;
[xv_freq_plot_16,XV_plot_16] = get_freq_index(norm_freq_v,P1_v,freq_lim);

%---
% FOM trajectory 
Sim_Opts.max_time_step = dt;
duration = period_range(2)*period;
FOM_Output.type = "disp_dof";
FOM_Output.dof = Dyn_Data_16.Additional_Output.control_dof;
FOM_Output.dof_pre_bc = Dyn_Data_16.Additional_Output.dof;

Force_Data_Fom.type = "shape";
mass = data_dir_execute(@load,Rom_1.Model.mass);
r_evec = data_dir_execute(@load,Rom_1.Model.reduced_eigenvectors);
Force_Data_Fom.shape = mass*r_evec;
Force_Data_Fom.amplitude = Force_Data.amplitude;
Force_Data_Fom.frequency = Force_Data.frequency;

% FOM_Trajectory = Model.add_full_order_trajectory(duration,"forcing",Force_Data_Fom,"damping",Damping_Data,"sim_opts",Sim_Opts,"output",FOM_Output);
% save("FOM_sim","FOM_Trajectory")
%---
fig = figure;
tiledlayout(3,2)
nexttile
plot(t_16/period,x_16)
ylabel("x")
nexttile
semilogy(x_freq_plot_16,X_plot_16)

nexttile
plot(tv_16/period,xv_16)
ylabel("xv")
nexttile
semilogy(xv_freq_plot_16,XV_plot_16)


nexttile


nexttile


%----
save_fig(fig,fig_name+"_base");


%---------------------
function [fourier_freq,P1] = fourier_transform(t,x,sample_dt)
x_spline = spline(t,x);
t_sample = t(1):sample_dt:t(end);
x_sample = ppval(x_spline,t_sample);


X = fft(x_sample);

signal_length = length(t);

fourier_freq = (2*pi/sample_dt)/signal_length*(0:floor(signal_length/2));

P2 = abs(X/signal_length);
P1 = P2(1:floor(signal_length/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
end

function [freq_plot,X_plot] = get_freq_index(norm_freq,P1,freq_lim)
freq_index = find(norm_freq >= freq_lim(1) & norm_freq <= freq_lim(2));
freq_index = [freq_index(1)-1,freq_index,freq_index(end)+1];

if freq_index(1) == 0
    freq_index(1) = [];
end

if freq_index(end) > length(norm_freq)
    freq_index(end) = [];
end
freq_plot = norm_freq(freq_index);
X_plot = P1(freq_index);
end