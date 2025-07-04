clear
close all
fig_name = "arch_validation_error";

%------------------------------------------
figs = open_local_figures("amp_backbone_base");

fig = figs{1};

delete(findobj(fig,"Type","legend"))
%------------------------------------------
ax = findobj(fig,"Type","axes");


swap_colours(ax(1),1,5)
swap_colours(ax(2),1,5)

lines = findobj(fig,"Type","line");
set(lines,"LineWidth",2);

%------------------------------------------
save_fig(fig,fig_name)
