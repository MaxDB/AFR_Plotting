clear 
close all

fig_name = "physical_backbone";

labels = ["$\mathcal \{1\}$-ROM"];



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")