clear
close all
fig_name_base = "mass_spring_frc";
figs = open_local_figures(["low_damping","mid_damping","high_damping"]);

%--------------------------------------------------
y_limit = [0,0.003];
x_limit = [1.3,2];
for iFig = 1:3
    fig = figs{iFig};
    ax = findobj(fig,"type","axes");

    xlim(ax,x_limit)
    ylim(ax,y_limit)
    
    ax = scale_axis(ax,"y",1000);
    
    ylabel(ax,"Energy (mJ)")

    bb = ax.Children(end-1);
    set(bb,"Color",get_plot_colours("gray"))
    set(ax.Children,"LineWidth",1.5)
    
    res_0 = findobj(ax.Children,"Tag","res_0");
    res_12 = findobj(ax.Children,"Tag","res_12");
    res_points = [res_0;res_12];

    set(res_points,"Color",get_plot_colours(3),"Marker","*","MarkerSize",6,"LineWidth",1)


    save_fig(fig,fig_name_base+"_" + iFig)
end 


