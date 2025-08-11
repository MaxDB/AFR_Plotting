clear 
close all

fig_name = "verification_seps_3d";

labels = ["1^{st}";
          "2^{nd}"];


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")