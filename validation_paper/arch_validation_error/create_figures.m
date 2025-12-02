clear
close all
fig_name = "validation_error";

%------------------------------------------
figs = open_local_figures(["validation_error_base","amp_backbone_base","phy_amp_backbone_base"]);
fig_error = figs{1};
fig_amp_bb = figs{2};
fig_phy_amp_bb = figs{3};
%------------------------------------------
fig = figure;
tiles = tiledlayout(3,1);

ax_error = nexttile;
ax_amp = nexttile;
ax_phy = nexttile;

tiles.TileSpacing = "none";


copyobj(fig_amp_bb.Children.Children(1).Children,ax_amp)
copyobj(fig_error.Children.Children.Children,ax_error)
copyobj(fig_phy_amp_bb.Children(2).Children,ax_phy)
%------------------------------------------
box(ax_error,"on")
box(ax_amp,"on")
box(ax_phy,"on")

x_ticks = ax_phy.XTickLabel;
x_ticks(:) = {' '};

ax_error.YScale = "log";
yticks(ax_error,[1e-5,1e-3,1e-1])
ax_error.XTickLabel = x_ticks;
ylim(ax_error,[1e-6,2])
ylim(ax_phy,[0,2.4e-3]*1e3)
ylim(ax_amp,[-0.1,1.55])

ax_amp.XTickLabel = x_ticks;

set_label(ax_phy,"x","Frequency (rad/s)")
set_label(ax_error,"y","\epsilon")
set_label(ax_amp,"y","Q_6 \times10^{-7}")
set_label(ax_phy,"y","Max(\bf{x}\rm{_{mid}) \fontname{Times New Roman}(μm)}") %μ


x_lim = [2.66e6,2.722e6];
xlim(ax_error,x_lim)
xlim(ax_amp,x_lim)
xlim(ax_phy,x_lim)
%------------------------------------------
keep_modes = [5,6,11,13];
mode_colour_map = [4,3,6,2];
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
swap_colours(ax_amp,1,3);
swap_colours(ax_amp,[0,0,0],1);
% 
swap_colours(ax_phy,1,3);
swap_colours(ax_phy,[0,0,0],1);

%---

amp_lines = findobj(ax_amp,"Type","Line");
arrayfun(@(line) set(line,"YData",line.YData*1e7), amp_lines)

phy_lines = findobj(ax_phy,"Type","Line");
arrayfun(@(line) set(line,"YData",line.YData*1e3), phy_lines)


%------------------------------------------
save_fig(fig,fig_name)
