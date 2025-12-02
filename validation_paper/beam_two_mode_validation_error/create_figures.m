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


lines_6 = findobj(ax,"Color",get_plot_colours(6));
set(ax.Children,"Color",get_plot_colours("grey"))
set(lines_6,"Color",get_plot_colours(5))

%------------------------------------------
save_fig(fig,fig_name)