clear
close all
fig_name = "validation_error";

%------------------------------------------
figs = open_local_figures("validation_error_base");
fig = figs{1};
%------------------------------------------
ax = gca;
title(ax,[])
ylim(ax,[1e-6,1])
xlim(ax,[365,580])

%---
mode_3_lines = findobj(ax.Children,"Color",get_plot_colours(3));
mode_6_lines = findobj(ax.Children,"Color",get_plot_colours(6));
lines = findobj(ax.Children,"Type","Line");

set(lines,"Color",get_plot_colours("grey"))
set(mode_3_lines,"Color",get_plot_colours(2))
set(mode_6_lines,"Color",get_plot_colours(5))
%------------------------------------------
save_fig(fig,fig_name)