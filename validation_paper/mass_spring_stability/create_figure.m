clear
close all
fig_name = "stability";

frequency_range = [2.8,3.4];

line_width = 2;
rom_12_colour = get_plot_colours(2);
validation_colour = get_plot_colours(5);
%----------------------------------
data_directory = get_project_path + "\examples\3_dof_mass_spring";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Dyn_Data_1 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_1");
Dyn_Data_12 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_12");

% Dyn_Data_1 = data_dir_execute(@Dyn_Data_1.validate_solution,1,2);

[freq_1,floquet_1,floquet_v1] =  data_dir_execute(@get_floquet_multipliers,Dyn_Data_1,3,frequency_range);
[freq_12,floquet_12] = data_dir_execute(@get_floquet_multipliers,Dyn_Data_12,1,frequency_range);


swap_column = 18;
floquet_v1([3,4],swap_column) = floquet_v1([4,3],swap_column);
%---------------------------------------------------------
fig = figure;
ax = axes(fig);
box(ax,"on")

radius_v1 = abs(floquet_v1);
radius_12 = abs(floquet_12);


stable_v1 = radius_v1(3,:) < 1.01;
v1_zero = find(~stable_v1,1);
stable_v1 = [stable_v1(1:(v1_zero-1)),true,stable_v1((v1_zero+1):end)];
freq_1 = [freq_1(1:(v1_zero-1)),nan,freq_1((v1_zero+1):end)];
radius_v1 = [radius_v1(:,1:(v1_zero-1)),[nan;nan;nan;nan],radius_v1(:,(v1_zero+1):end)];

unstable_v1 = ~stable_v1;
start_index = find(unstable_v1,1);
end_index = find(unstable_v1,1,"last");
unstable_v1([start_index-2,end_index+1]) = true;


stable_12 = radius_12(3,:) < 1.01;
v2_zero = find(~stable_12,1);
stable_12 = [stable_12(1:(v2_zero-1)),true,stable_12((v2_zero+1):end)];
freq_12 = [freq_12(1:(v2_zero-1)),nan,freq_12((v2_zero+1):end)];
radius_12 = [radius_12(:,1:(v2_zero-1)),[nan;nan;nan],radius_12(:,(v2_zero+1):end)];

unstable_12 = ~stable_12;
start_index = find(unstable_12,1);
end_index = find(unstable_12,1,"last");
unstable_12([start_index-2,end_index+1]) = true;



hold(ax,"on")
plot(freq_1(stable_v1),radius_v1(3:4,stable_v1),"Color",validation_colour,"LineWidth",line_width)
plot(freq_1(unstable_v1),radius_v1(3:4,unstable_v1),"Color",validation_colour,"LineWidth",line_width,"LineStyle",":")
plot(freq_12(stable_12),radius_12(2:3,stable_12),"Color",rom_12_colour,"LineWidth",line_width)
plot(freq_12(unstable_12),radius_12(2:3,unstable_12),"Color",rom_12_colour,"LineWidth",line_width,"LineStyle",":")
hold(ax,"off")

xlabel(ax,"Frequency (rad/s)")
ylabel(ax,"Floquet multiplier amplitude")
xlim(ax,[2.85,3.26])
ylim(ax,[0.6,1.7])



%-------------------
save_fig(fig,fig_name)


%----------
function [frequency,orbit_multipliers,validation_multipliers] = get_floquet_multipliers(Dyn_Data,sol_num,frequency_range)

Sol = Dyn_Data.load_solution(sol_num);
orbit_ids = find(Sol.frequency >= frequency_range(1) & Sol.frequency <= frequency_range(2));
frequency = Sol.frequency(orbit_ids);
[~,validation_orbits,solution_path] = Dyn_Data.get_orbit(sol_num,orbit_ids,1);


bd = coco_bd_read(solution_path);
orbit_data  = coco_bd_col(bd, {"eigs"});

orbit_multipliers = orbit_data(:,Sol.orbit_labels(orbit_ids));

if nargout == 2
    validation_multipliers = [];
    return
end
validation_multipliers = cell2mat(cellfun(@(x) x.evals',validation_orbits,"UniformOutput",false))';
end