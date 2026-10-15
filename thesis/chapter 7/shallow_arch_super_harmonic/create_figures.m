clear
close all
fig_name = "super_harmonic";
figs = open_local_figures(fig_name + "_base");

%--------------------------------------------------
fig = figs{1};
ax = findobj(fig,"type","axes");
xlim(ax,[0.495,0.505])
ylim(ax,[0.02,0.17])

xlabel(ax,"$\Omega/\omega_1$","Interpreter","latex")
ylabel(ax,"max$(\phi_1q_1/H)$","Interpreter","latex")

%---
% import fe data
f_id = fopen("data\sh_1.txt");
fom_data_1 = fscanf(f_id,"%f,%f",[2,inf]);
fclose(f_id);
f_id = fopen("data\sh_2.txt");
fom_data_2 = fscanf(f_id,"%f,%f",[2,inf]);
fclose(f_id);
f_id = fopen("data\sh_3.txt");
fom_data_3 = fscanf(f_id,"%f,%f",[2,inf]);
fclose(f_id);

fom_data = [flip(fom_data_1,2),fom_data_2,fom_data_3];

hold(ax,"on")
plot(ax,fom_data(1,:),fom_data(2,:),"k--","MarkerSize",4);
hold(ax,"off")
%---

hold(ax,"on")
leg_lines(1) = plot(ax,0,0,"Color",get_plot_colours(1));
leg_lines(2) = plot(ax,0,0,"Color",get_plot_colours(2));
leg_lines(3) = plot(ax,0,0,"--","Color",get_plot_colours(0));
hold(ax,"off")

leg = legend(leg_lines,"\{1\}-ROM","\{1,4\}-ROM","FOM","Location","northeast");
leg.IconColumnWidth = leg.IconColumnWidth*2/3;

lines = findobj(ax,"Type","line");
set(lines,"LineWidth",1.5)
%---
save_fig(fig,fig_name)
