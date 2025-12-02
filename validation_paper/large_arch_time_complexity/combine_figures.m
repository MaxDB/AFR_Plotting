clear 
close all
fig_name = "arch_time_complexity";


fig_path = @(iFig) "figures\arch_time_complexity_" + iFig + ".fig";
num_workers = [1,2,4,6];


%layout
fig = figure;
tiles = tiledlayout(2,2);
tiles.TileSpacing = "compact";
tiles.Padding ="tight";

for iFig = 1:4
    iWorker = num_workers(iFig);
    sub_tiles =tiledlayout(tiles,3,2);
    sub_tiles.Layout.Tile = iFig;
    sub_tiles.Layout.TileSpan = [1 1];
    
    sub_fig = open(fig_path(iWorker));
    sub_axes = copyobj(sub_fig.Children.Children,sub_tiles);
    close(sub_fig)

    main_ax = sub_axes(end);
    main_ax = set_main_ax_style(main_ax,iFig);
    set_memory_ax_style(sub_axes(1),2);
    set_memory_ax_style(sub_axes(2),1);
end

save_fig(fig,fig_name);

%--------------------------------------------------

function ax = set_main_ax_style(ax,num)
labels = ['a','b','c','d'];
ylim(ax,[0,230])
title = ax.Title;
title.String = [labels(num),') ',title.String];
ax.TitleHorizontalAlignment = "left";
end

function ax = set_memory_ax_style(ax,num)
title = ax.Title;
title.String = [repmat('i',[1,num]),') ',title.String];
ax.TitleHorizontalAlignment = "left";
title.FontWeight = "normal";
end