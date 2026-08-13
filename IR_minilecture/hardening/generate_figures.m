clear
close all

m = 1;
k = 1;
c = 2*sqrt(k/m)*0.01;

freq0 = 0.95;

get_disp = @(prob_output) cell2mat(prob_output(2:end,23));
get_freq = @(prob_output) 2*pi./cell2mat(prob_output(2:end,12));




beta = 0;
amp = 0.01;
prob_output = run_coco_prob(m,c,k,beta,freq0,amp);
max_disp_linear_low = get_disp(prob_output);
freq_linear_low = get_freq(prob_output);

amp = 0.015;
prob_output = run_coco_prob(m,c,k,beta,freq0,amp);
max_disp_linear_high = get_disp(prob_output);
freq_linear_high = get_freq(prob_output);


beta = 1;
amp = 0.01;
prob_output = run_coco_prob(m,c,k,beta,freq0,amp);
max_disp_hard_low = get_disp(prob_output);
freq_hard_low = get_freq(prob_output);

amp = 0.02;
prob_output = run_coco_prob(m,c,k,beta,freq0,amp);
max_disp_hard_high = get_disp(prob_output);
freq_hard_high = get_freq(prob_output);

fig = figure;
ax = axes;

hold(ax,"on")
plot(freq_linear_low,max_disp_linear_low)
plot(freq_linear_high,max_disp_linear_high)
plot(freq_hard_low,max_disp_hard_low)
plot(freq_hard_high,max_disp_hard_high)
hold(ax,"off")



save_fig(fig,"amp_dependence_base")


function prob_output = run_coco_prob(m,c,k,beta,p0,amp)

T0 = 2*pi/p0;


get_y = @(t,x) eom(t,x,T0,c,m,k,beta,amp);

[t,z] = ode45(get_y,[0,500*T0],zeros(2,1));

t = t';
z = z';

per_index = t>(t(end) - T0*1.1);
t_per = t(per_index);
z_per = z(:,per_index);
found_start = false;
sin_value = abs(sin(p0*t_per));
while ~found_start
    [~,period_start] = min(sin_value);
    if cos(p0*t_per(period_start)) > 0.9
        found_start = true;
    else
        sin_value(period_start) = inf;
    end
end

z_0 = z_per(:,period_start);
[t0,z0] = ode45(get_y,[0,T0],z_0);

t0(end) = [];
z0(end,:) = [];


%------

funcs = {@(t,z,period) eom(t,z,period,c,m,k,beta,amp)};
prob = coco_prob();
cont_args = { 1, {'po.period', 'T'}, [5,8]};

prob = coco_set(prob, 'cont', 'NAdapt', 1);
prob = coco_set(prob, 'ode', 'autonomous', false);
%collocation Settings
coll_args = [funcs, {t0,z0, {'T'}, T0}];
prob = ode_isol2po(prob, '', coll_args{:});
prob = coco_set(prob, 'cont', 'ItMX',   [100,100]);  	% Number of continuation steps [backwards,forwards]
prob = coco_set(prob, 'cont', 'h_max',  1e0);
prob = coco_set(prob, 'cont', 'h_min',  1e-3);
prob = coco_set(prob, 'cont', 'h0',  1e0);

% Constrain period
[data,uidx] = coco_get_func_data(prob, 'po.orb.coll', 'data', 'uidx');
maps = data.coll_seg.maps;
prob = coco_add_glue(prob, 'glue', uidx(maps.T_idx), uidx(maps.p_idx(1)));

file_name = "amp_dependence";
prob_output = coco(prob, file_name, [], cont_args{:});



    function y = eom(t,z,period,c,m,k,beta,amp)
        x = z(1,:);
        x_dot = z(2,:);
        num_x = size(z,2);
        y = zeros(2,num_x);
        y(1,:) = x_dot;
        y(2,:) = -k/m*x - beta/m*x.^3 - c*x_dot + amp*sin(2*pi.*t./period);
    end
end