clear 
close all

% fig_name = "validation_error";
% 
% 
% labels = ["$\{1\}:\{1,6\}$";
%           "$\{1\}:\{1,5\}$";
%           "$\{1\}$-ROM";
%           "$\{1\}:\{1,x\}$"];

fig_name = "validation_error_single";


labels = {"Mode 6";
          "Mode 5";
          "Other modes"};

%-----------------------------
figs = open_local_figures(fig_name+"_export");
fig = figs{1};
%-----------------------------
num_labels = size(labels,1);
for iLabel = 1:num_labels
    draw_annotation(fig,labels(iLabel,:));
end
%------------------------------
export_fig(fig,fig_name + "_annotated","inherit")