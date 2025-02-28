function figs = open_local_figures(fig_names)
FIGURE_DIRECTORY = "figures\";

if nargin == 0
    fig_names = ls(FIGURE_DIRECTORY + "*.fig");
end

num_figs = size(fig_names,1);
figs = cell(num_figs,1);

for iFig = 1:num_figs
    figs{iFig} = openfig(FIGURE_DIRECTORY + fig_names(iFig,:));
end


end