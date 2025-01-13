function save_fig(fig,fig_name)
if ~isfolder("figures")
    mkdir("figures")
end
saveas(fig,"figures\" + fig_name)
end