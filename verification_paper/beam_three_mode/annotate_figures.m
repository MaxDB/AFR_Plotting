clear 
close all

fig_name = "beam_two_mode";

labels = {
          "Maximum allowable error",{"text","Rotation",-6.5};
          "Static loadcases","label"};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")