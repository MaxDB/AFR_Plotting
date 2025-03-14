function save_fig(fig,fig_name)
FIGURE_DIRECTORY = "figures\";
if ~isfolder(FIGURE_DIRECTORY)
    mkdir(FIGURE_DIRECTORY)
end
fig_names = ls(FIGURE_DIRECTORY + "*.fig");
num_figs = size(fig_names,1);
for iFig = 1:num_figs
    if startsWith(fig_names(iFig,:),fig_name)
        delete(FIGURE_DIRECTORY + strip(string(fig_names(iFig,:))))
    end
end
saveas(fig,FIGURE_DIRECTORY + fig_name)
end