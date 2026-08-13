clear 
close all

fig_name = "modal_backbone";

labels = {
    "0.5 $\omega_6$",{"text","Rotation",90};
    "$\omega_1$",{"text","Rotation",90}
    };



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")