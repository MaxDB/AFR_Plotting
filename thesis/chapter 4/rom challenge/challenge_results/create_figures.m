clear
close all
fig_name = "rom_challenge_results";

%--------------------------------------------------
open("figures\disp_pp01_NNMs_4IMAC.fig")
disp_fig = gcf();
original_disp_ax = findobj(disp_fig,"type","axes");
disp_leg = findobj(disp_fig,"type","legend");

open("figures\energy_pp01_NNMs_4IMAC.fig")
energy_fig = gcf();
original_energy_ax = findobj(energy_fig,"type","axes");
energy_leg = findobj(energy_fig,"type","legend");
%---
fig = figure;
tiles = tiledlayout(fig,1,2);
tiles.Padding = "tight";
tiles.TileSpacing ="tight";

%disp
ax = nexttile;
copyobj(original_disp_ax.Children,ax)
view(ax,[90 -90])
box(ax,"on")
ylim(ax,[175,230])
xlim(ax,[0,6])
ylabel(ax,"Frequency (Hz)")
xlabel(ax,"Peak centre deflection (mm)")




%energy
ax = nexttile;
copyobj(original_energy_ax.Children,ax)
view(ax,[90 -90])
box(ax,"on")
ylim(ax,[175,230])
xlim(ax,[0,8])
ylabel(ax,"Frequency (Hz)")
xlabel(ax,"Energy (J)")


%---
ax = tiles.Children(2);
lines = ax.Children;
lines(6) = [];
leg = legend(flip(lines),"Location","north");
uistack(ax,"top")
uistack(leg,"top")

%----
save_fig(fig,fig_name)