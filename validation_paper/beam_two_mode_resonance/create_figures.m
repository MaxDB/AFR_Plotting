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
tiles = tiledlayout(3,1);
tiles.TileSpacing = "none";
ax_error = nexttile;
ax_amp = nexttile;
ax_energy = nexttile;



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
ylim(ax_error,[1e-6,2e-1])

ax_amp.XTickLabel = x_ticks;
amp_lines = findobj(ax_amp,"Type","Line");
arrayfun(@(line) set(line,"YData",line.YData*1e7),amp_lines)
ylim(ax_amp,[0.4,3.1])

energy_lines = findobj(ax_energy,"Type","Line");
arrayfun(@(line) set(line,"YData",line.YData*1e3),energy_lines)
ylim(ax_energy,[0,5.5])

xlabel(ax_energy,"Frequency (rad/s)")
ylabel(ax_error,"\epsilon","Interpreter","tex")
ylabel(ax_amp,"Q_6 \times10^{-7}","Interpreter","tex")
ylabel(ax_energy,"Energy (mJ)")


x_lim = [395,425];
xlim(ax_error,x_lim)
xlim(ax_amp,x_lim)
xlim(ax_energy,x_lim)
%------------------------------------------
ax_amp = swap_colours(ax_amp,[0,0,0],2);
ax_amp = swap_colours(ax_amp,1,5);

lines_6 = findobj(ax_error.Children,"Color",get_plot_colours(6));
set(ax_error.Children,"Color",get_plot_colours("grey"))
set(lines_6,"Color",get_plot_colours(5))

ax_energy = swap_colours(ax_energy,1,5);
ax_energy = swap_colours(ax_energy,[0,0,0],2);

%------------------------------------------
save_fig(fig,fig_name)
