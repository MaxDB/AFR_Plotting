clear
% close all

data_directory = get_project_path + "\examples\validation\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
%---
Model = data_dir_execute(@load_analytic_system,"mass_spring_roller");
damping_ratio = 0.01;
natural_freq_1 = sqrt(Model.eigenvalues(1));
natural_freq_2 = sqrt(Model.eigenvalues(2));
Model.linear_damping = 2*natural_freq_1*damping_ratio*Model.linear_mass;

frequencies(1) =natural_freq_1/2;
frequencies(2) =1.2*natural_freq_1;
frequencies(3) = natural_freq_2/3*1.0185;


ic = @(amp) set_ic_func(amp,5);

% amp = 0.015;
amp = 0.02;

force_amp = amp*[0;1;0];

num_freqs = length(frequencies);
figure
tiledlayout("vertical")


for iFreq = 1:num_freqs
    freq = frequencies(iFreq);

    Plot_Data(iFreq).frequency = freq;
    Plot_Data(iFreq).amp = amp;



    Model.external_force = @(t)force_amp*sin(freq*t);
    x_ddot_initial =@(t,x) get_x_ddot(t,x,Model);
    z_dot_initial = @(t,z) eom(t,z,x_ddot_initial);


    period = 2*pi/freq;
    [t,z] = ode45(z_dot_initial,[0,1000*period],ic(0));
    t = t';
    z = z';

    per_index = t>(t(end) - period*1.1);
    t_per = t(per_index);
    z_per = z(:,per_index);
    found_start = false;
    sin_value = abs(sin(freq*t_per));
    while ~found_start
    [~,period_start] = min(sin_value);
    if cos(freq*t_per(period_start)) > 0.9
        found_start = true;
    else
        sin_value(period_start) = inf;
    end
    end
    
    z_0 = z_per(:,period_start);
    [t,z] = ode45(z_dot_initial,[0,period],z_0);
    
    t(end) = [];
    z(end,:) = [];

    Plot_Data(iFreq).t = t;
    Plot_Data(iFreq).z = z;
    nexttile
    plot(t,z(:,1:3))
    

    max_energy = get_energy(Model,z);
    Plot_Data(iFreq).energy = max_energy;
end


save("data","Plot_Data")
%---
% period = 2*pi/natural_freq;
% freq_time = 10*period;
% num_intervals = 500;
% freq_range = [1,2.5];
% 
% 
% t_max = num_intervals*freq_time;
% freq = @(t) freq_range(1) + (freq_range(2)-freq_range(1))*(floor(t/freq_time))/(num_intervals-1);
% force_amp = 0.005*[0;1;0];
% 
% %---
% Model.external_force = @(t)force_amp*sin(freq(0)*t);
% x_ddot_initial =@(t,x) get_x_ddot(t,x,Model);
% z_dot_initial = @(t,z) eom(t,z,x_ddot_initial);
% 
% Model.external_force = @(t)force_amp.*sin(freq(t).*t);
% x_ddot =@(t,x) get_x_ddot(t,x,Model);
% z_dot = @(t,z) eom(t,z,x_ddot);
% %---
% 
% [t_initial,z_initial] = ode45(z_dot_initial,[0,1000],zeros(6,1));
% z_initial = z_initial';
% t_0 = t_initial(end);
% period = 2*pi/freq_range(1);
% period_index = t_initial> t_initial(end)-period;
% period_index(find(period_index,1)-1) = true;
% t_per = t_initial(period_index);
% z_per = z_initial(:,period_index);
% t_norm = t_per/period;
% t_diff = t_norm - round(t_norm);
% [~,period_start] = min(abs(t_diff));
% 
% z_0 = z_per(:,period_start);
% z_0 = zeros(6,1);
% 
% [t,z] = ode45(z_dot,[0,t_max],z_0);
% t = t';
% z = z';
% frequency = freq(t);
% %---
% figure
% hold("on")
% for iDof = 1:3
%     plot(frequency,z(iDof,:))
% end
% hold("off")
% box on
% xlabel("frequency (rad/s)")
% ylabel("x (m)")
% legend("x_1","x_2","x_3")

%---











%------------------------------------------
function x_ddot = get_x_ddot(t,z,Model)
num_dof = 3;
num_t_points = size(z,2);
x_ddot = zeros(num_dof,num_t_points);


disp_span = 1:num_dof;
vel_span = disp_span + num_dof;
for iTime = 1:num_t_points
    x_i = z(disp_span,iTime);
    x_dot_i = z(vel_span,iTime);

    restoring_force = Model.nonlinear_restoring_force(x_i) + Model.linear_stiffness*x_i;
    damping_force = Model.linear_damping*x_dot_i;
    applied_force = Model.external_force(t(iTime));
    x_ddot(:,iTime) = -Model.linear_mass\(restoring_force + damping_force - applied_force);
end

end

function z_dot = eom(t,z,x_ddot)
num_dof = 3;
disp_span = 1:num_dof;
vel_span = disp_span + num_dof;

x_dot = z(vel_span,:);

z_dot = [x_dot;x_ddot(t,z)];


end

%------
function ic = set_ic_func(amp,index)
ic = zeros(6,1);
ic(index) = amp;
end


function max_energy = get_energy(Model,z)
z = z';
mass = Model.linear_mass;
num_points = size(z,2);

num_dofs = size(mass,1);
disp_span = 1:num_dofs;
vel_span = disp_span + num_dofs;

kinetic_energy = zeros(1,num_points);
potential_energy = zeros(1,num_points);

for iTime = 1:num_points
    x = z(disp_span,iTime);
    v = z(vel_span,iTime);

    kinetic_energy(iTime) = 0.5*v'*mass*v;
    potential_energy(iTime) = Model.potential_energy(x);
end

energy = kinetic_energy + potential_energy;
max_energy = max(energy);
end