clear 
close all


fig_name = "trajectory_validation";



labels = ["$\{1\}$-ROM";
    "$\{1\}:\{1,6\}$"
    ];



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")