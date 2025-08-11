clear 
close all

fig_name = "limit_contour";

labels = ["Actual limit";
          "Estimated limit"];


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")