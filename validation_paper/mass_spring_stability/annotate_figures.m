clear 
close all

fig_name = "stability";

labels = ["$\mathcal R_{2}$-ROM";
          "$\mathcal R_{1}:\mathcal R_{2}$ validation";];


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