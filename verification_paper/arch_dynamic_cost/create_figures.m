clear
% close all
fig_name = "arch_dynamic_cost";
num_workers = 4;


%layout
fig = figure;
ax = gca();

%--------------------------------------------------
data_directory = get_project_path + "\examples\size_test";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

data_path = "data\size_data\workers_" + num_workers;
Dynamic_Data = data_dir_execute(@load,data_path+"\dynamic_data.mat","Dynamic_Data");
Dynamic_Data = Dynamic_Data.Dynamic_Data;

[Dynamic_Data_Mean,Dynamic_Data_Range] = get_mean_data(Dynamic_Data);

num_dofs = Dynamic_Data(1).num_dofs;
num_seeds = size(num_dofs,2);

cumulative_time = zeros(4,num_seeds);
cumulative_time(:,:) = cumulative_time(:,:)+ Dynamic_Data_Mean.eom_construction_time;
cumulative_time(2:end,:) = cumulative_time(2:end,:)+ Dynamic_Data_Mean.backbone_1_time;
cumulative_time(3:end,:) = cumulative_time(3:end,:)+ Dynamic_Data_Mean.ic_time;
cumulative_time(4:end,:) = cumulative_time(4:end,:)+ Dynamic_Data_Mean.backbone_2_time;
% cumulative_time = cumulative_time/60;


hold(ax,"on")
plot_polyshape(ax,num_dofs,cumulative_time(4,:),1)
plot_polyshape(ax,num_dofs,cumulative_time(3,:),2)
plot_polyshape(ax,num_dofs,cumulative_time(2,:),3)
plot_polyshape(ax,num_dofs,cumulative_time(1,:),4)
hold(ax,"off")

box(ax,"on")
xlabel(ax,"DoFs")
ylabel(ax,"Time (s)")
xlim(ax,[min(num_dofs),max(num_dofs)])
ylim(ax,[0,40])
% title(ax,get_title(num_workers))
% 
% 
hold(ax,"on")
plot_error_bars(ax,num_dofs,cumulative_time(4,:),Dynamic_Data_Range.eom_construction_time,1)
plot_error_bars(ax,num_dofs,cumulative_time(3,:),Dynamic_Data_Range.backbone_1_time,2)
plot_error_bars(ax,num_dofs,cumulative_time(2,:),Dynamic_Data_Range.ic_time,3)
plot_error_bars(ax,num_dofs,cumulative_time(1,:),Dynamic_Data_Range.backbone_2_time,4)
hold(ax,"off")

leg = legend("Second branch","IC sweep","First branch","EoM construction time","Location","northwest","NumColumns",2);
leg.IconColumnWidth = 10;
%-------------------
ax = set_x_labels(ax);
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

function [Data_Mean,Data_Range] = get_mean_data(Data)
fields = fieldnames(Data);
num_fields = size(fields,1);
for iField = 1:num_fields
    field = fields{iField};
    if any(field == ["seed_sizes","num_dofs","free_memory"])
        continue
    end
    
    field_data = {Data.(field)};
    data_shape = size(field_data{1});
    num_repeats = size(field_data,2);
    num_seeds = data_shape(2);
    if data_shape(1) > 1
        for iRepeat = 1:num_repeats
           field_data{iRepeat} = reshape(field_data{iRepeat},1,[]); 
        end
    end
    field_data = vertcat(field_data{:});
    if any(any(isnan(field_data)))
        warning("NAN time recorded")
        nan_col_index = find(any(isnan(field_data)));
        for iCol = 1:length(nan_col_index)
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

   
    mean_field_data = mean(field_data,1);
    if data_shape(1) > 1
        mean_field_data = reshape(mean_field_data,data_shape);
    end

    
    Data_Mean.(field) = mean_field_data;
    if data_shape(1) == 1
          Data_Range.(field) = [min(field_data,[],1);max(field_data,[],1)]-Data_Mean.(field);
    end
   
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