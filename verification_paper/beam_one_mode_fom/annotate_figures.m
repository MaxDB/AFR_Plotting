clear 
close all

fig_name = "beam_one_mode_comp";

labels = {
    "FOM","label";
    "n_f = 7","label";
    "n_f = 3","label";
    "n_d = 5","label";
    "","label"
    };


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")