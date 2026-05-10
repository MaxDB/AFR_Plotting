clear 
close all

fig_name = "validation_error";


labels = ["$\{1,5,6\}$";
          "$\{1,6,11\}$";
          "$\{1,6,13\}$"];

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