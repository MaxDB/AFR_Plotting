clear 
close all

fig_name = "frc";
labels = ["$\kappa_2 = 20$";
    "$\kappa_2 = 40$"];



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")