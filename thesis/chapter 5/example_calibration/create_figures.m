clear
close all
fig_name = "calibration";



%--------------------------------------------------
figs = open_local_figures(fig_name+"_pre");
fig = figs{1};
tiles = fig.Children;

tiles.Padding = "compact";
tiles.TileSpacing = "compact";

sep_colours = get_plot_colours([1,2]);
sep_style = {"LineWidth",2,"MarkerSize",6};
%-----
energy_ax = tiles.Children(1);
ylabel(energy_ax,"Energy")
energy_ax.YTick = [0,1.98];
energy_ax.YTickLabel = {"$0$","$V_L$"};
energy_ax.TickLabelInterpreter = "latex";




xlabel(energy_ax,"$r_1$","Interpreter","latex")




%-----
force_ax = tiles.Children(2);
ylabel(force_ax,"$\tilde{f}_1$","Interpreter","latex")
force_ax.YTick = [-4054,0,1730];
force_ax.YTickLabel = {"$F_1^-$","$0$","$F_1^+$"};
force_ax.TickLabelInterpreter = "latex";


xlabel(force_ax,"$r_1$","Interpreter","latex")

%--------
sep_1 = findobj(fig,"Tag","sep_1");
set(sep_1,"Color",sep_colours(1,:),sep_style{:})

sep_2 = findobj(fig,"Tag","sep_2");
set(sep_2,"Color",sep_colours(2,:),sep_style{:})

%------------------
save_fig(fig,fig_name)
%------------------

