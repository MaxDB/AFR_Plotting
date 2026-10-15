clear
close all
fig_name = "bistable_one_mode_validation";

%------------------------------------------
figs = open_local_figures(["backbone_base","validation_orbits"]);
fig = figs{1};
validation_fig = figs{2};

%------------------------------------------
ax = findobj(fig,"type","axes");
lines = ax.Children;
delete(findobj(lines,"Marker","o"))
set(findobj(lines,"LineStyle",":"),"LineStyle","-")

swap_colours(ax,4,5)
swap_colours(ax,3,4)
swap_colours(ax,2,3)
swap_colours(ax,1,2)
%------------------------------------------
validation_ax = findobj(validation_fig,"type","axes");
validation_lines = validation_ax.Children;
set(validation_lines((end-5):end),"LineStyle","-")
set(validation_lines,"Color",[0,0,0])
unstable_lines = findobj(validation_lines,"LineStyle",":");
stable_lines = findobj(validation_lines,"LineStyle","-");
%------------------------------------------
unstable_lines = copyobj(unstable_lines,ax);
stable_lines = copyobj(stable_lines,ax);
delete(validation_fig)

uistack(stable_lines,"bottom")
uistack(unstable_lines,"top")
set(unstable_lines,"LineStyle",":")
%---
leg_lines = [lines([1,20,30,40]);unstable_lines(1)];
leg = legend(leg_lines,["-40 (μm)","-30 (μm)","-20 (μm)","-10 (μm)","Unstable valdiation"],"Location","northwest");
leg.NumColumns = 2;
leg.IconColumnWidth = leg.IconColumnWidth/2;

xlim(ax,[0,1000])
%---
save_fig(fig,fig_name);
