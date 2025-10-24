clear
close all
fig_name = "verification_seps";

%--
line_width = 2;
energy_colour = get_plot_colours(1:4);
origin_style = {".k","MarkerSize",10};
line_colours = get_plot_colours(1:3);
%--

fig = figure;
ax = gca();
%--------------------------------------------------
data_directory = get_project_path + "\examples\rom_challenge";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});




% calibration data
load(data_directory + "\geometry\exhaust\force_calibration.mat","Force_Calibration");
calibration_index = Force_Calibration.energy_limit == 1.8;
force_limits = Force_Calibration.force_limit{calibration_index};

% approximate contour
unit_force_ratios = add_sep_ratios(2,10);
scaled_force_ratios = scale_sep_ratios(unit_force_ratios,force_limits);
scaled_force_ratios = sort_contour_points(scaled_force_ratios);
scaled_force_ratios = [scaled_force_ratios,scaled_force_ratios(:,1)];

% seps
primary_frs = get_force_ratios(1,force_limits);
secondary_frs = get_force_ratios(2,force_limits);
tertiary_frs = get_force_ratios(3,force_limits);


hold(ax,"on")
plot_force_ratios(ax,tertiary_frs,{"Color",line_colours(1,:)})
plot_force_ratios(ax,secondary_frs,{"Color",line_colours(2,:)})
plot_force_ratios(ax,primary_frs,{"Color",line_colours(3,:)})



plot(scaled_force_ratios(1,:),scaled_force_ratios(2,:),"k-")

plot(0,0,origin_style{:})
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
lines = findobj("-property","XData");
set(lines,"LineWidth",line_width)
%--

save_fig(fig,fig_name)
%------------------
function points = sort_contour_points(points)
theta = atan2(points(2,:),points(1,:));
[~,sort_index] = sort(theta);
points = points(:,sort_index);

end

function force_ratios = get_force_ratios(index,force_limits)
found_force_ratios = add_sep_ratios(2,index-1);
if index == 1
    found_force_ratios = [];
end
unit_force_ratios = add_sep_ratios(2,index,found_force_ratios);
force_ratios = scale_sep_ratios(unit_force_ratios,force_limits);
end

function plot_force_ratios(ax,force_ratios,style)
num_seps = size(force_ratios,2);
for iSep = 1:num_seps
    plot(ax,[0,force_ratios(1,iSep)],[0,force_ratios(2,iSep)],style{:})
end

end