clear 
close all

fig_name = "three_mode_physical_backbone";

labels = ["$\mathcal \{1,6,11\}$-ROM";
          ];


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")