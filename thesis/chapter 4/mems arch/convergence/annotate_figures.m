clear 
close all


fig_name = "fe_convergence";


labels = {"Converged to 3 s.f.",{"text","Rotation",0};
    "$\omega_1^2$","label";
    "$\omega_6^2$","label";
    "","arrow"
    };


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")