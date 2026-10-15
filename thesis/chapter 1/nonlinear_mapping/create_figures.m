clear 
close all

fig_name = "nonlinear_mapping";
%--
figs = open_local_figures("nonlinear_mapping_base");
fig = figs{1};

load("data\poly.mat","manifold_poly")
%-------
orbit_style = {"Color",get_plot_colours(3),"LineWidth",2};
edge_style = {"Color","k","LineWidth",1.2};
grid_style = {"Color",get_plot_colours("grey"),"LineWidth",1};

%----
ax = findobj(fig,"type","axes");


ax.XTick = [];
ax.YTick = [];
ax.ZTick = [];

xlabel(ax,"")
ylabel(ax,"")
zlabel(ax,"")


%---
lines = findobj(ax,"type","line");
edge = findobj(lines,"tag","edge");
set(edge,edge_style{:})
edge.ZData = edge.ZData + max(edge.ZData)*0.05;

orbit = findobj(lines,"tag","orbit");
set(orbit,orbit_style{:})

orbit.ZData = orbit.ZData + max(orbit.ZData)*0.05;



%---
manifold = findobj(ax,"type","surface");
manifold.EdgeColor = "none";


x_data = manifold.XData;
y_data = manifold.YData;
z_data = manifold.ZData;

x_range = [min(edge.XData),max(edge.XData)];
y_range = [min(edge.YData),max(edge.YData)];
z_range = [min(edge.ZData),max(edge.ZData)];

num_grid_lines = 10;

x_grid_start = linspace(x_range(1),x_range(2),num_grid_lines);
y_grid_start = linspace(y_range(1),y_range(2),num_grid_lines);


num_points = 100;
y_span = linspace(y_range(1),y_range(2),num_points);
x_span = linspace(x_range(1),x_range(2),num_points);


for iGrid = 2:(num_grid_lines-1)
    x_grid = repmat(x_grid_start(iGrid),1,num_points);
    z_grid = manifold_poly.evaluate_polynomial([x_grid;y_span]);
    plot3(ax,x_grid,y_span,z_grid,"tag","grid",grid_style{:})

    y_grid = repmat(y_grid_start(iGrid),1,num_points);
    z_grid = manifold_poly.evaluate_polynomial([x_span;y_grid]);
    plot3(ax,x_span,y_grid,z_grid,"tag","grid",grid_style{:})

end
grid_lines = findobj(ax,"tag","grid");
%---
xlim(ax,x_range*1.5)
ylim(ax,y_range*1.5)
zlim(ax,z_range*1.5)

uistack(edge,"top")
ax.CameraPosition = [-0.470991934331205,-0.537735855569324,0.004623443622507];
%---
save_fig(fig,fig_name)



%---
projected_fig_name = "nonlinear_mapping_2d";
projected_fig = figure;
ax = axes;
ax.XTick = [];
ax.YTick = [];
ax.ZTick = [];
ax.Visible = "off";

hold(ax,"on")
num_grid_lines = numel(grid_lines);
for iLine = 1:num_grid_lines
    plot(ax,grid_lines(iLine).XData,grid_lines(iLine).YData,grid_style{:})
end
plot(ax,orbit.XData,orbit.YData,orbit_style{:})
plot(ax,edge.XData,edge.YData,edge_style{:})
hold(ax,"off")

xlim(ax,x_range)
ylim(ax,y_range)

save_fig(projected_fig,projected_fig_name)