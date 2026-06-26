clear 
close all

fig_name = "freq_amp_plot";

labels = {
    "forced response","label"
};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")