clear 
close all

fig_name = "orbit_comp";


labels = ["$\mathcal W_{\mathcal R_1}$";
          "$\mathcal R_1:\mathcal R_2$ validation";
          "$\mathcal R_1$-ROM";
          "$\mathcal R_2$-ROM"];

%-----------------------------

%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")