clear 
close all

fig_name = "amp_dependence";

labels = {
    "Linear",{"text","rotation",90};
    "","arrow";
    "","arrow";
    "Hardening","text";
    "Softening","text"
};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")