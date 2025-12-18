clear
% close all
num_workers = 1;
fig_name = "arch_time_complexity_" + num_workers;



%layout
fig = figure;
tiles = tiledlayout(3,2);
tiles.TileSpacing = "tight";
tiles.Padding ="tight";

ax = nexttile([2,2]);

%--------------------------------------------------
data_directory = get_project_path + "\examples\validation\mems_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});


data_path = "data\size_data_all\workers_" + num_workers;

Size_Data = data_dir_execute(@load,data_path+"\size_data.mat","Size_Data");
Size_Data = Size_Data.Size_Data;
Size_Data = time_transform(Size_Data,1/60);

[Size_Data_1,Size_Data_16] = split_size_data(Size_Data);

[Size_Data_Mean_1,Size_Data_Range_1] = get_mean_data(Size_Data_1);
[Size_Data_Mean_16,Size_Data_Range_16] = get_mean_data(Size_Data_16);

num_dofs = Size_Data(1).num_dofs;
num_dofs = num_dofs(1:size(Size_Data_Mean_16.total_time,2));
num_seeds = size(num_dofs,2);


static_data_time_1 = Size_Data_Mean_1.total_time;
static_data_time_range_1 = Size_Data_Range_1.total_time;
validation_time_1 = Size_Data_Mean_1.validation_time;
validation_time_range_1 = Size_Data_Range_1.validation_time;

static_data_time_16 = Size_Data_Mean_16.total_time;
static_data_time_range_16 = Size_Data_Range_16.total_time;
validation_time_16 = Size_Data_Mean_16.validation_time;
validation_time_range_16 = Size_Data_Range_16.validation_time;

cumulative_time = zeros(4,num_seeds);
cumulative_time(:,:) = cumulative_time(:,:)+ static_data_time_1;
cumulative_time(2:end,:) = cumulative_time(2:end,:)+ validation_time_1;
cumulative_time(3:end,:) = cumulative_time(3:end,:)+ static_data_time_16;
cumulative_time(4:end,:) = cumulative_time(4:end,:)+ validation_time_16;



hold(ax,"on")
plot_polyshape(ax,num_dofs,cumulative_time(4,:),1)
plot_polyshape(ax,num_dofs,cumulative_time(3,:),2)
plot_polyshape(ax,num_dofs,cumulative_time(2,:),3)
plot_polyshape(ax,num_dofs,cumulative_time(1,:),4)
hold(ax,"off")

box(ax,"on")
xlabel(ax,"DoFs")
ylabel(ax,"Time (mins)")

ylim(ax,[0,ax.YLim(2)])
title(ax,get_title(num_workers))


hold(ax,"on")
plot_error_bars(ax,num_dofs,cumulative_time(4,:),validation_time_range_16,1)
plot_error_bars(ax,num_dofs,cumulative_time(3,:),static_data_time_range_16,2)
plot_error_bars(ax,num_dofs,cumulative_time(2,:),validation_time_range_1,3)
plot_error_bars(ax,num_dofs,cumulative_time(1,:),static_data_time_range_1,4)
hold(ax,"off")

legend(ax,"\{1,6\}-ROM Validation","\{1,6\}-ROM Creation","\{1\}-ROM Validation","\{1\}-ROM Creation","Location","northwest")
ax = set_x_labels(ax);
%-------------------


%create inserts
sim_id = 1;

insert_indicies = [1,length(Size_Data(1).num_dofs)];

num_inserts = length(insert_indicies);
memory_data = Size_Data(sim_id).free_memory;
Memory_Time = time_transform(Size_Data(sim_id),1);
% ax_insert = nexttile([1,2]);
for iInsert = 1:num_inserts
    ax_insert = nexttile;
    insert_index = insert_indicies(iInsert);

    cumulative_memory_time = zeros(4,1);
    cumulative_memory_time(:) = cumulative_memory_time(:)+ Memory_Time.total_time(1,insert_index);
    cumulative_memory_time(2:end) = cumulative_memory_time(2:end) + Memory_Time.validation_time(1,insert_index);
    cumulative_memory_time(3:end) = cumulative_memory_time(3:end) + Memory_Time.total_time(2,insert_index);
    cumulative_memory_time(4:end) = cumulative_memory_time(4:end) + Memory_Time.validation_time(2,insert_index);

    ax_insert = create_insert(ax_insert,memory_data{insert_index},cumulative_memory_time);

    box(ax_insert,"on")
    dofs = add_comma(Memory_Time.num_dofs(insert_index));
    title(ax_insert,dofs + " DoFs")
    ax_insert.XTickLabelRotation = 0;

    ylabel({"Memory","(GB)"})
    ax_insert.YLabel.VerticalAlignment = "baseline";

    xlabel("Time (mins)")
    ax_insert.XLabel.VerticalAlignment = "baseline";

    % save_fig(fig_insert,"insert_" + iInsert);
end


save_fig(fig,fig_name);


%---
function Data = time_transform(Data,scale_factor)
fields = fieldnames(Data);
num_fields = size(fields,1);
num_repeats = size(Data,2);
for iField = 1:num_fields
    field = fields{iField};
    if ~endsWith(field,"time")
        continue
    end
    for iRepeat = 1:num_repeats
        Data(iRepeat).(field) = Data(iRepeat).(field)*scale_factor;
    end
end


end

function plot_polyshape(ax,x,y,colour)
poly_style = {"FaceAlpha",1,"FaceColor",get_plot_colours(colour)};

