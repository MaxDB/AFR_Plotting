clear
close all
fig_name = "two_mode_validation_error";


%------------------------------------------
figs = open_local_figures(fig_name + "_base");
fig = figs{1};
%------------------------------------------
ax = gca;
title(ax,[])
ylim(ax,[1e-6,1])
xlim(ax,[2.63e6,2.75e6])
%------------------------------------------
save_fig(fig,fig_name)