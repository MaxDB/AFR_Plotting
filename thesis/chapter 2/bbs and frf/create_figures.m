clear
close all
fig_name = "freq_amp_plot";
%--------
figs = open_local_figures("freq_amp_plot_base");
fig = figs{1};

ax = findobj(fig,"type","axes");

box(ax,"on")
xlabel(ax,"Frequency")
ylabel(ax,"Amplitude")

natural_frequency = [316.228,547.72];
xticks(ax,natural_frequency);
xticklabels(ax,{'$\omega_1$','$\omega_2$'});
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex'; % latex for x-axis

yticks(ax,[])

ylim(ax,[0,0.01])
xlim(ax,[280,650])


lines = findobj(ax,"type","line");
set(lines,"LineWidth",2);

lines(1).Color = get_plot_colours(2);
lines(2).Color = get_plot_colours(0);
lines(3).Color = get_plot_colours(0);


%--------
save_fig(fig,fig_name)

