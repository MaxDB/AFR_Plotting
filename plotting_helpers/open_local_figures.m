function figs = open_local_figures
FIGURE_DIRECTORY = "figures\";

fig_names = ls(FIGURE_DIRECTORY + "*.fig");
num_figs = size(fig_names,1);
figs = cell(num_figs,1);

for iFig = 1:num_figs
    figs{iFig} = openfig(FIGURE_DIRECTORY + fig_names(iFig,:));
end


end