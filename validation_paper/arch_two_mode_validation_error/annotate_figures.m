clear 
close all

fig_name = "two_mode_validation_error";


labels = ["$\{1,6\}$-ROM";
          "$\{1,6\}:\{1,5,6\}$";
          "$\{1,6\}:\{1,6,11\}$";
          "$\{1,6\}:\{1,6,13\}$";
          "$\{1,6\}:\{1,6,x\}$"];
%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")