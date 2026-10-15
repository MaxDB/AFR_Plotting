clear 
close all

fig_name = "validation_40";
labels = ["$\{1\}:\{1,4\}$";
          "$\{1\}:\{1,x\}$"];



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")