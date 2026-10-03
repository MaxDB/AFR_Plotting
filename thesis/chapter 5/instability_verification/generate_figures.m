clear
close all
%--------------------------------------------------
plot_num = 2;

fig_name = "unstable_verification";
fig_name = fig_name + "_" + plot_num;

load("data\staticDataset.mat","static")


disp = static.Q(1:2,:);
force = static.P;
energy =static.E;

force_ratios = force./vecnorm(force);
force_ratios = force_ratios.*sign(force_ratios(1,:));
num_points = size(force_ratios,2);

fig = figure;
tiles = tiledlayout(1,2);
force_ax = nexttile;
disp_ax = nexttile;
hold(force_ax,"on")
hold(disp_ax,"on")
%
% figure
% text_ax = axes;
% hold(text_ax,"on")

% plot_nums = [2:4,9,13]; %top right quadrant
switch plot_num
    case 1
        plot_nums = [1,3,5,9,11,13];
        col_nums = [1,3,2,1,3,2];
    case 2
        plot_nums = 1:16;
        col_nums = [1,5,3,6,2,7,4,8,1,5,3,6,2,7,4,8];
end

plot_count = 0;

while ~isempty(force_ratios)
    plot_count = plot_count + 1;
    
    force_ratio = force_ratios(:,1);
    sep_index = ismembertol(force_ratios',force_ratios(:,1)',1e-2,"ByRows",true);
    out_index = find(~sep_index,1);
    if isempty(out_index)
        out_index = length(sep_index) + 1;
    end

    sep_index = find(sep_index(1:(out_index-1)));

    lambda = linspace(0,1,length(sep_index)+1);
    sep_disp = [[0;0],disp(:,sep_index)];
    sep_disp_interp = spline(lambda,sep_disp,linspace(0,1,200));
    sep_force = [[0;0],force(:,sep_index)];

    if ismember(plot_count,plot_nums)
        col_num = col_nums(plot_nums == plot_count);
        plot(force_ax,sep_force(1,:),sep_force(2,:),"-","Color",get_plot_colours(col_num))
        plot(disp_ax,sep_disp_interp(1,:),sep_disp_interp(2,:),"-","Color",get_plot_colours(col_num));
    end
    
    sep_energy = [static.initialEnergy,energy(sep_index)];
    sep_energy_interp = spline(lambda,sep_energy,linspace(0,1,200));
    % plot3(text_ax,sep_disp_interp(1,:),sep_disp_interp(2,:),sep_energy_interp);
    

    energy(:,sep_index) = [];
    disp(:,sep_index) = [];
    force(:,sep_index) = [];
    force_ratios(:,sep_index) = [];
end

%----------
save_fig(fig,fig_name+"_base");