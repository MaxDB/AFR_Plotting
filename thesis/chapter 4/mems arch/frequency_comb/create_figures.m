clear
close all
fig_name = "frequency_comb";
%--------------------------------------------------
figs = open_local_figures(fig_name+"_base");
fig = figs{1};
%---
tiles = findobj(fig,"type","TiledLayout");
axes = findobj(tiles,"type","Axes");

tiles.Padding = "compact";
tiles.TileSpacing = "compact";
%---------
ax_freq_2 = axes(1);
ax_time_2 = axes(2);
ax_freq_1 = axes(3);
ax_time_1 = axes(4);

%--
ax_time_1 = set_time_style(ax_time_1,1);
ax_time_2 = set_time_style(ax_time_2,2);

ax_freq_1 = set_freq_style(ax_freq_1,1);
ax_freq_2 = set_freq_style(ax_freq_2,2);

%---
save_fig(fig,fig_name)


%-------------------------------
function ax = set_time_style(ax,id)
box(ax,"on")

xlabel(ax,"\it{t/T}","Interpreter","tex")
ylabel(ax,"Max deflection (μm)")

lines = findobj(ax,"type","Line");
arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines)

switch id
    case 1
        xticks(ax,[1000,2000,3000]);
        xlim(ax,[1000,3000])
        set(lines,"Color",get_plot_colours(1))
    case 2
        xticks(ax,[1000,6000,11000]);
        xlim(ax,[1000,11000])
        set(lines,"Color",get_plot_colours(2))
end
end

%-------------------------------
function ax = set_freq_style(ax,id)
box(ax,"on")

xlabel(ax,"\it{ω}\rm{/Ω}","Interpreter","tex")
ylabel(ax,"\rm{||}\bf{P}\rm{_{1}|| \fontname{Times New Roman}(μm)}","Interpreter","tex")




lines = findobj(ax,"type","Line");
arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines)
xlim(ax,[0.85,1.15])
ylim(ax,[1e-5,1])
switch id
    case 1
        set(lines,"Color",get_plot_colours(1))
    case 2
        set(lines,"Color",get_plot_colours(2))
end
set(lines,"LineWidth",1)
end