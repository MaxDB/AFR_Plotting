function [ax_2d,ax_3d] = plot_invariant_manifold(system_name,sol_num,max_x1,freq_range)
data_directory = get_project_path+"\examples\verification";
points_per_orbit = 500;
plotting_coords = [1,3,2];


orbit_spacing = 0.005;

line_width = 1;
mesh_alpha = 1;
mesh_settings = {"EdgeColor","none","LineWidth",0.01,"FaceColor",get_plot_colours(5),"FaceLighting","gouraud","FaceAlpha",mesh_alpha,"Tag","invariant_manifold"};
grid_line_style = {"Color",[0.25,0.25,0.25,0.2],"LineWidth",0.2,"Tag","grid_line"};
outline_style = {"LineWidth",1,"Tag","outline"};
outline_colours = [[0,0,0];get_plot_colours([1,4]);[0,0,0]];
marker_style = {"Marker","o","LineWidth",line_width,"MarkerEdgeColor","k","MarkerSize",5};

data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});


num_sols = length(sol_num);
Dyn_Data = data_dir_execute(@initalise_dynamic_data,system_name);
Model = Dyn_Data.Dynamic_Model.Model;

evec = Model.reduced_eigenvectors;
num_modes = size(evec,2);

point_array = cell(1,num_sols);
zero_point_array = cell(2,num_sols);

for iSol = 1:num_sols
    Sol = data_dir_execute(@Dyn_Data.load_solution,sol_num(iSol));
    num_orbits = Sol.num_orbits;
    zero_points_one = zeros(2*num_modes,0);
    zero_points_two = zeros(2*num_modes,0);
   
    sol_points = zeros(num_orbits,points_per_orbit+1,3);
    orbit_counter = 0;
    for iOrbit = 1:num_orbits
        orbit = data_dir_execute(@Dyn_Data.get_orbit,sol_num(iSol),iOrbit);
        
        period = orbit.T;
        freq = 2*pi/period;
        if freq < freq_range(1) || freq > freq_range(2)
            continue
        end
        r = orbit.xbp';
        x = evec*r(1:num_modes,:);
        x_dot  = evec*r((num_modes+1):(2*num_modes),:);

        % E = 0.5*sum(x_dot.^2,1);
        if max(abs(x(1,:))) > max_x1
            continue
        end
        % if max(E) > energy_lim
        %     continue
        % end
        orbit_counter = orbit_counter + 1;

        t = orbit.tbp';
        num_t_points = size(t,2);
        t_lin = linspace(0,period,num_t_points);
        z = [x;x_dot];
        z_lin = zeros(2*num_modes,num_t_points);
        for iState = 1:(2*num_modes)
            z_lin(iState,:) = interp1(t,z(iState,:),t_lin);
        end
        z_interp = interpft(z_lin,points_per_orbit,2);
        z_interp = [z_interp,z_interp(:,1)]; %#ok<AGROW>
        
        sol_points(orbit_counter,:,:) = z_interp(plotting_coords,:)';

        z_zero = get_zero_points(x_dot,z);
        num_zero_points = size(z_zero,2);
        for iZero = 1:num_zero_points
            zero_point = z_zero(:,iZero);
            if zero_point(1) <= 0
                zero_points_one = [zero_points_one,zero_point]; %#ok<AGROW>
            else
                zero_points_two = [zero_points_two,zero_point]; %#ok<AGROW>
            end
        end
        
    end
    sol_points((orbit_counter+1):end,:,:) = [];
    point_array{iSol} = sol_points;
    zero_point_array{1,iSol} = zero_points_one(1:num_modes,:);
    zero_point_array{2,iSol} = zero_points_two(1:num_modes,:);
end


fig_3d = figure;
ax_3d = axes(fig_3d);
box(ax_3d,"on")


fig_2d = figure;
ax_2d = axes(fig_2d);
box(ax_2d,"on")


