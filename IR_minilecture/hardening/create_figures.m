clear
close all
fig_name = "amp_dependence";
animation_state = 2;
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

ylim(ax,[0,1])
xlim(ax,[0.785,1.25])


lines = findobj(ax,"type","line");
set(lines,"LineWidth",2);

switch animation_state
    case 1

        set(lines(1),"Visible","off");
        set(lines(2),"Visible","off");

        set(lines(3),"Color",get_plot_colours(2),"LineStyle","-");
        set(lines(4),"Color",get_plot_colours(3),"LineStyle","-");
    case 2

        set(lines(1),"Color",get_plot_colours(2),"LineStyle","-");
        set(lines(2),"Color",get_plot_colours(3),"LineStyle","-");

        set(lines(3),"Color",get_plot_colours(2),"LineStyle","--");
        set(lines(4),"Color",get_plot_colours(3),"LineStyle","--");
end

hold(ax,"on")
plot(ax,[1,1],[0,1],"--","Color",get_plot_colours("grey"),"LineWidth",2)
hold(ax,"off")
uistack(1,"bottom")
%--------
save_fig(fig,fig_name + "_" + animation_state)

