clear
close all
fig_name = "validation";
figs = open_local_figures(fig_name + "_base");

%--------------------------------------------------
fig = figs{1};
ax = findobj(fig,"type","axes");
title(ax,[])
lines = allchild(ax);
arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines)
ylabel(ax,"Energy (mJ)")
ylim(ax,[0,50])

special_marker = findobj(lines,"Color",get_plot_colours(3));
set(special_marker,"Visible","off")


x_range = [1.6,2.1];
y_range = [1,15];
aspect_ratio = (diff(x_range)/diff(ax.XLim)) / (diff(y_range)/diff(ax.YLim));
width = 0.3;
height = width/aspect_ratio;

create_zoomed_insert(ax,[0.075,0.4,width,height],x_range,y_range)
%--
save_fig(fig,fig_name);
