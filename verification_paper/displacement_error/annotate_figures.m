clear 
close all

fig_name = "displacement_error";

labels = {
    "Second mode",{"text","Rotation",-35};
    "Cubic model","label";
    "Quintic model","label";
    "Error","label";
    "Limit",{"text","Rotation",90};
    "First mode","text"
    };


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")