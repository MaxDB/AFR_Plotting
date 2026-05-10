clear 
close all

fig_name = "two_mode_resonance_error";


labels = ["$\{1,3\}$-ROM";
          "$\{1,3\}:\{1,3,6\}$";
          "$\{1,3\}:\{1,3,x\}$"];
%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")