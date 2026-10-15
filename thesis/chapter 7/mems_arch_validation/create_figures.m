clear
close all
fig_name = "validation";

figs = open_local_figures(fig_name + "_base");

%--------------------------------------------------
fig = figs{1};
ax = findobj(fig,"type","axes");
title(ax,[])
delete(findobj(fig,"type","legend"))


%--

lines = findobj(ax,"type","line");

set(lines(1),"Color",get_plot_colours(4))
set(lines(2),"Color",get_plot_colours(4))
set(lines(3:13),"Color",get_plot_colours(3))
set(lines(14:end),"Color",get_plot_colours(0))

uistack(lines(1:2),"bottom")

xlim(ax,[2.55,2.8]*1e6)
ylim(ax,[0,1.6])

ylabel(ax,"Energy (nJ)")

hold(ax,"on")
plot(ax,2686390,0.32,"^","MarkerSize",4,"MarkerFaceColor","w","MarkerEdgeColor",get_plot_colours(3),"LineWidth",1.5)
plot(ax,2705470,0.082,"^","MarkerSize",4,"MarkerFaceColor","w","MarkerEdgeColor",get_plot_colours(3),"LineWidth",1.5)
hold(ax,"off")
%--



x_range = [2.676,2.681]*1e6;
y_range = [0.18,0.41];
aspect_ratio = (diff(x_range)/diff(ax.XLim))/(diff(y_range)/diff(ax.YLim));
width = 0.09;

zoomed_ax = create_zoomed_insert(ax,[0.14,0.14,width,width/aspect_ratio],x_range,y_range);


%--
save_fig(fig,fig_name);
