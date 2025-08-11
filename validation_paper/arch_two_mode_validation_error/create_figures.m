clear
close all
fig_name = "two_mode_validation_error";

%------------------------------------------
figs = open_local_figures(["two_mode_validation_error_base","two_mode_validation_amp_backbone_base","two_mode_validation_phy_backbone_base"]);
fig_error = figs{1};
fig_amp_bb = figs{2};
fig_phy_bb = figs{3};
%------------------------------------------
fig = figure;
ax = axes(fig);
base_position = ax.Position;
delete(ax);

ax_height = base_position(4)/3;

base_position(4) = ax_height;
ax_physical = axes(fig,"Position",base_position);

amp_position = base_position;
amp_position(2) = amp_position(2) + ax_height;
ax_amp = axes(fig,"Position",amp_position);

error_position = amp_position;
error_position(2) = error_position(2) + ax_height;
ax_error = axes(fig,"Position",error_position);


copyobj(fig_amp_bb.Children.Children(1).Children,ax_amp)
copyobj(fig_error.Children.Children.Children,ax_error)
copyobj(fig_phy_bb.Children(2).Children,ax_physical)
%------------------------------------------
box(ax_error,"on")
box(ax_amp,"on")
box(ax_physical,"on")

x_ticks = ax_amp.XTickLabel;
x_ticks(:) = {' '};

ax_error.YScale = "log";
yticks(ax_error,[1e-5,1e-3,1e-1])
ax_error.XTickLabel = x_ticks;
ax_amp.XTickLabel = x_ticks;
ylim(ax_error,[1e-6,1])
ylim(ax_amp,[-0.5e-10,1.5e-9])
ylim(ax_physical,[0,1.9e-3])

xlabel(ax_physical,"Frequency (rad/s)")
ylabel(ax_error,"\epsilon")
ylabel(ax_amp,"Q_{11}\times10^{-10}")
ylabel(ax_physical,"Max \bf{x}\rm{_{mid} (μm)}")

x_lim = [2.625e6,2.754e6];
xlim(ax_error,x_lim)
xlim(ax_amp,x_lim)
xlim(ax_physical,x_lim)

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

%------------------------------------------
save_fig(fig,fig_name)
