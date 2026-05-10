clear 
close all

fig_name =  "arch_time_complexity";

labels = {
    "software crashes",{"text","Rotation",30};
    "","arrow"
};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")