clear
close all
fig_name = "frequency_comb";
figs = open_local_figures(fig_name + "_base");

%--------------------------------------------------
fig = figs{1};


axs = findobj(fig,"type","axes");

set_freq_style(axs(1),3);
set_trajectory_style(axs(2),3)

set_freq_style(axs(3),2);
set_trajectory_style(axs(4),2)

set_freq_style(axs(5),1);
set_trajectory_style(axs(6),1);
%--
tiles = findobj(fig,"type","tiledlayout");
tiles.Padding = "tight";
tiles.TileSpacing = "tight";

%--
save_fig(fig,fig_name);



function ax = set_trajectory_style(ax,num)
box(ax,"on")
lines = findobj(ax,"type","line");
set(lines,"Color",[0,0,0])
arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines)
ylim(ax,[-0.5,0.6])
xlim(ax,[1000,1500])

xlabel(ax,"\tau","Interpreter","tex")
switch num
    case 1
        ylabel(ax,"\it{x̃}\rm{(}\it{t}\rm{)} \rm{(μm)}","Interpreter","tex")
    case 2
        ylabel(ax,"\it{x̃_{v}}\rm{(}\it{t}\rm{)} \rm{(μm)}","Interpreter","tex")
    case 3
        ylabel(ax,"\it{x}\rm{(}\it{t}\rm{)} \rm{(μm)}","Interpreter","tex")

end


end

function ax = set_freq_style(ax,num)
box(ax,"on")
lines = findobj(ax,"type","line");
arrayfun(@(line) set(line,"YData",get(line,"YData")*1000),lines)
set(lines,"Color",[0,0,0])
yscale(ax,"log")

ylim(ax,[1e-5,1e0])
xlim(ax,[0.9,1.1])

xlabel(ax,"\Omega/\Omega_1","Interpreter","tex")
ylabel(ax,"|P_1| (μm)")
end