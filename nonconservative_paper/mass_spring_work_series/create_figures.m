clear
close all
id = 3;
%--
fig_name = "work_series_"+id;
figs = open_local_figures(fig_name+"_base");

%--------------------------------------------------
fig = figs{1};
ax = findobj(fig,"type","axes");

%--
ax = scale_axis(ax,2,1000);
%xlim([0,3.53291])


lines = ax.Children;


set(lines,"LineWidth",1.5)

xlabel(ax,"Time (s)")
ylabel(ax,"Energy (mJ)")

ylim(ax,ax.YLim.*[1,1.5])

%--
leg = findobj(fig,"type","legend");
leg.Location = "northwest";
leg.NumColumns = 3;
leg.BackgroundAlpha = 0.7;
leg.IconColumnWidth = leg.IconColumnWidth*0.62;
%---
save_fig(fig,fig_name)



