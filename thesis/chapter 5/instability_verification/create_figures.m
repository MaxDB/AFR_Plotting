clear
close all
%-----
plot_num = 2;
fig_name = "unstable_verification";


fig_name = fig_name + "_" + plot_num;
figs = open_local_figures(fig_name+"_base");
fig = figs{1};
%--

axs = findobj(fig,"type","axes");

%disp
ax = axs(1);
box(ax,"on")

xlabel(ax,"$r_1$","Interpreter","latex")
ylabel(ax,"$r_2$","Interpreter","latex")

%force
ax = axs(2);
box(ax,"on")

xlabel(ax,"$\tilde{f}_1$",Interpreter="latex")
ylabel(ax,"$\tilde{f}_2$",Interpreter="latex")

%---
lines = findobj(fig,"type","line");
set(lines,"LineWidth",2)

%----------------------
save_fig(fig,fig_name);