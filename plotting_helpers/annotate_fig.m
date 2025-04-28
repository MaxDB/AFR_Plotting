function [fig,fig_name] = annotate_fig(fig_name,labels)


figs = open_local_figures(fig_name+"_export");
fig = figs{1};


menu_bar = get(fig,"MenuBar");
tool_bar = get(fig,"ToolBar");
set(fig,"MenuBar",'none');
set(fig,"ToolBar",'none')
% set(fig, 'DeleteFcn', @(object,event_data) close_figure(object,event_data));


num_labels = size(labels,1);

iLabel = 1;
num_annotations = zeros(num_labels+1,1);
annotations = get_annotation_handles(fig);
num_annotations(1) =  length(annotations.Children);
while iLabel <= num_labels
    
   

    annotation_progress = draw_annotation(fig,labels(iLabel,:));
    if fig.SelectionType == "alt"
        annotations = get_annotation_handles(fig);
        if annotation_progress == 0
            steps_back = 1;
        else
            steps_back = 0;
        end
        iLabel = iLabel - steps_back;
        if iLabel == 0
            iLabel = 1;
        end
        num_added_annotation = length(annotations.Children) - num_annotations(iLabel);
        delete(annotations.Children(1:num_added_annotation));

        
        fig.SelectionType = "normal";
        continue
    end
    annotations = get_annotation_handles(fig);
    num_annotations(iLabel+1) = length(annotations.Children);
    iLabel = iLabel + 1;    
    
    

end

fig_name = fig_name + "_annotated";

set(fig, 'DeleteFcn', '');

set(fig,"MenuBar",menu_bar);
set(fig,"ToolBar",tool_bar)

end


function close_figure(object,event_data)
    error("Figure closed")
end