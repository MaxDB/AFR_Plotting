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
ax = axes(fig);
base_position = ax.Position;
delete(ax);

ax_height = base_position(4)/3;

base_position(4) = ax_height;
ax_energy = axes(fig,"Position",base_position);

amp_position = base_position;
amp_position(2) = amp_position(2) + ax_height;
ax_amp = axes(fig,"Position",amp_position);

energy_position = base_position;
energy_position(2) = energy_position(2) + 2*ax_height;
ax_error = axes(fig,"Position",energy_position);

copyobj(fig_amp_bb.Children.Children(1).Children,ax_amp)
copyobj(fig_energy_bb.Children(2).Children,ax_energy)
copyobj(fig_error.Children.Children,ax_error)
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
ylim(ax_amp,[-0.1e-5,1.4e-5])


xlabel(ax_energy,"Frequency (rad/s)")
ylabel(ax_error,"$\epsilon$","Interpreter","latex")
ylabel(ax_amp,"$Q_3\ \times\!\! 10^{-5}$","Interpreter","latex")
ylabel(ax_energy,"Energy (mJ)")

x_lim = [395,425];
xlim(ax_error,x_lim)
xlim(ax_energy,x_lim)
xlim(ax_amp,x_lim)
%------------------------------------------
ax_error = fix_colours(ax_error);
ax_energy = fix_colours(ax_energy);
ax_amp = fix_colours(ax_amp);

%------------------------------------------
save_fig(fig,fig_name)




function ax = fix_colours(ax)
bb_colour = get_plot_colours(1);
h_3_colour = get_plot_colours(2);
h_6_colour = get_plot_colours(5);


lines = findobj(ax,"Color",get_plot_colours(2));
arrayfun(@(line) set(line,"Color",h_6_colour),lines);

lines = findobj(ax,"Color",get_plot_colours(1));
arrayfun(@(line) set(line,"Color",h_3_colour),lines);

lines = findobj(ax,"Color",[0,0,0]);
arrayfun(@(line) set(line,"Color",bb_colour),lines);


end