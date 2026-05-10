clear 
close all

fig_name = "overall_error";

labels = {
    "$\bar{\epsilon}_{(3,3)}$","label";
    "$\bar{\epsilon}_{f:3}$","label";
    "$\bar{\epsilon}_{d:3}$","label";
    "Limit",{"text","Rotation",90};
    "Maximum allowable error","text"
    };


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")