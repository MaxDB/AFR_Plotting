clear
close all

m = 1;
k = 1;


get_disp = @(prob_output) cell2mat(prob_output(2:end,23));
get_freq = @(prob_output) 2*pi./cell2mat(prob_output(2:end,12));




beta = 0;
prob_output = run_coco_prob(m,k,beta);
max_disp_linear = get_disp(prob_output);
freq_linear = get_freq(prob_output);


beta = -1;
prob_output = run_coco_prob(m,k,beta);
max_disp_soft = get_disp(prob_output);
freq_soft = get_freq(prob_output);

beta = 1;
prob_output = run_coco_prob(m,k,beta);
max_disp_hard = get_disp(prob_output);
freq_hard = get_freq(prob_output);

fig = figure;
ax = axes;

hold(ax,"on")
plot(freq_soft,max_disp_soft)
plot(freq_linear,max_disp_linear)
plot(freq_hard,max_disp_hard)
hold(ax,"off")



save_fig(fig,"amp_dependence_base")


function prob_output = run_coco_prob(m,k,beta)
natural_frequency = sqrt(k/m);
period = 2*pi/natural_frequency;
nx = 100;

t0 = linspace(0,period,nx);
z0 = 1e-7*[sin(natural_frequency*t0);natural_frequency*cos(natural_frequency*t0)];



%------

funcs = {@(z,zeta) eom(0,z,zeta,m,k,beta)};
prob = coco_prob();
cont_args = { 1, {'po.period', 'zet'}, []};

prob = coco_set(prob, 'cont', 'NAdapt', 1);
%collocation Settings
coll_args = [funcs, {t0',z0', {'zet'}, 0}];
prob = ode_isol2po(prob, '', coll_args{:});
prob = coco_set(prob, 'cont', 'ItMX',   [0,20]);  	% Number of continuation steps [backwards,forwards]
prob = coco_set(prob, 'cont', 'h_max',  1e-1);
prob = coco_set(prob, 'cont', 'h_min',  1e-3);
prob = coco_set(prob, 'cont', 'h0',  1e-3);

file_name = "amp_dependence";
prob_output = coco(prob, file_name, [], cont_args{:});



    function y = eom(~,z,zeta,m,k,beta)
        x = z(1,:);
        x_dot = z(2,:);
        num_x = size(z,2);
        y = zeros(2,num_x);
        y(1,:) = x_dot;
        y(2,:) = -k/m*x - beta/m*x.^3 - zeta.*x_dot;
    end
end