clear
close all
fig_name = "validation_error";


%------------------------------------------
figs = open_local_figures("validation_error_base");
fig = figs{1};
%------------------------------------------
ax = gca;
title(ax,[])

%------------------------------------------
save_fig(fig,fig_name)