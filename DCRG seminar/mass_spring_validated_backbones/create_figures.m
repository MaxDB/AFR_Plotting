clear
close all
fig_name = "validated_backbone";

animation = 4;
%----------
sol_id = 3;
orbit_id = 132;
max_energy = 0.07;
backbone_1_line = 15;
validation_line = {8,9,10,11,12,13};

backbone_one_colour = get_plot_colours(1);
backbone_two_colour = get_plot_colours(2);
backbone_validation_colour = get_plot_colours(5);
orbit_colour = get_plot_colours(3);
validated_orbit_colour = get_plot_colours(5);
%--------------------------------------------------
data_directory = get_project_path + "\examples\3_dof_mass_spring";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

switch animation
    case {1,2}
        data_dir_execute(@compare_solutions,"energy","mass_spring_roller_1",3,"validation",0);
    case 3
        data_dir_execute(@compare_solutions,"energy","mass_spring_roller_1",3,"validation",1);
    case 4
        data_dir_execute(@compare_solutions,"energy","mass_spring_roller_1",3,"mass_spring_roller_1",2,"validation",1);
end

fig = gcf();
ax = gca();
leg = fig.Children(1);
delete(leg)
%------------------------------------------
ylim(ax,[0,max_energy ])
% leg.Interpreter = "latex";
set(ax.Children,"MarkerSize",8)


%-----------------------------------------
xlim(ax,[1.35,3.27])
ylim(ax,ax.YLim)

line_width = 2; %1
marker_size = 10; %6
orbit_style = {"Marker","*","LineWidth",line_width,"MarkerSize",marker_size};
if animation > 1
    hold(ax,"on")
    plot(ax,1.859,0.00317,orbit_style{:},"Color",get_plot_colours(3));
    plot(ax,1.859,0.0538,orbit_style{:},"Color",get_plot_colours(5));
    hold(ax,"off")
end
%-----------------------------------------
swap_colours(ax,1,5);
set(ax.Children,"LineWidth",line_width)
%

ylabel(ax,"Energy (J)")
%-----------------------------------------
save_fig(fig,fig_name+"_"+animation)