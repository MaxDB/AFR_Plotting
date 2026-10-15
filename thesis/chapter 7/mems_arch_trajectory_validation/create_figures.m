clear
close all
fig_name = "trajectory_validation";
figs = open_local_figures(fig_name + "_base");

%--------------------------------------------------
fig = figs{1};

ax = findobj(fig,"type","axes");
box(ax,"on")
xlabel(ax,"\tau")
ylabel(ax,"\it{x(t)} \rm{(μm)}")

lines = allchild(ax);
arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines)

xlim(ax,[0,1500])
ylim(ax,[-2,2])
%--
save_fig(fig,fig_name);

