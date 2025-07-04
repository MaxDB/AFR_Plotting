clear
close all
fig_name = "two_mode_resonance_error";

%------------------------------------------
figs = open_local_figures(["two_mode_resonance_error_base","two_mode_resonance_amp_backbone_base","two_mode_resonance_energy_backbone_base"]);
fig_error = figs{1};
fig_amp_bb = figs{2};
fig_energy_bb = figs{3};
%------------------------------------------
fig = figure;
ax = axes(fig);
base_position = ax.Position;
delete(ax);

ax_height = base_position(4)/3;

base_position(4) = ax_height;
ax_energy = axes(fig,"Position",base_position);

amp_position = base_position;
amp_position(2) = amp_position(2) + ax_height;
ax_amp = axes(fig,"Position",amp_position);

error_position = base_position;
error_position(2) = error_position(2) + 2*ax_height;
ax_error = axes(fig,"Position",error_position);


copyobj(fig_amp_bb.Children.Children(1).Children,ax_amp)
copyobj(fig_error.Children.Children.Children,ax_error)
copyobj(fig_energy_bb.Children(2).Children,ax_energy)
%------------------------------------------
box(ax_error,"on")
box(ax_amp,"on")
box(ax_energy,"on")

x_ticks = ax_amp.XTickLabel;
x_ticks(:) = {' '};

ax_error.YScale = "log";
yticks(ax_error,[1e-5,1e-3,1e-1])
ax_error.XTickLabel = x_ticks;
ax_amp.XTickLabel = x_ticks;
ylim(ax_energy,[-0.1e-5,1.4e-5])

xlabel(ax_energy,"Frequency (rad/s)")
ylabel(ax_error,"\epsilon","Interpreter","tex")
ylabel(ax_amp,"Q_6 \times10^{-7}","Interpreter","tex")
ylabel(ax_energy,"Energy (mJ)")

ylim(ax_energy,[0,5e-3])

x_lim = [395,425];
xlim(ax_error,x_lim)
xlim(ax_amp,x_lim)
xlim(ax_energy,x_lim)
%------------------------------------------
ax_amp = swap_colours(ax_amp,[0,0,0],2);
ax_amp = swap_colours(ax_amp,1,5);

ax_error = swap_colours(ax_error,2,5);
ax_error = swap_colours(ax_error,1,9);

ax_energy = swap_colours(ax_energy,1,5);
ax_energy = swap_colours(ax_energy,[0,0,0],2);

%------------------------------------------
save_fig(fig,fig_name)
