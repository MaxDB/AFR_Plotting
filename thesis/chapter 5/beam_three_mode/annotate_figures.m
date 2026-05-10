clear 
close all

fig_name = "beam_three_mode";

labels = {
          "Tested SEPs";
          "Static loadcases"
          };


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")