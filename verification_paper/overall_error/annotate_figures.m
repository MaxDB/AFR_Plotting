clear 
close all

fig_name = "overall_error";

labels = {
    "$\epsilon_{(3,3)}$","label";
    "$\epsilon_{f:3}/\bar{\epsilon}_f$","label";
    "$\epsilon_{d:3}/\bar{\epsilon}_d$","label";
    "Limit",{"text","Rotation",90};
    "Maximum allowable error","text"
    };


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")