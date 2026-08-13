clear
close all
fig_name = "modal_backbone";

figs = open_local_figures(fig_name+"_base");
fig = figs{1};
%--------------------------------------------------
tiles = findobj(fig,"Type","TiledLayout");

tiles.Padding ="compact";
tiles.TileSpacing ="tight";

%--
ax = findobj(tiles,"Type","axes");
set(ax,"Box","on")

ax_orbit_2 = ax(1);
ax_bb_2 = ax(2);
ax_orbit_1 = ax(3);
ax_bb_1 = ax(4);


ax_bb_1.XTickLabel= {""};
xlabel(ax_bb_1,"");

%--

xlabel(ax_bb_2,"Frequency (rad/s)")
ylabel(ax_bb_1,"$Q_1$","Interpreter","latex")
ylabel(ax_bb_2,"$Q_6$","Interpreter","latex")

ylim(ax_bb_2,[0,2e-7])
ylim(ax_bb_1,[0,5e-7])

%--
ir_freq = 2.6939e6;
freq_1 = 2720930;
hold(ax_bb_1,"on")
plot(ax_bb_1,ir_freq*[1,1],ax_bb_1.YLim,"--","Color",get_plot_colours("grey"))
plot(ax_bb_1,freq_1*[1,1],ax_bb_1.YLim,"--","Color",get_plot_colours("grey"))
hold(ax_bb_1,"off")

hold(ax_bb_2,"on")
plot(ax_bb_2,ir_freq*[1,1],ax_bb_2.YLim,"--","Color",get_plot_colours("grey"))
plot(ax_bb_2,freq_1*[1,1],ax_bb_2.YLim,"--","Color",get_plot_colours("grey"))
hold(ax_bb_2,"off")

uistack(ax_bb_1.Children(1:2),"bottom")
uistack(ax_bb_2.Children(1:2),"bottom")
%--

markers_1 = findobj(tiles,"Tag","orbit_1");
set(markers_1,"Color",get_plot_colours(1),"MarkerSize",10)

markers_2 = findobj(tiles,"Tag","orbit_2");
set(markers_2,"Color",get_plot_colours(2),"MarkerSize",10)
%--
lines = findobj(ax_orbit_1,"Type","Line");
set(lines,"Color",get_plot_colours(1))

lines = findobj(ax_orbit_2,"Type","Line");
set(lines,"Color",get_plot_colours(2))

%--


%---
ax_orbit_1 = set_orbit_ax_style(ax_orbit_1);
ax_orbit_2 = set_orbit_ax_style(ax_orbit_2);

%---
lines = findobj(fig,"Type","Line");
set(lines,"LineWidth",2);

%---------
save_fig(fig,fig_name)

function ax = set_orbit_ax_style(ax)
camera_position = [1.5277e-06,-16.7330, 3.4926e-07];
set(ax,"CameraPosition",camera_position);

xlim(ax,ax.XLim)
xlim(ax,ax.XLim)

ylim(ax,ax.YLim)
ylim(ax,ax.YLim)

zlim(ax,ax.ZLim)
zlim(ax,ax.ZLim)

xticks(ax,[])
yticks(ax,[])
zticks(ax,[])


end