clear 
close all

fig_name = "beam_one_mode";

labels = {"Static loadcases","label";
          "Maximum allowable error","text"};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")