clear
close all
fig_name = "validation";
fig_num =4;
figs = open_local_figures(fig_name + "_" + fig_num + "_base");

%--------------------------------------------------
fig = figs{1};
ax = findobj(fig,"type","axes");
title(ax,[])
delete(findobj(fig,"type","legend"))

lines = findobj(ax,"Type","line");

%--

lines = findobj(ax,"type","line");
line_bb = findobj(lines,"tag","backbone");
%--
switch fig_num
    case 1
        arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines);
        ylabel(ax,"\it{X}_{\rm{122}} / \it{h}","Interpreter","tex")

        ylim(ax,[0,0.3])
        xlim(ax,[300,600])

        line_1001 = findobj(lines,"tag","1001");
        line_2 = findobj(lines,"tag","2");
        line_3 = findobj(lines,"tag","3");

        set(line_bb,"Color",get_plot_colours(2));
        set(line_2,"Color",get_plot_colours(3));
        set(line_3,"Color",get_plot_colours(4));
        set(line_1001,"Color",get_plot_colours(5));

    case 2
        arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines);
        ylabel(ax,"\it{X}_{\rm{122}} / \it{h}","Interpreter","tex")

        ylim(ax,[0,0.4])
        xlim(ax,[300,600])

        line_2 = findobj(lines,"tag","2");
        line_3 = findobj(lines,"tag","3");

        set(line_bb,"Color",get_plot_colours(5));
        set(line_2,"Color",get_plot_colours(3));
        set(line_3,"Color",get_plot_colours(4));

    case 3
        ylabel(ax,"Validation error")
        
        line_3 = findobj(lines,"tag","3");
        line_5 = findobj(lines,"tag","5");
        line_6 = findobj(lines,"tag","6");
        line_8 = findobj(lines,"tag","8");

        set(line_3,"Color",get_plot_colours(4));
        set(line_5,"Color",get_plot_colours(6));
        set(line_6,"Color",get_plot_colours(7));
        set(line_8,"Color",get_plot_colours(8));

        line_4 = findobj(lines,"tag","4");
        line_7 = findobj(lines,"tag","7");
        line_9 = findobj(lines,"tag","9");
        line_10 = findobj(lines,"tag","10");

        set(line_4,"Color",get_plot_colours("grey"));
        set(line_7,"Color",get_plot_colours("grey"));
        set(line_9,"Color",get_plot_colours("grey"));
        set(line_10,"Color",get_plot_colours("grey"));

        ylim(ax,[1e-5,1])
        xlim(ax,[300,600])

    case 4
        arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines);
        ylabel(ax,"\it{X}_{\rm{122}} / \it{h}","Interpreter","tex")

        ylim(ax,[0,0.3])
        xlim(ax,[340,440])

        line_2 = findobj(lines,"tag","2");
        line_3 = findobj(lines,"tag","3");

        set(line_bb,"Color",get_plot_colours(2));
        set(line_2,"Color",get_plot_colours(3));
        set(line_3,"Color",get_plot_colours(4));

end
x_range = [404,410];
y_range = [0.186,0.216];
aspect_ratio = (diff(x_range)/diff(ax.XLim))/(diff(y_range)/diff(ax.YLim));
width = 0.3;

zoomed_ax = create_zoomed_insert(ax,[0.07,0.43,width,width/aspect_ratio],x_range,y_range);
%--
save_fig(fig,fig_name+"_" + fig_num);
