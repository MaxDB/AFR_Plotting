clear
close all

fig_name = "backbone_convergence";
%----
[energy_figs,energy_fig_names] = open_local_figures("e_*");
[phy_figs,phy_fig_names] = open_local_figures("x_*");


%-
fig = figure;
tiles = tiledlayout(1,2);

% Energy
ax = nexttile;
box(ax,"on")
hold(ax,"on")
num_energy_figs = size(energy_figs,1);
for iFig = 1:num_energy_figs
    energy_fig = energy_figs{iFig};
    lines = findobj(energy_fig,"type","Line");
    set(lines,"Tag","it: " + iFig)
    copyobj(lines,ax)
end
xlabel("Frequency (rad/s)")
ylabel("Energy (J)")
close(energy_figs{:})

% Physical displacement
ax = nexttile;
box(ax,"on")
hold(ax,"on")
num_phy_figs = size(phy_figs,1);
for iFig = 1:num_phy_figs
    phy_fig = phy_figs{iFig};
    lines = findobj(phy_fig,"type","Line");
    set(lines,"Tag","it: " + iFig)
    copyobj(lines,ax)
end
xlabel("Frequency (rad/s)")
ylabel("Max centre deflection (mm)")
close(phy_figs{:})

lines = findobj(ax,"type","line");
arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines)
%------------------------------------------
save_fig(fig,fig_name+"_base")

