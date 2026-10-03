clear 
close all

fig_name = "unstable_verification";

labels = ["1","text";
    "2","text";
    "3","text";
    "4","text";
    "5","text";
    "6","text"];


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")