outline_counter_3d = 0;
outline_counter_2d = 0;
hold(ax_2d,"on")
hold(ax_3d,"on")
for iSol = 1:num_sols
    sol_points = point_array{iSol};
    num_orbits = size(sol_points,1);
    if num_orbits < 2
        continue
    end
    mesh(ax_3d,sol_points(:,:,1),sol_points(:,:,2),sol_points(:,:,3),mesh_settings{:})
    outline_counter_3d = outline_counter_3d + 1;
    plot3(ax_3d,sol_points(1,:,1),sol_points(1,:,2),sol_points(1,:,3),outline_style{:},"Color",outline_colours(outline_counter_3d,:))
    last_orbit = zeros(3,points_per_orbit+1);
    for iOrbit = 1:(num_orbits-1)
        orbit = squeeze(sol_points(iOrbit,:,:))';
        [~,max_distance] = orbit_distance(orbit,last_orbit);
        if max_distance < orbit_spacing
            continue
        end
        plot3(ax_3d,sol_points(iOrbit,:,1),sol_points(iOrbit,:,2),sol_points(iOrbit,:,3),grid_line_style{:})
        last_orbit = orbit;
    end
    outline_counter_3d = outline_counter_3d + 1;
    plot3(ax_3d,sol_points(end,:,1),sol_points(end,:,2),sol_points(end,:,3),outline_style{:},"Color",outline_colours(outline_counter_3d,:))

    %----------------
    sol_zero_points_one = zero_point_array{1,iSol};
    sol_zero_points_two = zero_point_array{2,iSol};
    plot(ax_2d, sol_zero_points_one(1,:), sol_zero_points_one(2,:),"k-","LineWidth",line_width)
    plot(ax_2d, sol_zero_points_two(1,:), sol_zero_points_two(2,:),"k-","LineWidth",line_width)
    
    outline_counter_2d = outline_counter_2d + 1;
    if outline_counter_2d > 1
        plot(ax_2d,sol_zero_points_one(1,1),sol_zero_points_one(2,1),marker_style{:},"MarkerFaceColor",outline_colours(outline_counter_2d,:))
        plot(ax_2d,sol_zero_points_two(1,1),sol_zero_points_two(2,1),marker_style{:},"MarkerFaceColor",outline_colours(outline_counter_2d,:))
    end
    
    outline_counter_2d = outline_counter_2d + 1;
    plot(ax_2d,sol_zero_points_one(1,end),sol_zero_points_one(2,end),marker_style{:},"MarkerFaceColor",outline_colours(outline_counter_2d,:))
    plot(ax_2d,sol_zero_points_two(1,end),sol_zero_points_two(2,end),marker_style{:},"MarkerFaceColor",outline_colours(outline_counter_2d,:))
end
hold(ax_3d,"off")
hold(ax_2d,"off")

% light(ax_3d,"Position",[0,0,1])

end


function [min_distance,max_distance] = orbit_distance(orbit_one,orbit_two)
    displacement = orbit_two - orbit_one;
    distance = sum(displacement.^2,1);
    min_distance = min(distance);
    max_distance = max(distance);
end

function zero_points = get_zero_points(x,z)
state_size = size(z,1);
num_intervals = size(x,2) - 1;
zero_points = zeros(state_size,0);
for iX = 1:num_intervals
    point_span = [iX, iX + 1];
    points = x(:,point_span);
    zero_interval = prod(sign(points),2) ~= 1;

    if ~all(zero_interval)
        continue
    end
    
    

    % zero_point = iX + t;
    
    
    z_points = z(:,point_span);

    if ~all(z_points(3,:) == 0)
        t_one = interp1(z_points(3,:),[0,1],0);
    else
        t_one = [];
    end
    if ~all(z_points(4,:) == 0)
        t_two = interp1(z_points(4,:),[0,1],0);
        if isempty(t_one)
            t_one = t_two;
        end
    else
        t_two = t_one;
    end

    if 2*abs(t_one - t_two)/(t_one+t_two) > 0.05
        continue
    end

    t = mean([t_one,t_two]);

    z_zero = zeros(state_size,1);
    for iZ = 1:state_size
        z_zero(iZ) = interp1([0,1],z_points(iZ,:),t);
    end

    zero_points = [zero_points,z_zero]; %#ok<AGROW>
end
    
end