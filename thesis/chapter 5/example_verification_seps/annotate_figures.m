clear 
close all

fig_name = "verification_seps";

labels = ["1^{st}";
          "2^{nd}";
          "3^{rd}"];


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")