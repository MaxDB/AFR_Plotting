clear 
close all

fig_name = "arch_time_complexity_4";

labels = {
    "","arrow";
    "","arrow"
};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")