clear 
close all

fig_name = "stability";

labels = ["$\mathcal R_{2}$-ROM";
          "$\mathcal R_{1}:\mathcal R_{2}$ validation";];


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")