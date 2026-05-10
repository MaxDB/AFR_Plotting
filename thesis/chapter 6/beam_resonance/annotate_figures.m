clear 
close all

fig_name = "resonance_error";


labels = ["$\{1\}:\{1,3\}$";
          "$\{1\}:\{1,6\}$";
          "$\{1\}$-ROM"];
%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")