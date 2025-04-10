clear 
close all

fig_name = "energy_backbone";

labels = ["$\mathcal \{1\}$-ROM"];


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