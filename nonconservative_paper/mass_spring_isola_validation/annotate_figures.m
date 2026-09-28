clear 
close all

fig_name = "validation";

labels = ["$\{1\}$-ROM";
    "$\{1\}:\{1,2\}$"];



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")