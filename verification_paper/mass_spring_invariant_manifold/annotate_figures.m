clear 
close all

fig_name = "invariant_manifold_2d";

labels = {
    "$L_2$",{"text","Rotation",35};
    "$L_2$",{"text","Rotation",-14};
};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")