clear 
close all

fig_name = "mass_spring_bb";

labels = {
    "$L_2$","text";
    "$\{1\}$-ICE","label";
    "$\{1\}$-ICE-IC","label";
    "FOM","label"
};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")