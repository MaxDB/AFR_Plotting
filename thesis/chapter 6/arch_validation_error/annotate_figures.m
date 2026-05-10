clear 
close all

fig_name = "validation_error";


labels = ["$\{1\}:\{1,6\}$";
          "$\{1\}:\{1,5\}$";
          "$\{1\}:\{1,11\}$";
          "$\{1\}:\{1,13\}$";
          "$\{1\}$-ROM";
          "$\{1\}:\{1,x\}$"];

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