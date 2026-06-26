% clear
close all

m = [0.01,0.01];
k = [1e3,1e3,1e3];
beta = [1e6,-1e6];


%------------
M = diag(m);
K = [k(1)+k(2), - k(2); -k(2), k(2)+k(3)];
[evecs,evals] = eig(K,M);
natural_frequency = sqrt(diag(evals));
get_disp = @(prob_output) cellfun(@(c) c(1),prob_output(2:end,24));
get_freq = @(prob_output) 2*pi./cell2mat(prob_output(2:end,12));

% %------------------
amp = evecs(:,1)*1e-5;
freq = natural_frequency(1);
prob_output = run_free_prob(M,K,beta,amp,freq);

amp_1 = get_disp(prob_output);
freq_1 = get_freq(prob_output);
% %------------------

amp = evecs(:,2)*1e-5;
freq = natural_frequency(2);
prob_output = run_free_prob(M,K,beta,amp,freq);

amp_2 = get_disp(prob_output);
freq_2 = get_freq(prob_output);
% %------------------
mode_1 = evecs(:,1)/norm(evecs(:,1));
mode_2 = evecs(:,2)/norm(evecs(:,2));

force_amp = 1.4*(mode_1 + 0.5*mode_2);
freq_range = [270,600];
damping_const = [0.025;0.05];
rayleigh_coeffs = 2*[ones(2,1),natural_frequency.^2]\(natural_frequency.*damping_const) ;

C = rayleigh_coeffs(1)*M + rayleigh_coeffs(2)*K;
prob_output = run_forced_prob(M,C,K,beta,force_amp,freq_range);
amp_forced = get_disp(prob_output);
freq_forced = get_freq(prob_output);
%------------------

fig = figure;
ax = axes;

hold(ax,"on")
plot(ax,freq_1,amp_1)
plot(ax,freq_2,amp_2)
plot(ax,freq_forced,amp_forced)
hold(ax,"off")


save_fig(fig,"freq_amp_plot_base")


function prob_output = run_free_prob(M,K,beta,amp,freq)
nx = 100;
t0 = linspace(0,2*pi/freq,nx);
x0 = amp.*sin(freq*t0);
x_dot0 = amp.*freq*cos(freq*t0);

z0 = [x0;x_dot0];



%------

funcs = {@(z,zeta) eom(0,z,zeta,M,K,beta)};
prob = coco_prob();
cont_args = { 1, {'po.period', 'zet'}, []};

prob = coco_set(prob, 'cont', 'NAdapt', 1);
%collocation Settings
coll_args = [funcs, {t0',z0', {'zet'}, 0}];
prob = ode_isol2po(prob, '', coll_args{:});
prob = coco_set(prob, 'cont', 'ItMX',   [0,100]);  	% Number of continuation steps [backwards,forwards]
% prob = coco_set(prob, 'cont', 'h_max',  1e3);
% prob = coco_set(prob, 'cont', 'h_min',  1e-1);
% prob = coco_set(prob, 'cont', 'h0',  1e0);

file_name = "amp_dependence";
prob_output = coco(prob, file_name, [], cont_args{:});

    function y = eom(~,z,zeta,M,K,beta)
        x = z(1:2,:);
        x_dot = z(3:4,:);
        num_x = size(z,2);
        y = zeros(4,num_x);
        y(1:2,:) = x_dot;
        for iX = 1:num_x
            y(3:4,iX) = -M\(K*x(:,iX) + beta(1)*[x(1,iX).^3;0] + beta(2)*[x(1,iX)-x(2,iX);x(2,iX) - x(1,iX)].^3) - zeta(iX).*x_dot(:,iX);
        end
    end
end


function prob_output = run_forced_prob(M,C,K,beta,force_amp,freq_range)
nx = 100;





ode_fun = @(t,z,period) eom(t,z,period,M,C,K,beta,force_amp);

T0 = 2*pi/freq_range(2);
[t,z] = ode45(@(t,z)ode_fun(t,z,T0),[0,1000*T0],zeros(1,4));

[t0,z0] =  ode45(@(t,z)ode_fun(t,z,T0),[0,T0],z(end,:));


% plot(t(1:200),z(1:200,1))
%------

funcs = {ode_fun};
prob = coco_prob();
prob = coco_set(prob, 'ode', 'autonomous', false);
period_range = sort(2*pi./freq_range);
cont_args = { 1, {'po.period', 'T'}, period_range.*[0.9,1]};

prob = coco_set(prob, 'cont', 'NAdapt', 1);
%collocation Settings
coll_args = [funcs, {t0,z0, {'T'}, T0}];

prob = ode_isol2po(prob, '', coll_args{:});
prob = coco_set(prob, 'cont', 'ItMX',   [500,500]);  	% Number of continuation steps [backwards,forwards]
prob = coco_set(prob, 'cont', 'h_max',  1e3);
prob = coco_set(prob, 'cont', 'h_min',  1e-5);
prob = coco_set(prob, 'cont', 'h0',  1e0);

prob = coco_set(prob, 'coll', 'NTST', 40);  % [10] %initial number of discretisation intervals
prob = coco_set(prob, 'coll', 'NCOL',   8);            % [4] %degree of interpolating polynomial

file_name = "amp_dependence";
prob_output = coco(prob, file_name, [], cont_args{:});

    function y = eom(t,z,period,M,C,K,beta,force_amp)
        x = z(1:2,:);
        x_dot = z(3:4,:);
        num_x = size(z,2);

        freq = 2*pi./period;
        y = zeros(4,num_x);
        y(1:2,:) = x_dot;
        for iX = 1:num_x
            f_nx = beta(1)*[x(1,iX).^3;0] + beta(2)*[x(1,iX)-x(2,iX);x(2,iX) - x(1,iX)].^3;
            damping = C*x_dot(:,iX);
            F = force_amp*sin(freq(iX)*t(iX));
            y(3:4,iX) = -M\(K*x(:,iX) + f_nx + damping + F);
        end
    end
end