clear 
close all

fig_name = "arch_time_complexity_4";

labels = {
    "","legend";
    "insert_1","insert";
    "","arrow";
    "insert_2","insert";
    "","arrow"
};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")