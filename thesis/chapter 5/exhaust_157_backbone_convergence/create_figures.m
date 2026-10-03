clear
close all

fig_name = "157_backbone_convergence";
%----
figs = open_local_figures(fig_name + "_base");
fig = figs{1};

tiles = findobj(fig,"type","tiledlayout");
tiles.Padding ="compact";
tiles.TileSpacing = "compact";

%-
axs = findobj(fig,"type","axes");

local_ax = axs(1);
global_ax = axs(2);

lines = findobj(global_ax,"type","line");
leg_lines = [];
for iIteration = 1:5
    iteration_lines = findobj(lines,"Tag","it: " + iIteration);
    it_colour = get_plot_colours(iIteration);
    x_markers = findobj(iteration_lines,"MarkerFaceColor",get_plot_colours(3));
    set(x_markers,"visible","off")
    

    bp_markers = findobj(iteration_lines,"MarkerEdgeColor","w");
    pd_markers = findobj(iteration_lines,"MarkerFaceColor","w");

    set(iteration_lines,"Color",it_colour)
    set(bp_markers,"MarkerFaceColor",it_colour,"MarkerEdgeColor","w","MarkerSize",5)
    set(pd_markers,"MarkerEdgeColor",it_colour,"MarkerFaceColor","w","MarkerSize",5)
   

    uistack(iteration_lines,"top")
    leg_lines(iIteration) = iteration_lines(1);

    markers = findobj(iteration_lines,"Marker","o");
    uistack(markers,"top")
end
leg = legend(global_ax,leg_lines,["Step 1","Step 2","Step 3","Step 4","Step 5"],"location","south west","numcolumns",2);
leg.IconColumnWidth = leg.IconColumnWidth/2;
%--
lines = findobj(local_ax,"type","line");
leg_lines = [];
for iIteration = 1:6
    iteration_lines = findobj(lines,"Tag","it: " + iIteration);
    it_colour = get_plot_colours(iIteration);
    x_markers = findobj(iteration_lines,"MarkerFaceColor",get_plot_colours(3));
    set(x_markers,"visible","off")
    

    bp_markers = findobj(iteration_lines,"MarkerEdgeColor","w");
    pd_markers = findobj(iteration_lines,"MarkerFaceColor","w");

    set(iteration_lines,"Color",it_colour)
    set(bp_markers,"MarkerFaceColor",it_colour,"MarkerEdgeColor","w","MarkerSize",5)
    set(pd_markers,"MarkerEdgeColor",it_colour,"MarkerFaceColor","w","MarkerSize",5)
   

    uistack(iteration_lines,"top")
    only_lines = findobj(iteration_lines,"Marker","none","LineStyle","-");
    leg_lines(iIteration) = only_lines(1);

    markers = findobj(iteration_lines,"Marker","o");
    uistack(markers,"top")
end
leg = legend(local_ax,leg_lines,["Step 1","Step 2","Step 3","Step 4","Step 5","Step 6"],"location","south west","numcolumns",2);
leg.IconColumnWidth = leg.IconColumnWidth/2;

%-
y_lim = [0,5.5];
x_lim = [1075,1300];

ylim(global_ax,y_lim)
xlim(global_ax,x_lim)
ylim(local_ax,y_lim)
xlim(local_ax,x_lim)

%--



%------------------------------------------
save_fig(fig,fig_name)

