clear
close all
fig_name = "beam_three_mode";



%layout
fig = figure;
ax = gca();


%-----
sep_colours = get_plot_colours([3,2,1]);
point_style = {"Marker","o","LineStyle","none","LineWidth",0.5,"MarkerSize",4,"MarkerEdgeColor","k"};
legend_style = {"LineWidth",0.5,"MarkerSize",4,"MarkerEdgeColor","k","Marker","o","LineStyle","-"};
camera_position = [5488.83608035488	-6722.55663357721	12233.1849434598];
%--------------------------------------------------
data_directory = get_project_path + "\examples\JH_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Static_Data = data_dir_execute(@load_static_data,"JH_beam_2d_135");

Rom = data_dir_execute(@Reduced_System,Static_Data);


%-----
point_sep_ratios = Static_Data.unit_sep_ratios;
adjacent_sep_ratios = get_adjacent_sep_ratios(point_sep_ratios);
unit_force_ratios = [point_sep_ratios,adjacent_sep_ratios];
[~,~,reorder_index] = uniquetol(unit_force_ratios', "ByRows",1);
removal_indicies = false(1,size(unit_force_ratios,2));
for iIndex = 1:max(reorder_index)
    matching_indices = reorder_index == iIndex;
    if nnz(matching_indices) > 1
        repeated_index = find(matching_indices);
        repeated_index(1) = [];
        removal_indicies(repeated_index) = 1;
    end
end
unit_force_ratios(:,removal_indicies) = [];

scaled_force_ratios = scale_sep_ratios(unit_force_ratios,Static_Data.Model.calibrated_forces);
num_verified_seps = size(unit_force_ratios,2);



%-----
%tested SEPs
hold(ax,"on")
sep_order = 0;
order_index = [0,6,26,144,512];
for iSep = 1:num_verified_seps
    if any(iSep-1 == order_index)
        sep_order = sep_order + 1;
    end
    tested_sep = scaled_force_ratios(:,iSep);
    [disp_sep,lambda_sep] = find_sep_rom(Rom,tested_sep,100);





    force_sep = lambda_sep.*tested_sep;


 
    plot3(force_sep(1,[1,end]),force_sep(2,[1,end]),force_sep(3,[1,end]),"Color",sep_colours(sep_order,:))
end
hold(ax,"off")

%----
box(ax,"on")

%---
order_index = {1:54,55:134};
num_sep_order = length(order_index);
hold(ax,"on")
for iOrder = 1:num_sep_order
    sep_index = order_index{iOrder};
    plot3(Static_Data.restoring_force(1,sep_index),Static_Data.restoring_force(2,sep_index),Static_Data.restoring_force(3,sep_index),"MarkerFaceColor",sep_colours(iOrder,:),point_style{:})
        
end
hold(ax,"off")
%--
ax.CameraPosition = camera_position;
% zlim([0,1500]);
zlabel("$\tilde{\mathbf f}_3$","Interpreter","latex")
xlabel("$\tilde{\mathbf f}_1$","Interpreter","latex")
ylabel("$\tilde{\mathbf f}_2$","Interpreter","latex")


legend_lines = [];
hold(ax,"on")
for iLine = 1:3
    line_colour = sep_colours(iLine,:);

legend_lines(iLine) = plot3(0,0,0,"MarkerFaceColor",line_colour,"Color",line_colour,legend_style{:}); %#ok<SAGROW>
end
hold(ax,"off")

leg = legend(legend_lines,["1st","2nd","3rd"]);
leg.IconColumnWidth = 15;



%---
save_fig(fig,fig_name)
%------------------

