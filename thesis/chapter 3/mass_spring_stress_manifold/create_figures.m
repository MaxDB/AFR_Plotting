clear
close all

disp_fig_name = "stress_manifold";
force_fig_name = "reduced_force";
%----

x1_lim = [-1.5,1.5];
x2_lim = [-2,0.5];
force_lim = [-10,10];

plot_colours = get_plot_colours([3,5]);
line_width = 2;
%------------------------------------------
[x1,x2,f] = get_stress_manifold(x1_lim);
%------------------------------------------
disp_fig = figure;
ax = gca();
box(ax,"on")
hold(ax,"on")
for iBranch = 1:2
    plot(ax,x1{iBranch},x2{iBranch},"LineWidth",line_width,"Color",plot_colours(iBranch,:))
end
hold(ax,"off")
xlabel("$x_1$ (m)","Interpreter","latex")
ylabel("$x_2$ (m)","Interpreter","latex")
daspect(ax,[1,1,1])
ylim(ax,x2_lim)
xlim(ax,x1_lim)

%------------------------------------------
force_fig = figure;
ax = gca();
box(ax,"on")
hold(ax,"on")
for iBranch = 1:2
    plot(ax,x1{iBranch},f{iBranch},"LineWidth",line_width,"Color",plot_colours(iBranch,:))
end
hold(ax,"off")
xlabel("$x_1$ (m)","Interpreter","latex")
ylabel("$\tilde{f}_1$ (N)","Interpreter","latex")

ylim(ax,force_lim)
x_lim = ax.XLim;
xlim(ax,x_lim);

hold(ax,"on")
p = plot(ax,x_lim,[0,0],"k-");
hold(ax,"off")
uistack(p,"bottom")
%------------------------------------------
save_fig(disp_fig,disp_fig_name)
save_fig(force_fig,force_fig_name)