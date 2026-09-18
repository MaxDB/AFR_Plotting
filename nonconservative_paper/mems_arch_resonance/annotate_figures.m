clear 
close all

fig_name = "resonance";

labels = {"$\{1,6\}$-ROM","label";
    "$\{1,6\}:\{1,6,11\}$","label";
    "$\epsilon=1$",{"text","Rotation",-5};
    "$\epsilon=0.8$",{"text","Rotation",-5};
    "$\epsilon=0.6$",{"text","Rotation",-5};
    "$\epsilon=0.4$",{"text","Rotation",-5};
    "$\epsilon=0.2$",{"text","Rotation",-5};
    "$\epsilon=0$",{"text","Rotation",-5}};



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")