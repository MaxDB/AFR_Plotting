clear
close all
fig_name = "two_mode_final_error";

%------------------------------------------
figs = open_local_figures(["two_mode_validation_error_base","two_mode_validation_energy_backbone_base","two_mode_validation_phy_backbone_base"]);
fig_error = figs{1};
fig_energy_bb = figs{2};
fig_phy_bb = figs{3};
%------------------------------------------
fig = figure;
ax = axes(fig);
base_position = ax.Position;
delete(ax);

ax_height = base_position(4)/3;

base_position(4) = ax_height;
ax_physical = axes(fig,"Position",base_position);

amp_energy = base_position;
amp_energy(2) = amp_energy(2) + ax_height;
ax_energy = axes(fig,"Position",amp_energy);

error_position = amp_energy;
error_position(2) = error_position(2) + ax_height;
ax_error = axes(fig,"Position",error_position);


copyobj(fig_energy_bb.Children(2).Children,ax_energy)
copyobj(fig_error.Children.Children,ax_error)
copyobj(fig_phy_bb.Children(2).Children,ax_physical)
%------------------------------------------
box(ax_error,"on")
box(ax_energy,"on")
box(ax_physical,"on")

x_ticks = ax_energy.XTickLabel;
x_ticks(:) = {' '};

ax_error.YScale = "log";
yticks(ax_error,[1e-5,1e-3,1e-1])
ax_error.XTickLabel = x_ticks;
ax_energy.XTickLabel = x_ticks;
ylim(ax_error,[1e-6,1])
% ylim(ax_energy,[-0.5e-10,1.5e-9])
ylim(ax_physical,[0,1.9e-3])

xlabel(ax_physical,"Frequency (rad/s)")
ylabel(ax_error,"\epsilon")
ylabel(ax_energy,"Energy (nJ)")
ylabel(ax_physical,"Max \bf{x}\rm{_{mid} (μm)}")

x_lim = [2.625e6,2.754e6];
xlim(ax_error,x_lim)
xlim(ax_energy,x_lim)
xlim(ax_physical,x_lim)

%------------------------------------------
swap_colours(ax_error,1,4);

%
swap_colours(ax_energy,[0,0,0],5);
swap_colours(ax_energy,1,4);
% 
swap_colours(ax_physical,[0,0,0],5);
swap_colours(ax_physical,1,4);

%------------------------------------------
save_fig(fig,fig_name)
