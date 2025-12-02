clear 
close all

fig_name = "two_mode_backbone";

labels = ["$\mathcal \{1,3\}$-ROM"];


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")