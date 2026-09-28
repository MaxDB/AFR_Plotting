clear
close all
fig_name = "isola_frc";
figs = open_local_figures(fig_name + "_base");

%--------------------------------------------------
fig = figs{1};
delete(findobj(fig,"type","legend"))
ax = findobj(fig,"type","axes");
lines = allchild(ax);
arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines)


rom_lines = findobj(lines,"Color",get_plot_colours(1));
fom_lines = findobj(lines,"Color",get_plot_colours(2));

swap_colours(rom_lines,1,2)
swap_colours(fom_lines,2,"grey")

fom_markers = findobj(fom_lines,"-not","Marker","none");
set(fom_markers,"Visible","off")
set(fom_lines,"LineStyle","--")
uistack(fom_lines,"top")

rom_markers = findobj(rom_lines,"-not","Marker","none"); 
set(rom_markers,"MarkerEdgeColor",get_plot_colours(2))

rom_bp = findobj(rom_markers,"Marker","o");
set(rom_bp,"MarkerSize",5)
set(rom_bp,"MarkerEdgeColor","w","MarkerFaceColor",get_plot_colours(2),"LineWidth",0.5)


rom_sn = findobj(rom_markers,"Marker","x");
isola_sn = rom_sn(1);
isola_sn.XData([2,3,5,6]) = [];
isola_sn.YData([2,3,5,6]) = [];

special_marker = findobj(lines,"Color",get_plot_colours(3));
set(special_marker,"Visible","off")

x_range = [1.6,2.1];
y_range = [1,7.5];
aspect_ratio = (diff(x_range)/diff(ax.XLim)) / (diff(y_range)/diff(ax.YLim));
width = 0.4;
height = width/aspect_ratio;

create_zoomed_insert(ax,[0.15,0.3,width,height],x_range,y_range)

ylabel(ax,"Energy (mJ)")

save_fig(fig,fig_name) 


