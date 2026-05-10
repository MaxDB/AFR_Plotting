clear 
close all

fig_name = "validated_backbone";


labels = {"$\mathcal R_1:\mathcal R_2$" + newline + "validation","label";
          "$\mathcal R_2$-ROM","label";
          "$\mathcal R_1$-ROM","label";
          "3 rad/s",{"text","rotation",-90}};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")