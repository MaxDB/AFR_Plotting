clear 
close all

fig_name = "orbit_stability";

labels = ["1";"2";"3";"4";"5";"6";"7"];


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")