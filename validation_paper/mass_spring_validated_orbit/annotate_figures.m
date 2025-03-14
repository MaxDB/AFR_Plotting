clear 
close all

fig_name = "validation_orbit";



num_labels = ["1","text";
          "2","text";
          "3","text";
          "4","text";
          "5","text"];

labels = ["","arrow";
          "$\mathbf h(t_3)$","text";  
          "$q_1$","text";
          "$\dot{q}_1$","text";
          "$\mathbf r_2^*(t)$","label";
          "$\mathbf r_2^*(t) + \mathbf h(t)$","label";
          num_labels];
%-----------------------------
figs = open_local_figures(fig_name+"_export");
fig = figs{1};
%-----------------------------
num_labels = size(labels,1);
for iLabel = 1:num_labels
    draw_annotation(fig,labels(iLabel,:));
end
%------------------------------
ann_pane = get_annotation_handles(fig);
anns = ann_pane.Children;
arrow = anns(16);
angle = atan2(arrow.Position(4),arrow.Position(3));
arrow_label = anns(15);
arrow_label.Rotation = angle*180/pi;
%------------------------------
export_fig(fig,fig_name + "_annotated","inherit")