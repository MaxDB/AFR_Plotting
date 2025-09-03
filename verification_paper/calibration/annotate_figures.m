clear 
close all

fig_name = "calibration";

labels = {"Static loadcase","label";
          "Interpolation","label"};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")