clear 
close all

fig_name = "force2";

labels = {
    "$f_2 = 0$",{"text","Rotation",34}
};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")