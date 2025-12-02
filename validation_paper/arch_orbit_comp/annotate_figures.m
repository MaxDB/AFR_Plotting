clear 
close all

% fig_name = "orbit_comp_one_mode";
% labels = {
%           "$\mathcal \{1\}$-ROM","label";
%           "$\mathcal \{1\}:\{1,6\}$ Validation","label"};
% 
fig_name = "orbit_comp_two_mode";
labels = {"","arrow";
          "$\mathcal \{1,6\}$-ROM","label";
          "$\mathcal \{1\}:\{1,6\}$ Validation","label"};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")
