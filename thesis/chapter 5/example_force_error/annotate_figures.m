clear 
close all

fig_name = "force_error";

labels = {"Cubic model","label";
          "Quintic model","label";
          "Error","label";
          "Limit",{"text","Rotation",90}};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")