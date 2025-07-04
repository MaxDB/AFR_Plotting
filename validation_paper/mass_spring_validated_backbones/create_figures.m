clear
close all
fig_name = "validated_backbone";



orbit_frequency = 3;
orbit_id = 134;
max_energy = 0.07;
backbone_1_line = 15;
validation_line = {8,9,10,11,12,13};

backbone_one_colour = get_plot_colours(1);
backbone_two_colour = get_plot_colours(2);
backbone_validation_colour = get_plot_colours(5);
orbit_colour = get_plot_colours(3);
validated_orbit_colour = get_plot_colours(5);
line_width = 1;
marker_size = 6;
%--------------------------------------------------
data_directory = get_project_path + "\examples\3_dof_mass_spring";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

data_dir_execute(@compare_solutions,"energy","mass_spring_roller_1",3,"mass_spring_roller_12",1,"validation",[1,0]);

fig = gcf();
ax = gca();
leg = fig.Children(1);
delete(leg)
%------------------------------------------
ylim(ax,[0,max_energy ])

% leg.Interpreter = "latex";

lines = ax.Children;
num_lines = size(lines,1);
num_validation_lines = size(validation_line,2);
num_validation_orbits = zeros(1,num_validation_lines);
validation_counter = 0;
for iLine = 1:num_lines
    line = lines(iLine);
    switch line.DisplayName
        case '\{1\}'
            line.DisplayName = "$\mathcal R_1$-ROM";
        case '\{1, 2\}'
            line.DisplayName = "$\mathcal R_2$-ROM";
    end
    switch iLine
        case backbone_1_line
            line.Color = backbone_one_colour;
        case validation_line
            validation_counter = validation_counter + 1;
            line.Color = backbone_validation_colour;
            num_validation_orbits(validation_counter) = size(line.XData,2);
    end
end

cumulative_points = 0;
for iLine = 1:num_validation_lines
    cumulative_points = cumulative_points + num_validation_orbits(end+1 - iLine);
    if cumulative_points > orbit_id
        validation_orbit_line_num = validation_line{end + 1 - iLine};
        break
    end
end
validation_orbit_line = lines(validation_orbit_line_num);
validation_orbit_id_diff = cumulative_points - orbit_id;
validation_orbit_id = num_validation_orbits(end + 1 - iLine) - validation_orbit_id_diff + 1;
x_validation_orbit = validation_orbit_line.XData(validation_orbit_id);
y_validation_orbit = validation_orbit_line.YData(validation_orbit_id);

% 
bb_line = lines(backbone_1_line);
x_orbit = bb_line.XData(orbit_id);
y_orbit = bb_line.YData(orbit_id);

% orbit_style = {"Marker","*","Color",orbit_colour,"LineWidth",line_width,"MarkerSize",marker_size};
% hold on
% p = plot(x_orbit,y_orbit,orbit_style{:});
% hold off
% p.Annotation.LegendInformation.IconDisplayStyle = "off";
% uistack(ax.Children(1),"top")
%
% hold on
% p = plot(x_validation_orbit,y_validation_orbit,orbit_style{:});
% hold off
% p.Annotation.LegendInformation.IconDisplayStyle = "off";
% uistack(ax.Children(1),"top")
%-----------------------------------------
xlim(ax,[1.35,3.27])
ylim(ax,ax.YLim)

hold(ax,"on") %#ok<UNRCH>
p= plot(ax,[orbit_frequency,orbit_frequency],ax.YLim,"k--");
p.Annotation.LegendInformation.IconDisplayStyle = "off";
uistack(ax.Children(1),"bottom")
hold(ax,"off")
%-----------------------------------------
x_range = [2.85,3.05];
y_range = [0.033,0.047];
% insert_position = [0.35,0.45,0.2,0.4];
insert_position = [0.3698    0.44    0.2339    0.4531];
ax_insert = create_zoomed_insert(ax,insert_position,x_range,y_range);

%-----------------------------------------


hold(ax,"on")
plot(ax,0,0,"-","LineWidth",line_width,"Color",backbone_validation_colour,"DisplayName","Validation backbone")
hold(ax,"off")

ylabel(ax,"Energy (J)")
%-----------------------------------------
save_fig(fig,fig_name)