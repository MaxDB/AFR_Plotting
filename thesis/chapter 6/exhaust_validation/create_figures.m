clear
close all
fig_name = "exhaust_validated_backbone";

%------------------------------------------
figs = open_local_figures(["validated_backbone_1_base","validated_backbone_17_base","validated_backbone_157_base","validated_backbone_1567_base"]);

%------------------------------------------
fig = figure;
tiles = tiledlayout(fig,2,2);
tiles.Padding = "compact";
tiles.TileSpacing = "tight";
for iFig = 1:numel(figs)
    ax = nexttile;
    fig_ax = findobj(figs{iFig},"type","axes");
    copyobj(fig_ax.Children,ax)

    set_ax_style(ax,iFig)
end

%------------------------------------------
delete([figs{:}])



%------------------------------------------


%------------------------------------------
save_fig(fig,fig_name)



%----
function set_ax_style(ax,ax_id)
box(ax,"on")
xlabel(ax,"Frequency (Hz)")
ylabel(ax,"\it{X}_{\rm{1563}} \rm{(mm)}","Interpreter","tex")
lines = findobj(ax,"type","line");
arrayfun(@(line) set(line,"YData",get(line,"Ydata")*1000),lines)
arrayfun(@(line) set(line,"XData",get(line,"XData")/(2*pi)),lines)

xlim(ax,[175,210])
ylim(ax,[0,6])

special_markers = findobj(lines,"MarkerFaceColor",get_plot_colours(3),"Marker","o","MarkerEdgeColor","w");
delete(special_markers)

bb_lines = findobj(lines,"Tag","backbone");
bb_colour = ax_id;
set(bb_lines,"Color",get_plot_colours(bb_colour),"LineWidth",2,"MarkerEdgeColor",get_plot_colours(bb_colour))
uistack(bb_lines,"top")

%line_colours =[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18];
line_colours = [1,0,0,0,3,4,2,0,0, 0, 0, 0, 0, 0, 0, 6, 0, 5];
for iMode = 1:18
    validation_lines = findobj(lines,"Tag",string(iMode));
    if isempty(validation_lines)
        continue
    end
    line_colour = line_colours(iMode);
    if line_colour == 0
        line_colour = "grey";
    end
    set(validation_lines,"color",get_plot_colours(line_colour))


end

end