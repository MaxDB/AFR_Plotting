function ax = plot_invariant_manifold(system_name,sol_num,state,varargin)
num_args = length(varargin);
if mod(num_args,2) == 1
    error("Invalid keyword/argument pairs")
end
keyword_args = varargin(1:2:num_args);
keyword_values = varargin(2:2:num_args);

ax = [];
manifold_colour = 1;
freq_range = [0,inf];

for arg_counter = 1:num_args/2
    switch keyword_args{arg_counter}
        case "axes"
            ax = keyword_values{arg_counter};
        case {"colour","color"}
            manifold_colour = keyword_values{arg_counter};
        otherwise
            error("Invalid keyword: " + keyword_args{arg_counter})
    end
end
%---------------------




data_directory = get_project_path+"\examples\validation\mems_arch";
points_per_orbit = 500;
plotting_coords = [1,3,2];


orbit_spacing = 0.005;

line_width = 1;
switch state
    case 1
         mesh_alpha = 0.8;
    case 2
        mesh_alpha = 1;
    case 3
        mesh_alpha = 0.8;
end

mesh_settings = {"EdgeColor","none","LineWidth",0.01,"FaceColor",get_plot_colours(manifold_colour),"FaceLighting","gouraud","FaceAlpha",mesh_alpha,"Tag","invariant_manifold"};
grid_line_style = {"Color",[0.25,0.25,0.25,0.2],"LineWidth",0.2,"Tag","grid_line"};
outline_style = {"LineWidth",1,"Tag","outline"};
outline_colours = {[get_plot_colours(manifold_colour),mesh_alpha],[0,0,0]};
marker_style = {"Marker","o","LineWidth",line_width,"MarkerEdgeColor","k","MarkerSize",5};

data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});


num_sols = length(sol_num);
Dyn_Data = data_dir_execute(@initalise_dynamic_data,system_name);

if state > 1
    Rom = Dyn_Data.Dynamic_Model;
    Model = Rom.Model;
    current_dir = pwd;
    cd(data_directory)
    lf_evec = Model.low_frequency_eigenvectors.load();
    h_evec = [Model.reduced_eigenvectors.load(),lf_evec(:,5)];
    transform = h_evec'*Model.mass;
    cd(current_dir)
    
end


point_array = cell(1,num_sols);

for iSol = 1:num_sols
    Sol = data_dir_execute(@Dyn_Data.load_solution,sol_num(iSol));
    num_orbits = Sol.num_orbits;

   
    sol_points = zeros(num_orbits,points_per_orbit+1,3);
    orbit_counter = 0;
    for iOrbit = 1:num_orbits
        switch state
            case 1
                orbit = data_dir_execute(@Dyn_Data.get_orbit,sol_num(iSol),iOrbit);
                t = orbit.tbp';
                z =  orbit.xbp';
                period = orbit.T;
            case 2
                [orbit,validation_orbit] = data_dir_execute(@Dyn_Data.get_orbit,sol_num(iSol),iOrbit,1);
                t = orbit.tbp';
                period = orbit.T;
                
                zr = orbit.xbp';
                num_modes = size(zr,1)/2;
                x = Rom.expand(zr(1:num_modes,:));
                x_dot = Rom.expand_velocity(zr(1:num_modes,:),zr((num_modes+1):(2*num_modes),:));

                r = transform*x;
                r_dot = transform*x_dot;
                
                z = [r;r_dot] + [validation_orbit.h;validation_orbit.h_dot];
            case 3
                orbit = data_dir_execute(@Dyn_Data.get_orbit,sol_num(iSol),iOrbit,1);
                t = orbit.tbp';
                period = orbit.T;

                zr = orbit.xbp';
                x = Rom.expand(zr(1,:));
                x_dot = Rom.expand_velocity(zr(1,:),zr(2,:));

                r = transform*x;
                r_dot = transform*x_dot;

                z = [r;r_dot];


        end



        freq = 2*pi/period;
        if freq < freq_range(1) || freq > freq_range(2)
            continue
        end

        orbit_counter = orbit_counter + 1;

        
        num_t_points = size(t,2);
        t_lin = linspace(0,period,num_t_points);
        
        num_modes = size(z,1)/2;
        z_lin = zeros(2*num_modes,num_t_points);
        for iState = 1:(2*num_modes)
            z_lin(iState,:) = interp1(t,z(iState,:),t_lin);
        end
        z_interp = interpft(z_lin,points_per_orbit,2);
        z_interp = [z_interp,z_interp(:,1)]; %#ok<AGROW>
        
        sol_points(orbit_counter,:,:) = z_interp(plotting_coords,:)';
        
    end
    sol_points((orbit_counter+1):end,:,:) = [];
    point_array{iSol} = sol_points;
end


if isempty(ax)
fig = figure;
ax = axes(fig);
box(ax,"on")
end





outline_counter_3d = 0;
hold(ax,"on")
for iSol = 1:num_sols
    sol_points = point_array{iSol};
    num_orbits = size(sol_points,1);
    if num_orbits < 2
        continue
    end
    mesh(ax,sol_points(:,:,1),sol_points(:,:,2),sol_points(:,:,3),mesh_settings{:})
    outline_counter_3d = outline_counter_3d + 1;
    plot3(ax,sol_points(1,:,1),sol_points(1,:,2),sol_points(1,:,3),outline_style{:},"Color",outline_colours{outline_counter_3d})
    last_orbit = zeros(3,points_per_orbit+1);
    for iOrbit = 1:(num_orbits-1)
        orbit = squeeze(sol_points(iOrbit,:,:))';
        [~,max_distance] = orbit_distance(orbit,last_orbit);
        if max_distance < orbit_spacing
            continue
        end
        plot3(ax,sol_points(iOrbit,:,1),sol_points(iOrbit,:,2),sol_points(iOrbit,:,3),grid_line_style{:})
        last_orbit = orbit;
    end
    outline_counter_3d = outline_counter_3d + 1;
    plot3(ax,sol_points(end,:,1),sol_points(end,:,2),sol_points(end,:,3),outline_style{:},"Color",outline_colours{outline_counter_3d})

    %----------------
end
hold(ax,"off")

% light(ax_3d,"Position",[0,0,1])

end


function [min_distance,max_distance] = orbit_distance(orbit_one,orbit_two)
    displacement = orbit_two - orbit_one;
    distance = sum(displacement.^2,1);
    min_distance = min(distance);
    max_distance = max(distance);
end

