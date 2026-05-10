clear
close all
fig_name = "three_mode_validation_error";

%------------------------------------------
figs = open_local_figures("three_mode_validation_error_base");
fig = figs{1};

%------------------------------------------

%------------------------------------------


ax_error = gca;
ax_error.YScale = "log";

ylim(ax_error,[1e-6,1])


xlabel(ax_error,"Frequency (rad/s)")
ylabel(ax_error,"\epsilon")

x_lim = [2.625e6,2.754e6];
xlim(ax_error,x_lim)

%------------------------------------------
keep_modes = [5,13];
mode_colour_map = [4,2];
num_modes = size(keep_modes,2);

for iColour = 1:10
    swap_colours(ax_error,iColour,"gray");
end
for iMode = 1:num_modes
    kept_mode = keep_modes(iMode);
    lines = ax_error.findobj("Tag",string(kept_mode));
    set(lines,"Color",get_plot_colours(mode_colour_map(iMode)))
    uistack(lines,"top")
end

%------------------------------------------
save_fig(fig,fig_name)
