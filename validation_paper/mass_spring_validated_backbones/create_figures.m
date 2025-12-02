clear
close all
fig_name = "validated_backbone";



orbit_frequency = 3;
orbit_id = 141;
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
data_directory = get_project_path + "\examples\validation\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

data_dir_execute(@compare_solutions,"energy","mass_spring_roller_1",1,"mass_spring_roller_12",1,"validation",[1,0]);



fig = gcf();
ax = gca();
leg = fig.Children(1);
delete(leg)
%------------------------------------------
backbone_1_line = findobj(ax.Children,"Color",[0,0,0]);
backbone_2_line = findobj(ax.Children,"Color",get_plot_colours(2));
validation_line = findobj(ax.Children,"Color",get_plot_colours(1));

set(backbone_1_line,"Color",backbone_one_colour);
set(backbone_2_line,"Color",backbone_two_colour);
set(validation_line,"Color",backbone_validation_colour)

ylim(ax,[0,max_energy ])


% validation_orbit_line = lines(validation_orbit_line_num);
% validation_orbit_id_diff = cumulative_points - orbit_id;
% validation_orbit_id = num_validation_orbits(end + 1 - iLine) - validation_orbit_id_diff + 1;
% x_validation_orbit = validation_orbit_line.XData(validation_orbit_id);
% y_validation_orbit = validation_orbit_line.YData(validation_orbit_id);
% 
% % 
% bb_line = lines(backbone_1_line);
% x_orbit = bb_line.XData(orbit_id);
% y_orbit = bb_line.YData(orbit_id);

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
xlim(ax,[1.35,3.2])
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