clear 
close all

fig_name = "model_limit_contour";

labels = ["Tested SEPs";
          "Known loadcases";
          "Model limit";
          "Estimated limit"];


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")