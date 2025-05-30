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
ax = axes(fig);
base_position = ax.Position;
delete(ax);

ax_height = base_position(4)/3;

base_position(4) = ax_height;
ax_phy = axes(fig,"Position",base_position);

amp_position = base_position;
amp_position(2) = amp_position(2) + ax_height;
ax_amp = axes(fig,"Position",amp_position);

error_position = amp_position;
error_position(2) = error_position(2) + ax_height;
ax_error = axes(fig,"Position",error_position);


copyobj(fig_amp_bb.Children.Children(1).Children,ax_amp)
copyobj(fig_error.Children.Children,ax_error)
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
ylim(ax_phy,[0,2.4e-3])
ylim(ax_amp,[0,1.55e-7])

ax_amp.XTickLabel = x_ticks;

set_label(ax_phy,"x","Frequency (rad/s)")
set_label(ax_error,"y","\epsilon")
set_label(ax_amp,"y","Q_6 \times10^{-7}")
set_label(ax_phy,"y","max(\sl{x}\rm{) (}\rm{μ}\rm{m)}") %μ


x_lim = [2.64e6,2.74e6];
xlim(ax_error,x_lim)
xlim(ax_amp,x_lim)
xlim(ax_phy,x_lim)
%------------------------------------------
swap_colours(ax_amp,1,5);
swap_colours(ax_amp,[0,0,0],1);

swap_colours(ax_phy,1,5);
swap_colours(ax_phy,[0,0,0],1);


swap_colours(ax_error,1,4);

%------------------------------------------
save_fig(fig,fig_name)
