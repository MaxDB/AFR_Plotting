clear
close all
fig_name = "two_mode_validation_error";

%------------------------------------------
figs = open_local_figures(["two_mode_validation_error_base","two_mode_validation_amp_backbone_base","two_mode_validation_phy_backbone_base","two_mode_energy_base"]);
fig_error = figs{1};
fig_amp_bb = figs{2};
fig_phy_bb = figs{3};
fig_energy_bb = figs{4};
%------------------------------------------
fig = figure;
tiles = tiledlayout(4,1);
tiles.TileSpacing = "none";

ax_error = nexttile;
ax_amp = nexttile;
ax_physical = nexttile;
ax_energy = nexttile;




copyobj(fig_amp_bb.Children.Children(1).Children,ax_amp)
copyobj(fig_error.Children.Children.Children,ax_error)
copyobj(fig_phy_bb.Children(2).Children,ax_physical)
copyobj(fig_energy_bb.Children(2).Children,ax_energy)
%------------------------------------------
box(ax_error,"on")
box(ax_amp,"on")
box(ax_physical,"on")
box(ax_energy,"on")

x_ticks = ax_amp.XTickLabel;
x_ticks(:) = {' '};

ax_error.YScale = "log";
yticks(ax_error,[1e-5,1e-3,1e-1])
ax_error.XTickLabel = x_ticks;
ax_amp.XTickLabel = x_ticks;
ax_physical.XTickLabel = x_ticks;

ylim(ax_error,[1e-6,1])
ylim(ax_amp,[-0.5,14.5])
ylim(ax_physical,[-0.5,19])
ylim(ax_energy,[0,0.9])

xlabel(ax_energy,"Frequency (rad/s)")
ylabel(ax_error,"\epsilon")
ylabel(ax_amp,"Q_{11}\times10^{-10}")
ylabel(ax_physical,"Max(\bf{x}\rm{_{mid}) \fontname{Times New Roman}(μm)}")
ylabel(ax_energy,"Energy (nJ)")

x_lim = [2.625e6,2.754e6];
xlim(ax_error,x_lim)
xlim(ax_amp,x_lim)
xlim(ax_physical,x_lim)
xlim(ax_energy,x_lim)


lines = findobj(ax_physical,"type","line");
arrayfun(@(line) set(line,"YData",line.YData*1e4),lines)
lines = findobj(ax_amp,"type","line");
arrayfun(@(line) set(line,"YData",line.YData*1e10),lines)

%------------------------------------------
keep_modes = [5,11,13];
mode_colour_map = [4,6,2];
num_modes = size(keep_modes,2);

for iColour = 1:10
    swap_colours(ax_error,iColour,"gray");
end
for iMode = 1:num_modes
    kept_mode = keep_modes(iMode);
    lines = ax_error.findobj("Tag",string(kept_mode));
    set(lines,"Color",get_plot_colours(mode_colour_map(iMode)))
end
% 
swap_colours(ax_amp,1,6);
swap_colours(ax_amp,[0,0,0],5);
% 
swap_colours(ax_physical,1,6);
swap_colours(ax_physical,[0,0,0],5);
% 
swap_colours(ax_energy,1,6);
swap_colours(ax_energy,[0,0,0],5);

%------------------------------------------
save_fig(fig,fig_name)
