function insert_ax = create_zoomed_insert(ax,position,x_range,y_range)
insert_ax = axes("Position",position);
box(insert_ax,"on")
copyobj(ax.Children,insert_ax)
xlim(insert_ax,x_range)
ylim(insert_ax,y_range)

insert_ax.XTickLabel = [];
insert_ax.YTickLabel = [];
insert_ax.XTick = [];
insert_ax.YTick = [];


box_style = {"LineWidth",0.5,"Color","k"};
hold(ax,"on")
plot(ax,[x_range(1),x_range(1)],y_range,box_style{:},"Tag","zoom_box")
plot(ax,x_range,[y_range(2),y_range(2)],box_style{:},"Tag","zoom_box")
plot(ax,[x_range(2),x_range(2)],y_range,box_style{:},"Tag","zoom_box")
plot(ax,x_range,[y_range(1),y_range(1)],box_style{:},"Tag","zoom_box")
hold(ax,"off")
for iLine = 1:4
    ax.Children(1).Annotation.LegendInformation.IconDisplayStyle = "off";
    uistack(ax.Children(1),"bottom")
end
end