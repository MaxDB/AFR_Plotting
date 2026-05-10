clear 
close all

fig_name = "manifold_comparison";


labels = [
          "$\mathcal W_{\mathcal R_2}$","label";
          "$\mathcal V_{\mathbf r_2^*(t_1)}$","label"
          "$\hat{\mathbf x}^*(t)$","label";  
          "$\tilde{\mathbf x}^*(t)$","label";
          "$\hat{\mathbf x}^*(t_1)$","label";  
          "$\tilde{\mathbf x}^*(t_1)$","label"];


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")