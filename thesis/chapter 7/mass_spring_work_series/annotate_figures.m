clear 
close all

fig_name = "work_series";
labels = ["Energy gained","text";
    "Energy lost","text";
    "Net","text"];





%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")