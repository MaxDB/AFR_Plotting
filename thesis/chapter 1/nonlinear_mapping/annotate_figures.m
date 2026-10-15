clear 
close all

fig_name = "nonlinear_mapping_2d";

labels = ["Periodic orbit"];


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")