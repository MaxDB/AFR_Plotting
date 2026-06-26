clear
close all

id = "3";
fig_name = "force_series_" + id ;

Export_Settings.height = 8.4; 
Export_Settings.width = 8.4;




figs = open_local_figures(fig_name);
%--

%--------------------------
export_fig(figs,fig_name,Export_Settings)
%--
fig = figs{1};
fig = fix_y_ticks(fig);
%-
Export_Settings.padding =  [0,0.05,0,0];
export_fig(figs,fig_name,Export_Settings)
%--

function fig = fix_y_ticks(fig)
tiles = findobj(fig,"type","TiledLayout");

for iMode = 1:3
    ax_id = (iMode-1)*2 + 1;
    ax_fom = nexttile(tiles,ax_id);
    ax_rom = nexttile(tiles,ax_id + 1);

    y_ticks = ax_fom.YTick;
    if length(y_ticks) > 3
        y_ticks(1) = [];
        y_ticks(end) = [];
    end
    yticks(ax_rom,y_ticks)
    yticks(ax_fom,y_ticks)


end

end