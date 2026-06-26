clear
close all
fig_name = "validation_20";
figs = open_local_figures(fig_name + "_base");

%--------------------------------------------------
fig = figs{1};
ax = findobj(fig,"type","axes");
xlim(ax,[0.9945,1.001])
ylim(ax,[1e-3,1e1])

xlabel(ax,"$\Omega/\omega_1$","Interpreter","latex")



for iLine = [1,2,3,5:10]
    ax = swap_colours(ax,iLine,"grey");
end
ax = swap_colours(ax,4,2);

lines = findobj(ax,"Type","line");
set(lines,"LineWidth",1.5)
%---
save_fig(fig,fig_name)
