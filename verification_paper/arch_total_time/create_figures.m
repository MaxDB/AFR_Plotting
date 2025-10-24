clear
% close all
fig_name = "arch_total_time";
job_workers = [1,2,4,6];
job_colour = [4,3,2,1];

%layout
fig = figure;
ax = gca();

%--------------------------------------------------
data_directory = get_project_path + "\examples\size_test";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

plot_style = {"LineWidth",2};
num_sims = size(job_workers,2);
legend_lines = [];
for iJob = 1:num_sims
    plot_colour = get_plot_colours(job_colour(iJob));

    sim_workers = job_workers(iJob);
    data_path = "data\size_data\workers_" + sim_workers;
    Size_Data = data_dir_execute(@load,data_path+"\size_data.mat","Size_Data");
    Size_Data = Size_Data.Size_Data;
    Size_Data = time_transform(Size_Data,1/60);

    [Size_Data_Mean,Size_Data_Range] = get_mean_data(Size_Data);

    num_dofs = Size_Data(1).num_dofs;
    num_seeds = size(num_dofs,2);

    Size_Data_Mean.total_time;

    % cumulative_time = cumulative_time/60;
    plotted_points = length(Size_Data_Mean.total_time);

    hold(ax,"on")
    line = plot(ax,num_dofs(1:plotted_points),Size_Data_Mean.total_time,"Color",plot_colour,plot_style{:});
    hold(ax,"off")
    legend_lines = [legend_lines,line];

    box(ax,"on")
    xlabel(ax,"DoFs")
    ylabel(ax,"Time (mins)")
    ylim(ax,[0,ax.YLim(2)])


    hold(ax,"on")
    plot_error_bars(ax,num_dofs,Size_Data_Mean.total_time,Size_Data_Range.total_time,job_colour(iJob))
    hold(ax,"off")
end

legend(legend_lines,"One Worker","Two Workers","Four Workers","Six Workers","Location","northwest")
ax = set_x_labels(ax);
%-------------------

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
    field_data = cellfun(@(x) x(1:seed_index_limit),field_data,"UniformOutput",false);
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
    for iSeed = 1:size(mean_data,2)
        license_problem_index = field_data(:,iSeed) > 2*mean_data(iSeed);
        if any(license_problem_index)
            mean_data(iSeed) = mean(field_data(~license_problem_index,iSeed),1);
        end
    end
    Data_Mean.(field) = mean_data;
    Data_Range.(field) = [min(field_data,[],1);max(field_data,[],1)]-Data_Mean.(field);
end
end


function plot_error_bars(ax,x,y,y_range,colour)
line_style = {"Color","k"};
marker_style = {"Marker","o","MarkerEdgeColor","k","MarkerFaceColor",get_plot_colours(colour),"MarkerSize",4};
tip_style = {"Marker","_","Color","k","MarkerSize",5};

x_fractional_length = 0.03;
x_range = diff(ax.XLim);
bar_length = x_range*x_fractional_length;


xlim(ax,ax.XLim)
ylim(ax,ax.YLim)



y_max = y_range(2,:) + y;
max_diff = diff([y;y_max])./y;

y_min = y_range(1,:) + y;
min_diff = diff([y_min;y])./y;


num_points = size(x,2);
for iPoint = 1:num_points
    if iPoint > length(y_min)
        continue
    end
    x_line = [x(iPoint),x(iPoint)];
    y_line = [y_min(iPoint),y_max(iPoint)];
    plot(ax,x_line,y_line,"-",line_style{:})
    

    
    y_max_bar = y_max(iPoint);
    y_min_bar = y_min(iPoint);
    
    plot(ax,x(iPoint),y_max_bar,tip_style{:})
    plot(ax,x(iPoint),y_min_bar,tip_style{:})
    plot(ax,x(iPoint),y(iPoint),marker_style{:})
end

end

function title = get_title(num_workers)
number_words = ["One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten"];
numer_word = number_words(num_workers);

title = numer_word + " worker";
if num_workers > 1
    title = title + "s";
end

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