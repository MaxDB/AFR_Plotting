clear
close all

fig_name = "backbone_convergence";
%----
figs = open_local_figures(fig_name + "_base");
fig = figs{1};

tiles = findobj(fig,"type","tiledlayout");
tiles.Padding ="compact";
tiles.TileSpacing = "compact";

%-
axs = findobj(fig,"type","axes");

phy_ax = axs(1);
energy_ax = axs(2);

lines = findobj(tiles,"type","line");
leg_lines = [];
for iIteration = 1:5
    iteration_lines = findobj(lines,"Tag","it: " + iIteration);
    it_colour = get_plot_colours(iIteration);
    set(iteration_lines,"Color",it_colour,"MarkerEdgeColor",it_colour,"MarkerFaceColor",get_plot_colours("grey"),"MarkerSize",4)
    
    for iAx = 1:2
        ax = axs(iAx);
        it_lines = findobj(ax,"Tag","it: " + iIteration);
        uistack(it_lines,"top")

        if iAx == 2
            leg_lines(iIteration) = it_lines(1); %#ok<SAGROW>
        end

        markers = findobj(it_lines,"Marker","o");
        uistack(markers,"top")

        
    end
end
%-
ylim(energy_ax,[0,1.5])
ylim(phy_ax,[0,4.75])


legend(energy_ax,leg_lines,["Step 1","Step 2","Step 3","Step 4","Step 5"])

%--
create_zoomed_insert(energy_ax,[])


%------------------------------------------
save_fig(fig,fig_name)

