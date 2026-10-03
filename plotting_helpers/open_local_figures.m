function [figs,fig_names] = open_local_figures(fig_names)
FIGURE_DIRECTORY = "figures\";

if nargin == 0
    fig_names = string(ls(FIGURE_DIRECTORY + "*.fig"));
end

if contains(fig_names,"*")
    fig_names = string(ls(FIGURE_DIRECTORY + fig_names));
end


if size(fig_names,2) > size(fig_names,1)
    fig_names = fig_names';
end


num_figs = size(fig_names,1);
figs = cell(num_figs,1);

for iFig = 1:num_figs
    figs{iFig} = openfig(FIGURE_DIRECTORY + fig_names(iFig,:));
end


end