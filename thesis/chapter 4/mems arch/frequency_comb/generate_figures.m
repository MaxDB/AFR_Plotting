clear
close all
fig_name = "frequency_comb_base";

%--------------------------------------------------
data_directory = get_project_path + "\examples\nonconservative\mems_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
Dyn_Data = data_dir_execute(@initalise_dynamic_data,"mems_arch_16");
%---


fig = figure;
tiles = tiledlayout(2,2);

%---
freq_lim = [0.8,1.2];
%---

% forcing_freq = 2.705470e6;
forcing_freq = 2.7055e6;
[t,x_centre] = get_trajectory(data_dir_execute,forcing_freq,[1000,3000],500);


period = 2*pi/forcing_freq;
ax = nexttile(tiles);
plot(ax,t/period,x_centre)

[fourier_freq,P1] = fourier_transform(t,x_centre);
norm_freq = fourier_freq/forcing_freq;
[freq_plot,X_plot] = get_freq_index(norm_freq,P1,freq_lim);


ax = nexttile(tiles);
semilogy(ax,freq_plot,X_plot)
xlim(ax,freq_lim)
%---
%---
forcing_freq = 2.7e6;
% forcing_freq = 2.7043e6;
[t,x_centre] = get_trajectory(data_dir_execute,forcing_freq,[1000,11000],500);

period = 2*pi/forcing_freq;
ax = nexttile(tiles);
plot(ax,t/period,x_centre)

[fourier_freq,P1] = fourier_transform(t,x_centre);
norm_freq = fourier_freq/forcing_freq;
[freq_plot,X_plot] = get_freq_index(norm_freq,P1,freq_lim);


ax = nexttile(tiles);
semilogy(ax,freq_plot,X_plot)
xlim(ax,freq_lim)


%---------
save_fig(fig,fig_name)


function [t,x_centre] = get_trajectory(data_dir_execute,frequency,period_span,num_samples)
Dyn_Data = data_dir_execute(@initalise_dynamic_data,"mems_arch_16");

Model = Dyn_Data.Dynamic_Model.Model;
freq_1 = sqrt(Model.reduced_eigenvalues(1));

Force_Data.type = "modal";
Force_Data.mode_number = 1;
Force_Data.amplitude = 20e3;
Force_Data.continuation_variable = "frequency";

Damping_Data.damping_type = "rayleigh";
Damping_Data.mass_factor = freq_1/500;
Damping_Data.stiffness_factor = 0;
%----

Force_Data.frequency = frequency;

eom = data_dir_execute(@get_equation_of_motion,Dyn_Data.Dynamic_Model,"damping",Damping_Data,"forcing",Force_Data);

period = 2*pi/Force_Data.frequency;
[t,y] = ode45(eom,[0,period_span(1)*period],zeros(4,1));

sample_dt = period/num_samples;
t_sample = t(end):sample_dt:(period_span(2)*period);
if mod(length(t_sample),2) == 1
    t_sample(end) = [];
end
[t,y] = data_dir_execute(@ode45,eom,t_sample,y(end,:));
t = t';
y = y';

x_centre = data_dir_execute(@expand,Dyn_Data.Dynamic_Model,y(1:2,:),"index",Dyn_Data.Additional_Output.control_dof);
end




function [fourier_freq,P1] = fourier_transform(t,x)
X = fft(x);

signal_length = length(t);
sample_dt = diff(t(1:2));

fourier_freq = (2*pi/sample_dt)/signal_length*(0:signal_length/2);

P2 = abs(X/signal_length);
P1 = P2(1:signal_length/2+1);
P1(2:end-1) = 2*P1(2:end-1);
end

function [freq_plot,X_plot] = get_freq_index(norm_freq,P1,freq_lim)
freq_index = find(norm_freq > freq_lim(1) & norm_freq < freq_lim(2));
freq_index = [freq_index(1)-1,freq_index,freq_index(end)+1];

freq_plot = norm_freq(freq_index);
X_plot = P1(freq_index);
end