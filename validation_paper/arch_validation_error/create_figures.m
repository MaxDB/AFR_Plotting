clear
close all
fig_name = "validation_error";

%------------------------------------------
figs = open_local_figures(["validation_error_base","amp_backbone_base"]);
fig_error = figs{1};
fig_amp_bb = figs{2};
%------------------------------------------
fig = figure;
ax = axes(fig);
base_position = ax.Position;
delete(ax);

ax_height = base_position(4)/2;

base_position(4) = ax_height;
ax_amp = axes(fig,"Position",base_position);

amp_position = base_position;
amp_position(2) = amp_position(2) + ax_height;
ax_error = axes(fig,"Position",amp_position);


copyobj(fig_amp_bb.Children.Children(1).Children,ax_amp)
copyobj(fig_error.Children.Children,ax_error)
%------------------------------------------
box(ax_error,"on")
box(ax_amp,"on")

x_ticks = ax_amp.XTickLabel;
x_ticks(:) = {' '};

ax_error.YScale = "log";
yticks(ax_error,[1e-5,1e-3,1e-1])
ax_error.XTickLabel = x_ticks;
ylim(ax_error,[1e-6,1])

xlabel(ax_amp,"Frequency (rad/s)")
ylabel(ax_error,"$\epsilon$","Interpreter","latex")
ylabel(ax_amp,"$Q_6\times\!\! 10^{-7}$","Interpreter","latex")

x_lim = [2.64e6,2.74e6];
xlim(ax_error,x_lim)
xlim(ax_amp,x_lim)
%------------------------------------------
ax_amp = swap_colours(ax_amp,1,5);
ax_amp = swap_colours(ax_amp,[0,0,0],1);


ax_error = swap_colours(ax_error,1,4);

%------------------------------------------
save_fig(fig,fig_name)
