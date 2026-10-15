clear
close all
fig_name = "frc";
fig_num =2;
figs = open_local_figures(fig_name + "_" + fig_num + "_base");

%--------------------------------------------------
fig = figs{1};
ax = findobj(fig,"type","axes");
delete(findobj(fig,"type","legend"))

lines = findobj(ax,"Type","line");
arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines);

ylabel(ax,"\it{X}_{\rm{122}} / \it{h}","Interpreter","tex")
%--
frc_markers = findobj(lines,"Marker","x","Color",get_plot_colours("grey"));


%--
switch fig_num
    case 1
        xlim(ax,[300,600])
        ylim(ax,[0,0.4])

        frc_markers.Marker = "none";
        frc_markers.LineStyle = "-";
    case 2
       xlim(ax,[300,600])
        ylim(ax,[0,0.4])

        frc_markers.Marker = "none";
        frc_markers.LineStyle = "--";
        uistack(frc_markers,"top")

        swap_colours(lines,get_plot_colours(3),get_plot_colours(0))
         swap_colours(lines,get_plot_colours(2),get_plot_colours(3))

    case 3
        xlim(ax,[300,600])
        ylim(ax,[0.5,1.4])

        frc_markers.Marker = "none";
        frc_markers.LineStyle = "--";
        uistack(frc_markers,"top")
end



%--
save_fig(fig,fig_name+"_" + fig_num);
