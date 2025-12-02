clear
close all
fig_name = "resonance_error";

plot_colours = dictionary(2,{get_plot_colours(5)},3,{get_plot_colours(4)});
%------------------------------------------
figs = open_local_figures(["resonance_error_base","resonance_amp_backbone_base","resonance_energy_backbone_base"]);
fig_error = figs{1};
fig_amp_bb = figs{2};
fig_energy_bb = figs{3};
%------------------------------------------
fig = figure;
tiles = tiledlayout(3,1);
ax_error = nexttile;
ax_amp = nexttile;
ax_energy = nexttile;

tiles.TileSpacing = "none";

copyobj(fig_amp_bb.Children.Children(1).Children,ax_amp)
copyobj(fig_energy_bb.Children(2).Children,ax_energy)
copyobj(fig_error.Children.Children.Children,ax_error)
%------------------------------------------
box(ax_error,"on")
box(ax_energy,"on")
box(ax_amp,"on")

x_ticks = ax_amp.XTickLabel;
x_ticks(:) = {' '};

ax_error.YScale = "log";
yticks(ax_error,[1e-5,1e-3,1e-1])
ax_error.XTickLabel = x_ticks;

ax_amp.XTickLabel = x_ticks;


energy_lines = findobj(ax_energy,"Type","Line");
arrayfun(@(line) set(line,"YData",line.YData*1000),energy_lines);
ylim(ax_energy,[0,6.5])

disp_lines = findobj(ax_amp,"Type","Line");
arrayfun(@(line) set(line,"YData",line.YData*1e5),disp_lines);
ylim(ax_amp,[-0.1,1.4])

ylim(ax_error,[8e-6,1])

xlabel(ax_energy,"Frequency (rad/s)")
ylabel(ax_error,"\epsilon","Interpreter","tex")
ylabel(ax_amp,"Q_3 \times10^{-5}","Interpreter","tex")
ylabel(ax_energy,"Energy (mJ)")



x_lim = [402,438];
xlim(ax_error,x_lim)
xlim(ax_energy,x_lim)
xlim(ax_amp,x_lim)
%------------------------------------------
ax_error = fix_colours(ax_error,[3,6]);
ax_energy = fix_colours(ax_energy,[1,2]);
ax_amp = fix_colours(ax_amp,[1,2]);

%------------------------------------------
save_fig(fig,fig_name)




function ax = fix_colours(ax,colour_nums)
bb_colour = get_plot_colours(1);
h_3_colour = get_plot_colours(2);
h_6_colour = get_plot_colours(5);


lines = findobj(ax,"Color",get_plot_colours(colour_nums(2)));
set(lines,"Color",h_6_colour)


lines = findobj(ax,"Color",get_plot_colours(colour_nums(1)));
set(lines,"Color",h_3_colour)

lines = findobj(ax,"Color",[0,0,0]);
set(lines,"Color",bb_colour)


end