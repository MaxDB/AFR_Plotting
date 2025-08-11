clear 
close all

fig_name = "two_mode_final_error";


labels = ["$\{1,6\}:\{1,5,6,11,13\}$"];
%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")