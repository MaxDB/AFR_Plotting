clear 
close all

fig_name = "exhaust_validated_backbone";


labels = ["$\{1\}$-ROM";
          "$\{1,7\}$-ROM";
          "$\{1,5,7\}$-ROM";
          "$\{1,5,6,7\}$-ROM";
          "$\{1,7\}$";
          "$\{1,5,7\}$";
          "$\{1,5,6,7\}$";
          "$\{1,5,6,7,16\}$";
          "$\{1,5,6,7,18\}$"];
%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")