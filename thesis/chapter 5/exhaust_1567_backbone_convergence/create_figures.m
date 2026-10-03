clear
close all

fig_name = "1567_backbone_convergence";
%----
figs = open_local_figures(fig_name + "_base");
fig = figs{1};


%-
ax = findobj(fig,"type","axes");


%--
lines = findobj(ax,"type","line");
leg_lines = [];
for iIteration = 2:7
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
    leg_lines(iIteration-1) = only_lines(1);

    markers = findobj(iteration_lines,"Marker","o");
    uistack(markers,"top")
end
leg = legend(ax,leg_lines,["Step 2","Step 3","Step 4","Step 5","Step 6","Step 7"],"location","south west","numcolumns",3);
leg.IconColumnWidth = leg.IconColumnWidth/2;

%-
y_lim = [0,5.5];
x_lim = [1100,1300];

ylim(ax,y_lim)
xlim(ax,x_lim)

%--



%------------------------------------------
save_fig(fig,fig_name)

