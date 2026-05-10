clear
close all
fig_name = "arch_space_complexity";
num_workers = 1;

SAMPLE_PERIOD = 1;
MAX_MEMORY = 31.2;

tiled_plot = 1;
%--------------------------------------------------
data_directory = get_project_path + "\examples\size_test";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

data_path = "data\size_data\workers_" + num_workers;
Size_Data = data_dir_execute(@load,data_path+"\size_data.mat","Size_Data");
Size_Data = Size_Data.Size_Data;


num_dofs = Size_Data(1).num_dofs;
num_seeds = size(num_dofs,2);
num_repeats = size(Size_Data,2);


for iSeed = 1:num_seeds
    figure
    if tiled_plot
        tiledlayout(num_repeats,1);
        plot_style = {"Color","k"};
    else
        ax = axes;
        hold(ax,"on")
        plot_style = {};
    end
    for iRepeat = 1:num_repeats
        if tiled_plot
            ax = nexttile;
        end
        memory_data = Size_Data(iRepeat).free_memory;
        memory = MAX_MEMORY - memory_data{iSeed};
        num_points = size(memory,1);
        time = 0:1:(SAMPLE_PERIOD*(num_points-1));


        plot(ax,time,memory,plot_style{:})

        box(ax,"on")
        
        ylabel(ax,"Memory (GB)")
        xlabel(ax,"Time (s)")
        ylim(ax,[0,32])
        xlim(ax,[0,max(time)])

        if tiled_plot
            title(ax,add_comma(num_dofs(iSeed)) + " DoFs - sim " + iRepeat)
            add_time_markers(ax,Size_Data,iSeed,iRepeat);
        else
            title(ax,add_comma(num_dofs(iSeed)) + " DoFs")
        end
    end
    if ~tiled_plot
        hold(ax,"off")
    end

end
function num_out = add_comma(num_in)
   java_formater=java.text.DecimalFormat;
   num_out= string(java_formater.format(num_in)); 
end

%---
function add_time_markers(ax,Size_Data,iSeed,iRepeat)
span_style = {"LineWidth",3};
colour_order = [4,3,2,1];
Repeat_Data = Size_Data(iRepeat);

cumulative_time = zeros(4,1);
cumulative_time(:) = cumulative_time(:)+ Repeat_Data.matrix_time(iSeed);
cumulative_time(2:end) = cumulative_time(2:end)+ Repeat_Data.initialisation_time(iSeed);
cumulative_time(3:end) = cumulative_time(3:end)+ Repeat_Data.scaffold_time(iSeed);
cumulative_time(4:end) = Repeat_Data.total_time(iSeed);
cumulative_time = [0;cumulative_time];

marker_height = [0,0];

hold(ax,"on")
for iTime = 1:4
    time_span = cumulative_time(iTime:(iTime+1));
    plot(time_span,marker_height,"Color",get_plot_colours(colour_order(iTime)),span_style{:})
end
hold(ax,"off")
end

function title = get_title(num_workers)
number_words = ["One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten"];
numer_word = number_words(num_workers);

title = numer_word + " worker";
if num_workers > 1
    title = title + "s";
end

end