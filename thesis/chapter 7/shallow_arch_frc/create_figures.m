clear
close all
fig_name = "frc";
figs = open_local_figures(fig_name + "_base");

%--------------------------------------------------
fig = figs{1};
ax = findobj(fig,"type","axes");
xlim(ax,[0.9945,1.001])
ylim(ax,[0.03,0.16])

xlabel(ax,"$\Omega/\omega_1$","Interpreter","latex")
ylabel(ax,"max$(\phi_1q_1/H)$","Interpreter","latex")





%---
% import fe data
f_id = fopen("data\frc_main_20.txt");
fom_data_20 = fscanf(f_id,"%f,%f",[2,inf]);
fclose(f_id);
f_id = fopen("data\frc_main_40.txt");
fom_data_40 = fscanf(f_id,"%f,%f",[2,inf]);
fclose(f_id);

hold(ax,"on")
fom_20 = plot(ax,fom_data_20(1,:),fom_data_20(2,:),"k--","MarkerSize",4);
fom_40 = plot(ax,fom_data_40(1,:),fom_data_40(2,:),"k--","MarkerSize",4);
hold(ax,"off")

%---

hold(ax,"on")
leg_lines(1) = plot(ax,0,0,"Color",get_plot_colours(1));
leg_lines(2) = plot(ax,0,0,"Color",get_plot_colours(2));
leg_lines(3) = plot(ax,0,0,"--","Color",get_plot_colours(0));
hold(ax,"off")

leg = legend(leg_lines,"\{1\}-ROM","\{1,4\}-ROM","FOM","Location","southeast");
leg.IconColumnWidth = leg.IconColumnWidth*0.666;


lines = findobj(ax,"Type","line");
set(lines,"LineWidth",1.5)
%--
save_fig(fig,fig_name)
