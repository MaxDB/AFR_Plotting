clear
close all
fig_name = "validation";
fig_num =2;
figs = open_local_figures(fig_name + "_" + fig_num + "_base");

%--------------------------------------------------
fig = figs{1};
ax = findobj(fig,"type","axes");
title(ax,[])
delete(findobj(fig,"type","legend"))

lines = findobj(ax,"Type","line");
arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines);

ylabel(ax,"\it{X}_{\rm{248}} / \it{h}","Interpreter","tex")
%--

lines = findobj(ax,"type","line");
line_bb = findobj(lines,"tag","backbone");
%--
switch fig_num
    case 1
        ylim(ax,[0.5,1.4])
        xlim(ax,[300,600])

        line_1001 = findobj(lines,"tag","1001");
        line_2 = findobj(lines,"tag","2");

        set(line_bb,"Color",get_plot_colours(2));
        set(line_2,"Color",get_plot_colours(4));
        set(line_1001,"Color",get_plot_colours(5));

    case 2
        ylim(ax,[0.5,1.4])
        xlim(ax,[300,600])

        line_1001 = findobj(lines,"tag","1001");

        set(line_bb,"Color",get_plot_colours(4));
        set(line_1001,"Color",get_plot_colours(3));

    case 3

end



%--
save_fig(fig,fig_name+"_" + fig_num);
