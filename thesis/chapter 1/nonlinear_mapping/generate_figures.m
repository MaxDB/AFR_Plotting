clear
close all

fig_name = "nonlinear_mapping_base";

%----------
data_directory = get_project_path + "\examples\validation\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Dyn_Data = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_12");



% fig = figure;
% ax = axes;
% hold(ax,"on")
x_lim_max = [0,0];
y_lim_max = [0,0];
z_lim_max = [0,0];

x_data = [];
y_data = [];
z_data = [];

limit_orbit = 23;
plot_orbit = limit_orbit - 3;

for iOrbit = 1:limit_orbit
    Orbit = data_dir_execute(@get_orbit,Dyn_Data,1,iOrbit);
    z = Orbit.xbp';
    % plot3(ax,z(1,:),z(3,:),z(2,:))

    x_data = [x_data,z(1,:)]; %#ok<*AGROW>
    y_data = [y_data,z(3,:)];
    z_data = [z_data,z(2,:)];
    
    x_lim_max = set_maximum(x_lim_max,z(1,:));
    y_lim_max = set_maximum(y_lim_max,z(3,:));
    z_lim_max = set_maximum(z_lim_max,z(2,:));
end

% xlim(ax,x_lim_max)
% ylim(ax,y_lim_max)
% zlim(ax,z_lim_max)

for iOrbit = limit_orbit:(limit_orbit + 15)
    Orbit = data_dir_execute(@get_orbit,Dyn_Data,1,iOrbit);
    z = Orbit.xbp';
    % plot3(ax,z(1,:),z(3,:),z(2,:))

    num_points = size(z,2);
    for iPoint = 1:num_points
        z_point = z([1,3,2],iPoint);
        in_limit = check_limits(z_point,x_lim_max,y_lim_max,z_lim_max);
        if ~in_limit
            continue
        end
        x_data = [x_data,z_point(1)];
        y_data = [y_data,z_point(2)];
        z_data = [z_data,z_point(3)];
    end
end

manifold_poly = Polynomial([x_data;y_data],z_data,5,"constraint",{"constant",0});
ax = manifold_poly.plot_polynomial;
ax = ax{1};
box(ax,"on")

Orbit = data_dir_execute(@get_orbit,Dyn_Data,1,plot_orbit);
z = Orbit.xbp';
hold(ax,"on")
plot3(ax,z(1,:),z(3,:),z(2,:),"tag","orbit")
fig = gcf;
%--
%plot edge

manifold = findobj(ax,"type","surface");
rect_x = [manifold.XData(:,2)',manifold.XData(2,:),manifold.XData(:,end-1)',manifold.XData(end-1,:)];
rect_y = [manifold.YData(:,2)',manifold.YData(2,:),manifold.YData(:,end-1)',manifold.YData(end-1,:)];


rect_height = manifold_poly.evaluate_polynomial([rect_x;rect_y]);
plot3(ax,rect_x,rect_y,rect_height,"tag","edge")

%---

save_fig(fig,fig_name)
save("data\poly","manifold_poly")

%------------

function lim = set_maximum(lim,new_data)
lim(1) = min(lim(1),min(new_data));
lim(2) = max(lim(2),max(new_data));
end

function in_limit = check_limits(z_point,x_lim_max,y_lim_max,z_lim_max)
in_limit = z_point(1) >= x_lim_max(1) && z_point(1) <= x_lim_max(2) && ...
    z_point(2) >= y_lim_max(1) && z_point(2) <= y_lim_max(2) && ...
    z_point(3) >= z_lim_max(1) && z_point(3) <= z_lim_max(2);

end