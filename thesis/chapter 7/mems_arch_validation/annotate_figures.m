clear 
close all


fig_name = "validation";


labels = {"$\{1,6\}:\{1,6,11\}$",{"text","Rotation",90}};



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")