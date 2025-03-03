clear
close all

fig_name = "mass_spring_bb";
%----
system_name = "cubic_mass_spring_12";
sol_num = [2,3,4];
num_modes = 2;

max_x1 = 0.65;
freq_range = [0.78,1];

end_orbits = [0.799,0.644;
              0.786,0.645;
              0.783,0.492];

%---------------------------------------

line_width = 1;
marker_style = {"Marker","o","LineWidth",line_width,"MarkerEdgeColor","k","MarkerSize",5};
marker_colours = get_plot_colours([1,4]);
marker_colours(3,:) = [0,0,0];
%--------------------------------------


data_directory = get_project_path+"\examples\verification";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

fig = figure;
ax = axes(fig);


ax = data_dir_execute(@compare_solutions,"physical amplitude","cubic_mass_spring_12",2:4,"axes",ax,"legend",0);
ax = data_dir_execute(@compare_solutions,"physical amplitude","cubic_mass_spring_1",1,"axes",ax,"legend",0);
ax = data_dir_execute(@compare_solutions,"physical amplitude","cubic_mass_spring_1",2,"axes",ax,"legend",0);

xlim(freq_range)
ylim([0,max_x1])


lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    lines(iLine).LineWidth = line_width;
end

ice_ic_line = lines(end-1);
uistack(ice_ic_line,"bottom")
ice_ic_line.Color = get_plot_colours(3);
ice_ic_line.LineStyle = "-";
ice_ic_line.DisplayName = "$\{1\}$-ICE-IC";

ice_line = lines(end);
uistack(ice_line,"bottom")
ice_line.Color = get_plot_colours(2);
ice_line.LineStyle = "-";
ice_line.DisplayName = "$\{1\}$-ICE";

fom_line = lines(2);
fom_line.DisplayName = "FOM";

legend(ax,[ice_line,ice_ic_line,fom_line],"interpreter","latex","AutoUpdate","off")
ylabel("max($x_1$) (m)","Interpreter","latex")
%------------------------------------------
%plot orbit markers
num_markers = size(end_orbits,1);
hold(ax,"on")
for iMarker = 1:num_markers
    orbit_xy = end_orbits(iMarker,:);
    plot(ax,orbit_xy(1),orbit_xy(2),marker_style{:},"MarkerFaceColor",marker_colours(iMarker,:))
end
hold(ax,"off")
%------------------------------------------
hold(ax,"on")
plot(ax,[0.85,0.85],ax.YLim,"k--")
hold(ax,"off")
text(0.85,0.575," \leftarrow L_2")
%------------------------------------------
save_fig(fig,fig_name)

