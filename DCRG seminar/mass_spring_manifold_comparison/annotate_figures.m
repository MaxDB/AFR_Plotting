clear 
close all

fig_name = "manifold_comparison";


% labels = ["3","text";
%           "3","text";
%           "$\mathcal W_{\mathcal R_2}$","label";
%           "$\mathcal V_{\mathbf r_2^*(t_3)}$","label"
%           "$\hat{\mathbf x}^*(t)$","label";  
%           "$\tilde{\mathbf x}^*(t)$","label";
%           "$\hat{\mathbf x}^*(t_3)$","label";  
%           "$\tilde{\mathbf x}^*(t_3)$","label"];

labels = {"Example orbit";
          "Validation orbit";
          "Two mode ROM configurations";
          "Validation manifold"};
%-----------------------------
figs = open_local_figures(fig_name+"_export");
fig = figs{1};
%-----------------------------
num_labels = size(labels,1);
for iLabel = 1:num_labels
    draw_annotation(fig,labels(iLabel,:));
end
%-----------------------------
export_fig(fig,fig_name + "_annotated","inherit")