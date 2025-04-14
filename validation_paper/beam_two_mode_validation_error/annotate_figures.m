clear 
close all

fig_name = "two_mode_validation_error";


labels = ["$\{1,3\}:\{1,3,6\}$";
          "$\{1,3\}:\{1,3,x\}$"];
%-----------------------------
figs = open_local_figures(fig_name+"_export");
fig = figs{1};
%-----------------------------
num_labels = size(labels,1);
for iLabel = 1:num_labels
    draw_annotation(fig,labels(iLabel,:));
end
%------------------------------
export_fig(fig,fig_name + "_annotated","inherit")