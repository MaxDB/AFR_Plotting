clear 
close all

fig_name = "energy_backbone";

labels = ["$\mathcal R_{1}$-ROM";
          "$\mathcal R_{2}$-ROM";
          "$\mathbf r_1^*$"];

%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")