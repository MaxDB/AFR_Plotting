clear 
close all

fig_name = "validation_manifold";



labels = {"$\hat{\mathbf x}^*(t)$","label";
          "$\tilde{\mathbf x}^*(t)$","label";
          "$\mathcal V_{\mathbf r^*_2(t_1)}$",{"text","Rotation",7};
          "$\mathcal V_{\mathbf r^*_2(t_2)}$",{"text","Rotation",20};
          "$\mathcal V_{\mathbf r^*_2(t_3)}$",{"text","Rotation",28};
          "$\mathcal V_{\mathbf r^*_2(t_4)}$",{"text","Rotation",-5};
          "$\mathcal V_{\mathbf r^*_2(t_5)}$",{"text","Rotation",-13};
          "1","text";
          "2","text";
          "3","text";
          "4","text";
          "5","text";
          "2","text";
          "3","text";
          "4",{"text","Color",[89,128,122]/256};
          "5","text"};
%-----------------------------
figs = open_local_figures(fig_name+"_export");
fig = figs{1};
%-----------------------------
num_labels = size(labels,1);
for iLabel = 1:num_labels
    draw_annotation(fig,labels(iLabel,:));
end
%------------------------------
% ann_pane = get_annotation_handles(fig);
% anns = ann_pane.Children;
% four_text = anns(2);
% four_text.Color = [89,128,122]/256;
% %------------------------------
delete(fig.Children(1))
export_fig(fig,fig_name + "_annotated","inherit")