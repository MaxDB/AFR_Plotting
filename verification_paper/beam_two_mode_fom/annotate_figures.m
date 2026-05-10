clear 
close all

fig_name = "beam_two_mode_comp";

labels = {
    "$1-R^2 = 5\times\!10^{-6}$","text";
    "$1-R^2 = 1\times\!10^{-6}$","text";
    "$1-R^2 = 1\times\!10^{-8}$","text";
    };


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")