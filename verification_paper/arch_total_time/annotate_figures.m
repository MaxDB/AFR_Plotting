clear 
close all

fig_name = "beam_bb";

labels = {
    "FOM","label";
    "$\{1,3,5\}$-ROM","label";
};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")