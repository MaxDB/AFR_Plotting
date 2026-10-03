clear
close all

fig_name = "157_backbone_convergence";
%----
[phy_figs,phy_fig_names] = open_local_figures("x_*");


%-
fig = figure;
tiles = tiledlayout(1,2);

global_figs = [phy_figs{1:5}];
local_fig = phy_figs{6};

% global
ax = nexttile;
box(ax,"on")
hold(ax,"on")
num_global_figs = size(global_figs,2);
for iFig = 1:num_global_figs
    global_fig = global_figs(iFig);
    lines = findobj(global_fig,"type","Line");
    set(lines,"Tag","it: " + iFig)
    copyobj(lines,ax)
end
xlabel("Frequency (rad/s)")
ylabel("Max centre deflection (mm)")

lines = findobj(ax,"type","line");
arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines)

% local
ax = nexttile;
box(ax,"on")
hold(ax,"on")
for iFig = 1:1
    global_fig = global_figs(iFig);
    lines = findobj(global_fig,"type","Line");
    set(lines,"Tag","it: " + iFig)
    copyobj(lines,ax)
end

close(global_figs)

local_lines = findobj(local_fig,"type","Line");
for iIteration = 1:5
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

