clear 
close all

fig_name = "frequency_comb";

labels = {"","arrow";
    "","arrow";
    "$\frac{\Omega_{NS}}{\Omega}$","text"};



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")