clear
close all
fig_name = "limit_contour";


line_width = 2;
energy_colour = get_plot_colours(1:4);
origin_style = {".k","MarkerSize",10};

%layout
fig = figure;
tiles = tiledlayout(5,2);
tiles.TileSpacing = "tight";
tiles.Padding = "tight";
calibration_ax1 = nexttile([2,1]);
calibration_ax2 = nexttile([2,1]);
limit_ax = nexttile([3,2]);


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
force_limits = Force_Calibration.force_limit{calibration_index};

% approximate contour
unit_force_ratios = add_sep_ratios(2,10);
scaled_force_ratios = scale_sep_ratios(unit_force_ratios,force_limits);
scaled_force_ratios = sort_contour_points(scaled_force_ratios);
scaled_force_ratios = [scaled_force_ratios,scaled_force_ratios(:,1)];

% limit fig
% limit_fig = figure;
% limit_ax = gca();

hold(limit_ax,"on")
plot(limit_force(1,:),limit_force(2,:),"k:")

plot([force_limits(1,1),0],[0,0],"Color",energy_colour(1,:))
plot([force_limits(1,2),0],[0,0],"Color",energy_colour(2,:))
plot([0,0],[force_limits(2,1),0],"Color",energy_colour(3,:))
plot([0,0],[force_limits(2,2),0],"Color",energy_colour(4,:))

plot(scaled_force_ratios(1,:),scaled_force_ratios(2,:),"k-")

plot(0,0,origin_style{:})
hold(limit_ax,"off")


%%
box(limit_ax,"on")
limit_ax.XTick = [force_limits(1,2),0,force_limits(1,1)];
limit_ax.XTickLabel = {"$F^-_1$","0","$F^+_1$"};

limit_ax.YTick = [force_limits(2,2),0,force_limits(2,1)];
limit_ax.YTickLabel = {"$F^-_2$","0","$F^+_2$"};

limit_ax.TickLabelInterpreter = "latex";

xlabel("$f_1$","Interpreter","latex")
ylabel("$f_2$","Interpreter","latex")
%-------------------------------------------------
% calibration figs
degree = 7;
energy_limit = Static_Data.Model.energy_limit;
Force_Energy_Poly = Polynomial(Static_Data.restoring_force,Static_Data.potential_energy,degree,"constraint",{"linear",0},"shift",1,"scale",1);


scale_factor = 1.1;
f1_p = linspace(force_limits(1,1)*scale_factor,0,100);
f1_m = linspace(0,force_limits(1,2)*scale_factor,100);
f_zero = zeros(1,100);
v1_p = Force_Energy_Poly.evaluate_polynomial([f1_p;f_zero]);
v1_m = Force_Energy_Poly.evaluate_polynomial([f1_m;f_zero]);


f2_p = linspace(force_limits(2,1)*scale_factor,0,100);
f2_m = linspace(0,force_limits(2,2)*scale_factor,100);
v2_p = Force_Energy_Poly.evaluate_polynomial([f_zero;f2_p]);
v2_m = Force_Energy_Poly.evaluate_polynomial([f_zero;f2_m]);

 
% calibration_fig1 = figure;
% calibration_ax1 = gca();
set(fig, 'currentaxes', calibration_ax1);

hold(calibration_ax1,"on")
plot(f1_p,v1_p,"Color",energy_colour(1,:))
plot(f1_m,v1_m,"Color",energy_colour(2,:))
x_lim = calibration_ax1.XLim;
xlim(x_lim);
plot(x_lim,[1,1]*energy_limit,"k-")
plot(0,0,origin_style{:})
hold(calibration_ax1,"off")

% calibration_fig2 = figure;
% calibration_ax2 = gca();
set(fig, 'currentaxes', calibration_ax2);

hold(calibration_ax2,"on")
plot(f2_p,v2_p,"Color",energy_colour(3,:))
plot(f2_m,v2_m,"Color",energy_colour(4,:))
x_lim = calibration_ax2.XLim;
xlim(x_lim);
plot(x_lim,[1,1]*energy_limit,"k-")
plot(0,0,origin_style{:})
hold(calibration_ax2,"off")

%------------
y_lim = [0,1.9];
ylim(calibration_ax1,y_lim);
ylim(calibration_ax2,y_lim);

box(calibration_ax1,"on")
box(calibration_ax2,"on")

calibration_ax1.XTick = [force_limits(1,2),0,force_limits(1,1)];
calibration_ax1.XTickLabel = {"$F^-_1$","0","$F^+_1$"};
calibration_ax2.XTick = [force_limits(2,2),0,force_limits(2,1)];
calibration_ax2.XTickLabel = {"$F^-_2$","0","$F^+_2$"};

calibration_ax1.TickLabelInterpreter = "latex";
calibration_ax2.TickLabelInterpreter = "latex";

calibration_ax1.YTick = [0,energy_limit];
calibration_ax1.YTickLabel = {"0","$V_L$"};
calibration_ax2.YTick = [0,energy_limit];
calibration_ax2.YTickLabel = {"0","$V_L$"};

xlabel(calibration_ax1,"$f_1$","Interpreter","latex")
xlabel(calibration_ax2,"$f_2$","Interpreter","latex")

ylabel(calibration_ax1,"Energy")
ylabel(calibration_ax2,"Energy")
%------------------
lines = findobj("-property","XData");
set(lines,"LineWidth",line_width)
%------------------








save_fig(fig,fig_name)
%------------------
function points = sort_contour_points(points)
theta = atan2(points(2,:),points(1,:));
[~,sort_index] = sort(theta);
points = points(:,sort_index);

end