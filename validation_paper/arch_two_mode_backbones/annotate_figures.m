clear 
close all

fig_name = "two_mode_physical_backbone";

labels = {"2.66 Mrad/s",{"text","Rotation",90};
          "$\mathcal \{1\}$-ROM","label";
          "$\mathcal \{1,6\}$-ROM","label";
          "$\mathcal \{1\}:\{1,6\}$","label";
          };


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")