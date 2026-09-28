clear 
close all


fig_names = "arch_time_complexity";
%--------------------------
figs = open_local_figures(fig_names);
base_fig = figs{1};
base_tiles = base_fig.Children(1).Children;

cost_fig = figure;
cost_tiles = tiledlayout(2,2);
cost_tiles.Padding ="compact";
cost_tiles.TileSpacing = "compact";

memory_fig = figure;
memory_tiles = tiledlayout(4,2);
memory_tiles.TileSpacing = "compact";
memory_tiles.Padding = "tight";

%-------------------
for iTile = 1:4
    base_tiled_layout = base_tiles(5-iTile);
    ax = nexttile(cost_tiles);
    copyobj(allchild(base_tiled_layout.Children(4)),ax);    
    ax = set_x_labels(ax);

    box(ax,"on")
    xlabel(ax,"DoFs")
    ylabel(ax,"Time (mins)")
    ylim(ax,[0,140]);
    xlim(ax,[105765-15000,1006743+15000])

    if iTile == 2
        leg = legend(flip(findobj(ax,"type","polygon")),["Verification","Scaffold","Calibration","Matrices"],"Location","northwest");
        leg.NumColumns = 1;
        leg.IconColumnWidth = leg.IconColumnWidth/2;
    end 

    switch iTile
        case 1
            title_text = "One parallel workers";
        case 2
            title_text = "Two parallel workers";
        case 3
            title_text = "Four parallel workers";
        case 4
            title_text = "Six parallel workers";
    end
    title(ax,title_text)
    ax.TitleHorizontalAlignment = "left";
end
%-------------------
for iTile = 1:4
    base_tiled_layout = base_tiles(5-iTile);
    for iAx = 1:2
        ax = nexttile(memory_tiles);
        copyobj(allchild(base_tiled_layout.Children(3-iAx)),ax);

        box(ax,"on")
        xlabel(ax,"Time (mins)")
        
        max_x = max(arrayfun(@(line) max(line.XData),ax.Children));
        if iAx == 1
            ylabel(ax,["Memory","(GB)"])
            xticks(ax,[0,round(max_x,1)])
            xlim(ax,[0,round(max_x,1)])
        elseif iAx == 2
            xticks(ax,[0,round(max_x,0)])
            xlim(ax,[0,round(max_x,0)])
        end
        ylim(ax,[7.2,31.2])
        
        yticks(ax,[8,31.2])
        
        if iAx == 2
            yticklabels(ax,[])
        end
        if iTile == 1 && iAx == 1
            leg = legend(flip(ax.Children(1:4)),flip(["Verification","Scaffold","Calibration","Matrices"]),"Location","northwest");
            leg.NumColumns = 2;
            leg.IconColumnWidth = leg.IconColumnWidth/2;
        end 

        if iTile == 1
            switch iAx
                case 1
                    title(ax,"105,765 DoFs")
                case 2
                    title(ax,"1,006,743 DoFs")
            end
        end
    end
end
%----
save_fig(cost_fig,"arch_time_complexity_cost");
save_fig(memory_fig,"arch_time_complexity_memory");

%-------------------
function ax = set_x_labels(ax)
dof_range = [105765,1006740];
range_multiplier = [-1,+1]*25000;
xlim(ax,dof_range + range_multiplier)
x_ticks = [1,5,10]*1e5;
xticks(ax,x_ticks)
x_labels = cellfun(@(x_tick) add_comma(x_tick),num2cell(x_ticks'));

xticklabels(ax,x_labels);


end

function num_out = add_comma(num_in)
java_formater=java.text.DecimalFormat;
num_out= string(java_formater.format(num_in)); 
end