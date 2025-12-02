clear 
close all

fig_name = "stress_manifold_comp";


labels = ["$\mathcal W_{\mathcal R_1}$";
          "$\mathcal W_{\mathcal R_2}$";
          "$\tilde{\mathbf x}^*(t)$"];



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")