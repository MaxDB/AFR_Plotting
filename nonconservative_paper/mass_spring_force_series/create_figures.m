clear
close all
id = "3";
% fig_name = "force_series_nc_1";
fig_name = "force_series_" + id;
figs = open_local_figures(fig_name+"_base");

%--------------------------------------------------
fig = figs{1};
tiles = findobj(fig,"Type","TiledLayout");
tiles.Padding = "tight";
tiles.TileSpacing ="none";

for iMode = 1:3
    ax_id = (iMode-1)*2 + 1;
    ax_fom = nexttile(tiles,ax_id);
    ax_rom = nexttile(tiles,ax_id + 1);
    
    y_lim = ax_fom.YLim;
    if ax_rom.YLim(2) > y_lim(2) && ax_rom.YLim(2) < 10*y_lim(2)
        y_lim = ax_rom.YLim;
    end
    ylim(ax_rom,y_lim)
    ylim(ax_fom,y_lim)

    ax_fom = set_x_labels(ax_fom,ax_id);
    ax_rom = set_x_labels(ax_rom,ax_id+1);

    ax_fom = set_y_labels(ax_fom,ax_id);
    ax_rom = set_y_labels(ax_rom,ax_id+1);

    if iMode == 1
        title(ax_fom,"FOM")
        title(ax_rom,"\{1,2\}-ROM")
    end


end
%---
save_fig(fig,fig_name)



function ax = set_x_labels(ax,tile_num)
x_ticks = [0,1,2,3];
x_labels = {'0','1','2','3'};
switch tile_num
    case {1,2,3,4}
        xticklabels(ax,"")
        xticks(ax,x_ticks)
        xlabel(ax,"")
    case {5,6}
        xticks(ax,x_ticks)
        xticklabels(ax,x_labels)
end
    
    
end

function ax = set_y_labels(ax,tile_num)
switch tile_num
    case {2,4,6}
        yticklabels(ax,"")
        ylabel(ax,"")
end

end