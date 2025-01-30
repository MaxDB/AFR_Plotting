clear
close all
fig_name = "energy_backbone";

orbit_id = 134;
max_energy = 0.05;
backbone_1_line = 8;

colour = get_plot_colours(3);
line_width = 1;
marker_size = 6;
%--------------------------------------------------

curret_directory = pwd;
data_directory = get_project_path + "\examples\3_dof_mass_spring";

cd(data_directory)
compare_solutions("energy","mass_spring_roller_1",1,"mass_spring_roller_12",1);
cd(curret_directory)

fig = gcf();
ax = gca();
leg = fig.Children(1);
%------------------------------------------
ylim(ax,[0,max_energy ])

leg.Interpreter = "latex";

lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    switch line.DisplayName
        case '\{1\}'
            line.DisplayName = "$\mathcal R_1$-ROM";
        case '\{1, 2\}'
            line.DisplayName = "$\mathcal R_2$-ROM";
    end
end

bb_line = lines(backbone_1_line);
x_orbit = bb_line.XData(orbit_id);
y_orbit = bb_line.YData(orbit_id);

orbit_style = {"Marker","*","Color",colour,"LineWidth",line_width,"MarkerSize",marker_size};
hold on
p = plot(x_orbit,y_orbit,orbit_style{:});
hold off
p.Annotation.LegendInformation.IconDisplayStyle = "off";
% uistack(ax.Children(1),"bottom")
%-----------------------------------------
save_fig(fig,"energy_backbone")