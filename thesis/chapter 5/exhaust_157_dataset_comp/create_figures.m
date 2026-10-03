clear
close all

fig_name = "157_staticdata";
%----
figs = open_local_figures("static_global");
global_fig = figs{1};

figs = open_local_figures("static_local");
local_fig = figs{1};

data_directory = get_project_path + "\examples\rom_challenge";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
Static_Data = data_dir_execute(@load_static_data,"exhaust_157");
sep_id = Static_Data.static_equilibrium_path_id;
r_disp = Static_Data.reduced_displacement;

fig = figure;
tiles = tiledlayout(1,2);
tiles.Padding ="compact";
tiles.TileSpacing = "compact";

%- global
ax = nexttile;

copyobj(findobj(global_fig,"type","line"),ax)
[ax,leg_lines] = set_ax_style(ax,5,sep_id,r_disp);
leg = legend(ax,leg_lines,["Step 1","Step 2","Step 3","Step 4","Step 5"],"location","south west","numcolumns",3);
leg.IconColumnWidth = leg.IconColumnWidth/2;


%- local
ax = nexttile;

copyobj(findobj(local_fig,"type","line"),ax)
[ax,leg_lines] = set_ax_style(ax,6,sep_id,r_disp);
leg = legend(ax,leg_lines,["Step 1","Step 2","Step 3","Step 4","Step 5","Step 6"],"location","south west","numcolumns",3);
leg.IconColumnWidth = leg.IconColumnWidth/2;


%------------------------------------------
save_fig(fig,fig_name)

function [ax,leg_lines] = set_ax_style(ax,num_iterations,sep_id,r_disp)
lines = findobj(ax,"type","line");

marker_style = {"Marker",".","MarkerSize",6};
set(lines,"Visible","off")
leg_lines = [];

x_lim = [0,0];
y_lim = [0,0];
z_lim = [0,0];
for iStep = 1:num_iterations
    it_lines = findobj(lines,"tag","step: " + iStep);
    set(it_lines,"color",get_plot_colours(iStep),marker_style{:},"visible","on")
    leg_lines(iStep) = it_lines;
    if ismember(iStep,[1,2])
      
        x_data = it_lines.XData;
        y_data = it_lines.YData;
        z_data = it_lines.ZData;

        x_lim(1) = min(x_lim(1),min(x_data));
        x_lim(2) = max(x_lim(2),max(x_data));

        y_lim(1) = min(y_lim(1),min(y_data));
        y_lim(2) = max(y_lim(2),max(y_data));

        z_lim(1) = min(z_lim(1),min(z_data));
        z_lim(2) = max(z_lim(2),max(z_data));

        if iStep == 1
            sep_id(1:size(x_data,2)) = [];
            r_disp(:,1:size(x_data,2)) = [];


            distance = vecnorm([x_data;y_data;z_data]);
            dist_diff = diff(distance);
            break_indices = find(dist_diff < 0);
            for iBreak = 1:length(break_indices)
                break_index = break_indices(end + 1 -iBreak);
                x_data = [x_data(1:break_index),nan,0,x_data((break_index+1):end)];
                y_data = [y_data(1:break_index),nan,0,y_data((break_index+1):end)];
                z_data = [z_data(1:break_index),nan,0,z_data((break_index+1):end)];
            end
            it_lines.XData = [0,x_data];
            it_lines.YData = [0,y_data];
            it_lines.ZData = [0,z_data];

            set(it_lines,"LineStyle","-","MarkerSize",10,"LineWidth",1)
        elseif iStep == 2
                sep_id(80:83) = nan;
            sep_max = max(sep_id);
            sep_min = min(sep_id);
        
            for iSep = sep_min:sep_max
                sep_points = sep_id == iSep;
                if isempty(sep_points)
                    continue
                end
                hold(ax,"on")
                p = plot3(ax,[0,r_disp(1,sep_points)],[0,r_disp(2,sep_points)],[0,r_disp(3,sep_points)],".-","LineWidth",1,"color",get_plot_colours(iStep),"MarkerSize",10);
                hold(ax,"off")

            end
            leg_lines(iStep) = p;
            set(it_lines,"Visible","off")
            
            
         



        end
    end
end

box(ax,"on")
xlabel(ax,"$r_1$","Interpreter","latex")
ylabel(ax,"$r_2$","Interpreter","latex")
zlabel(ax,"$r_3$","Interpreter","latex")
ax.CameraPosition = [-0.0137   -0.0090    0.0024];

xlim(ax,x_lim)
ylim(ax,y_lim)
zlim(ax,z_lim)
end