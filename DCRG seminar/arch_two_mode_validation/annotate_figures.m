clear 
close all

fig_name = "arch_validation_two";


labels = ["$\{1,6,5\}$";
          "$\{1,6,11\}$";
          "$\{1,6,13\}$";]

% fig_name = "validation_error_single";
% 
% 
% labels = {"Mode 6";
%           "Mode 5";
%           "Other modes"};

%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")