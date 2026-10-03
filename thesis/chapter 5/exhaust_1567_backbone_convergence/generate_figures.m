clear
close all

fig_name = "1567_backbone_convergence";
%----
[phy_figs,phy_fig_names] = open_local_figures("x_*");


%-
fig = figure;


local_fig = phy_figs{1};



% local
ax = axes;
box(ax,"on")
hold(ax,"on")

local_lines = findobj(local_fig,"type","Line");
for iIteration = 1:6
    tag_name = "Iteration: " + iIteration;
    lines = findobj(local_lines,"Tag",tag_name);
    set(lines,"Tag","it: " + (iIteration + 1))
    copyobj(lines,ax)
end

xlabel("Frequency (rad/s)")
ylabel("Max centre deflection (mm)")
close(local_fig)

lines = findobj(ax,"type","line");
arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines)
%------------------------------------------
save_fig(fig,fig_name+"_base")