x = [x(1),x,x(end)];
y = [0,y,0];

poly = polyshape(x,y,"Simplify",false);
plot(ax,poly,poly_style{:})
end
%---------------
function [Data_1,Data_2] = split_size_data(Data)
    Data_1 = Data;
    Data_2 = Data;

    field_names = fields(Data);
    num_fields = size(field_names,1);
    num_repeats = size(Data,2);
    for iField = 1:num_fields
        field_name = field_names{iField};
        if ~endsWith(field_name,"time")
            continue
        end
        for iRepeat = 1:num_repeats
            data = Data(iRepeat).(field_name);
            Data_1(iRepeat).(field_name) = data(1,:);
            Data_2(iRepeat).(field_name) = data(2,:);
        end
    end

end



function [Data_Mean,Data_Range] = get_mean_data(Data)

fields = fieldnames(Data);

num_fields = size(fields,1);
for iField = 1:num_fields
    field = fields{iField};
    if any(field == ["seed_sizes","num_dofs","free_memory"])
        continue
    end

    field_data = {Data.(field)};
    repeat_length = cellfun(@(x)length(x),field_data);
    seed_index_limit = min(repeat_length);
    field_data = cellfun(@(x) x(:,1:seed_index_limit),field_data,"UniformOutput",false);
    if size(field_data{1},1) > 1
        field_data = cellfun(@(x) sum(x,1),field_data,"UniformOutput",false);
    end
    field_data = vertcat(field_data{:});
    if any(any(isnan(field_data) | field_data < 0))

        negative_col_index = find(any(field_data < 0));
        for iCol = 1:length(negative_col_index)
            col_index = negative_col_index(iCol);
            col_data = field_data(:,col_index);
            col_data(col_data < 0) = col_data(col_data < 0) + 24*60; %assuming minutes
            field_data(:,col_index) = col_data;
        end


        nan_col_index = find(any(isnan(field_data)));
        for iCol = 1:length(nan_col_index)
            warning("NaN time recorded")
            col_index = nan_col_index(iCol);
            nan_col = field_data(:,col_index);
            if all(isnan(nan_col))
                nan_col(:) = 0;
            else
                nan_col(:) = mean(nan_col(~isnan(nan_col)));
            end

            field_data(:,col_index) = nan_col;
        end
    end
    mean_data = mean(field_data,1);
    % for iSeed = 1:size(mean_data,2)
    %     license_problem_index = field_data(:,iSeed) > 2*mean_data(iSeed);
    %     if any(license_problem_index)
    %         mean_data(iSeed) = mean(field_data(~license_problem_index,iSeed),1);
    %     end
    % end
    Data_Mean.(field) = mean_data;
    Data_Range.(field) = [min(field_data,[],1);max(field_data,[],1)]-Data_Mean.(field);
end

end


function title = get_title(num_workers)
number_words = ["One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten"];
if ~isstring(num_workers)
    numer_word = number_words(num_workers);
else
    numer_word = num_workers;
    num_workers = inf;
end

title = numer_word + " parallel worker";
if num_workers > 1
    title = title + "s";
end

end


function ax = create_insert(ax,Memory_Data,cumulative_time)
memory_style = {"Color","k","LineWidth",0.2};
SAMPLE_PERIOD = 1;
MAX_MEMORY = 31.2;
MIN_MEMORY = 8;

free_memory = Memory_Data.data;

memory = MAX_MEMORY - free_memory;
num_points = size(memory,1);
time = linspace(0,Memory_Data.duration,num_points);
% time = 0:1:(SAMPLE_PERIOD*(num_points-1));
time = time/60;

plot(ax,time,memory,memory_style{:})
ylim(ax,[MIN_MEMORY*0.9,MAX_MEMORY])
xlim(ax,[0,max(time(end),cumulative_time(end))])


add_time_markers(ax,cumulative_time)

x_ticks = [0,cumulative_time'];
xticks(ax,x_ticks);

num_sf = 2;
num_decimal_points = max(num_sf - ceil(log10(cumulative_time(end))),0);

xtickformat(ax,"%."+ num_decimal_points +"f")

x_labels = xticklabels(ax);
x_labels(1) = {'0'};
x_labels(2:(end-1)) = {''};

xticklabels(ax,x_labels);


% ytickformat(ax,'%g GB')

y_ticks = [MIN_MEMORY,MAX_MEMORY];
yticks(ax,y_ticks);
end

function add_time_markers(ax,cumulative_time)
span_style = {"LineWidth",3};
colour_order = [4,3,2,1,5];

cumulative_time = [0;cumulative_time];

marker_height = ones(1,2)*ax.YLim(1);
num_parts = size(cumulative_time,1) -1 ;
hold(ax,"on")
for iTime = 1:num_parts 
    time_span = cumulative_time(iTime:(iTime+1));
    plot(time_span,marker_height,"Color",get_plot_colours(colour_order(iTime)),span_style{:})
end
hold(ax,"off")
end



function ax = set_x_labels(ax)
dof_range = [105765,1006740];
range_multiplier = [-1,+1]*25000;
xlim(ax,dof_range + range_multiplier)
x_ticks = [1,5,10]*1e5;
xticks(ax,x_ticks)
x_labels = cellfun(@(x_tick) add_comma(x_tick),num2cell(x_ticks'));

xticklabels(ax,x_labels);


end

function num_out = add_comma(num_in)
java_formater=java.text.DecimalFormat;
num_out= string(java_formater.format(num_in));
end