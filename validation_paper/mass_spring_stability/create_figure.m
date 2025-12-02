clear
close all
fig_name = "stability";

frequency_range = [2.8,3.3];

line_width = 2;
rom_12_colour = get_plot_colours(2);
validation_colour = get_plot_colours(5);

stable_style = {"LineStyle","-","LineWidth",line_width};
unstable_style = {"LineStyle",":","LineWidth",line_width};
%----------------------------------
data_directory = get_project_path + "\examples\validation\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Dyn_Data_1 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_1");
Dyn_Data_12 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_12");

% Dyn_Data_1 = data_dir_execute(@Dyn_Data_1.validate_solution,1,2);

[freq_1,floquet_1,floquet_v1_all] =  data_dir_execute(@get_floquet_multipliers,Dyn_Data_1,1,frequency_range);
[freq_12,floquet_12_all] = data_dir_execute(@get_floquet_multipliers,Dyn_Data_12,2,frequency_range);




function floquet = sort_multipliers(floquet_all)
num_points = size(floquet_all,2);
floquet = zeros(2,num_points);
for iPoint = 1:num_points
    [abs_value,index] = uniquetol(abs(floquet_all(:,iPoint)));
    [~,sort_index] = sort(abs_value,"descend");
    mults = floquet_all(index(sort_index),iPoint);
    if length(mults) > 2
        [~,min_index] = min(abs(abs(mults)-1));
        mults(min_index) = [];
    end
    floquet(:,iPoint) = mults;
end
end

floquet_v1 = sort_multipliers(floquet_v1_all);
floquet_12 = sort_multipliers(floquet_12_all);

STAB_TOL = 1.01;
stability_v1 = max(abs(floquet_v1),[],1) < STAB_TOL;
stability_12 = max(abs(floquet_12),[],1) < STAB_TOL;
%---------------------------------------------------------
fig = figure;
ax = axes(fig);
box(ax,"on")

radius_v1 = abs(floquet_v1);
radius_12 = abs(floquet_12);

function [freq_stable, freq_unstable] = seperate_frequency(frequency,stability,joins)
freq_stable = frequency;
freq_stable(~stability) = nan;

freq_unstable =frequency;
freq_unstable(stability) = nan;

if joins >= 1
    start_index = find(isnan(freq_stable),1) - 1;
    freq_unstable(start_index) = frequency(start_index);
end
if joins >= 2
    end_index = find(~isnan(freq_unstable),1,"last") + 1;
    freq_unstable(end_index) = frequency(end_index);
end

end
[freq_stable_1,freq_unstable_1] = seperate_frequency(freq_1,stability_v1,1);
[freq_stable_12,freq_unstable_12] = seperate_frequency(freq_12,stability_12,2);


hold on
plot(freq_stable_1,radius_v1(1,:),"Color",validation_colour,stable_style{:})
plot(freq_stable_12,radius_12(1,:),"Color",rom_12_colour,stable_style{:})
plot([max(freq_stable_12),3.2],[radius_12(1,end),1],"Color",rom_12_colour,stable_style{:})

plot(freq_unstable_1,radius_v1,"Color",validation_colour,unstable_style{:})
plot(freq_unstable_12,radius_12,"Color",rom_12_colour,unstable_style{:})
hold off



xlabel(ax,"Frequency (rad/s)")
ylabel(ax,"Floquet multiplier amplitude")
xlim(ax,[2.85,3.2])
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