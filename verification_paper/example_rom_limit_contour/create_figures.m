clear
close all
fig_name = "model_limit_contour";
mode = 2;

line_width = 2;
energy_colour = get_plot_colours(3);
origin_style = {".k","MarkerSize",10};

point_style = {"x","Color",energy_colour,"MarkerSize",8};
sep_2_style = {"Color",get_plot_colours(2)};
limit_style = {"Color",get_plot_colours(5)};
%layout
fig = figure;
ax = gca();

%--------------------------------------------------
data_directory = get_project_path + "\examples\rom_challenge";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});


% limit contour
Static_Data = data_dir_execute(@load_static_data,"exhaust_17");

Rom = data_dir_execute(@Reduced_System,Static_Data);
Energy_Poly = Rom.Potential_Polynomial;
ax_potential = data_dir_execute(@Energy_Poly.plot_polynomial,"potential",{Energy_Poly,1.8});
ax_potential = ax_potential{1};
potential_surface = ax_potential.Children;

limit_X = potential_surface.XData(:,end)';
limit_Y = potential_surface.YData(:,end)';
limit_Z = potential_surface.ZData(:,end)';


Force_Poly = Rom.Force_Polynomial;

limit_force = Force_Poly.evaluate_polynomial([limit_X;limit_Y]);
close(gcf())

% calibration data
load(data_directory + "\geometry\exhaust\force_calibration.mat","Force_Calibration");
calibration_index = Force_Calibration.energy_limit == 1.8;
calibrated_modes = Force_Calibration.calibrated_modes{calibration_index};
mode_index = calibrated_modes == 1 | calibrated_modes == 7;
force_limits = Force_Calibration.force_limit{calibration_index};
force_limits = force_limits(mode_index,:);

% approximate contour
unit_force_ratios = add_sep_ratios(2,10);
scaled_force_ratios = scale_sep_ratios(unit_force_ratios,force_limits);
scaled_force_ratios = sort_contour_points(scaled_force_ratios);
scaled_force_ratios = [scaled_force_ratios,scaled_force_ratios(:,1)];

hold(ax,"on")
% plot(limit_force(1,:),limit_force(2,:),"k:")
adjusted_force_limits = Rom.Model.calibrated_forces;
plot([adjusted_force_limits(1,1),0],[0,0],"Color",energy_colour)
plot([adjusted_force_limits(1,2),0],[0,0],"Color",energy_colour)
plot([0,0],[adjusted_force_limits(2,1),0],"Color",energy_colour)
plot([0,0],[adjusted_force_limits(2,2),0],"Color",energy_colour)

plot(scaled_force_ratios(1,:),scaled_force_ratios(2,:),"k-")

origin = plot(0,0,origin_style{:});
hold(ax,"off")


%%%
box(ax,"on")
ax.XTick = [force_limits(1,2),0,force_limits(1,1)];
ax.XTickLabel = {"$F^-_1$","0","$F^+_1$"};

ax.YTick = [force_limits(2,2),0,force_limits(2,1)];
ax.YTickLabel = {"$F^-_2$","0","$F^+_2$"};

ax.TickLabelInterpreter = "latex";

xlabel("$f_1$","Interpreter","latex")
ylabel("$f_2$","Interpreter","latex")
%-------------------------------------------------
% load cases

hold(ax,"on")
for iSEP = 1:2
    force_points = linspace(0,adjusted_force_limits(1,iSEP),6);
    force_points(1) = [];
    plot(force_points,zeros(1,5),point_style{:})
end
for iSEP = 1:2
    force_points = linspace(0,adjusted_force_limits(2,iSEP),6);
    force_points(1) = [];
    plot(zeros(1,5),force_points,point_style{:})
end
hold(ax,"off")


%------
%Model limit
if size(Static_Data,2) ~= 20
    error("Needs to be pre-verification")
end
Rom = data_dir_execute(@Reduced_System,Static_Data,3);
max_sep_points = 50;

unit_force_ratios = add_sep_ratios(2,6);
scaled_force_ratios = scale_sep_ratios(unit_force_ratios,force_limits);


num_seps = size(scaled_force_ratios,2);


force_end = zeros(2,num_seps);
for iSep = 1:num_seps
    force_ratio = scaled_force_ratios(:,iSep);
    [disp_sep,lambda_sep] = find_sep_rom(Rom,force_ratio,3*max_sep_points,"limit_type","base");

    force_end(:,iSep) = force_ratio*lambda_sep(end);
end

force_end = sort_contour_points(force_end);
force_end = [force_end,force_end(:,1)];
hold(ax,"on")
limit_line = plot(force_end(1,:),force_end(2,:),limit_style{:});
hold(ax,"off")

%-----
%tested SEPs
unit_force_ratios = add_sep_ratios(2,2,add_sep_ratios(2,1));
scaled_force_ratios = scale_sep_ratios(unit_force_ratios,adjusted_force_limits);


num_seps = size(scaled_force_ratios,2);
hold(ax,"on")
for iSep = 1:num_seps
    force_ratio = scaled_force_ratios(:,iSep);
    [disp_sep,lambda_sep] = find_sep_rom(Rom,force_ratio,3*max_sep_points);

    sep_points = force_ratio.*lambda_sep;
    sep_plot_lines(iSep) = plot(sep_points(1,:),sep_points(2,:),sep_2_style{:}); %#ok<SAGROW>
end
hold(ax,"off")


%------------------
lines = findobj("-property","XData");
set(lines,"LineWidth",line_width)
uistack(origin,"top")
%------------------




if mode == 2
    delete(sep_plot_lines)
    delete(limit_line)

    new_lim_1 = [force_limits(1,2)*1.1,force_limits(1,1)*1.1];
    xlim(ax,new_lim_1)

    new_lim_2 = [force_limits(2,2)*1.1,force_limits(2,1)*1.1];
    ylim(ax,new_lim_2)
end



save_fig(fig,fig_name)
%------------------
function points = sort_contour_points(points)
theta = atan2(points(2,:),points(1,:));
[~,sort_index] = sort(theta);
points = points(:,sort_index);

end