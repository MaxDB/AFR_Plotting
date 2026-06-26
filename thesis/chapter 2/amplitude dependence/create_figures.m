clear
close all
fig_name = "amp_dependence";
%--------
figs = open_local_figures("amp_dependence_base");
fig = figs{1};

ax = findobj(fig,"type","axes");

box(ax,"on")
xlabel(ax,"Frequency")
ylabel(ax,"Amplitude")

natural_frequency = 1;
xticks(ax,natural_frequency);
xticklabels(ax,{'$\omega_n$'});
xaxisproperties= get(gca, 'XAxis');
xaxisproperties.TickLabelInterpreter = 'latex'; % latex for x-axis

yticks(ax,[])

ylim(ax,[0,0.15])


lines = findobj(ax,"type","line");
set(lines,"LineWidth",2);

lines(1).Color = get_plot_colours(1);
lines(2).Color = get_plot_colours(0);
lines(3).Color = get_plot_colours(3);

uistack(lines(2),"top")

%--------
save_fig(fig,fig_name)

