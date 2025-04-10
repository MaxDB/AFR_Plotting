clear 
close all

fig_name = "orbit_comp";


labels = ["$\mathcal W_{\mathcal R_1}$";
          "$\mathcal R_1:\mathcal R_2$ validation";
          "$\mathcal R_1$-ROM";
          "$\mathcal R_2$-ROM"];

%-----------------------------

figs = open_local_figures(fig_name+"_export");
fig = figs{1};
%-----------------------------
num_labels = size(labels,1);
for iLabel = 1:num_labels
    draw_annotation(fig,labels(iLabel));
end
%------------------------------
export_fig(fig,fig_name + "_annotated","inherit")