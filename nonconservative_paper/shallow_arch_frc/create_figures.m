clear
close all
fig_name = "frc";
figs = open_local_figures(fig_name + "_base");

%--------------------------------------------------
fig = figs{1};
ax = findobj(fig,"type","axes");
xlim(ax,[0.9945,1.001])
ylim(ax,[0.03,0.16])

xlabel(ax,"$\Omega/\omega_1$","Interpreter","latex")
ylabel(ax,"max$(\phi_1q_1/H)$","Interpreter","latex")




hold(ax,"on")
leg_lines(1) = plot(ax,0,0,"Color",get_plot_colours(1));
leg_lines(2) = plot(ax,0,0,"Color",get_plot_colours(2));
hold(ax,"off")

leg = legend(leg_lines,"\{1\}-ROM","\{1,4\}-ROM","Location","southeast");
leg.IconColumnWidth = leg.IconColumnWidth/2;

lines = findobj(ax,"Type","line");
set(lines,"LineWidth",1.5)
%---
save_fig(fig,fig_name)
