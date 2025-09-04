clear 
close all

fig_name = "beam_two_mode_comp";

labels = {
    "$R^2 = 1.000$","text";
    "$R^2 = 1.000$","text";
    "$R^2 = 1.000$","text";
    };


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")