clear
close all
fig_name = "two_mode_validation_error";

%------------------------------------------
figs = open_local_figures("two_mode_validation_error_base");
fig = figs{1};
%------------------------------------------
ax = gca;
title(ax,[])
ylim(ax,[1e-7,1])
xlim(ax,[365,580])


ax = swap_colours(ax,get_plot_colours(4),get_plot_colours(5));
ax = swap_colours(ax,get_plot_colours(8),get_plot_colours(9));

%------------------------------------------
save_fig(fig,fig_name)