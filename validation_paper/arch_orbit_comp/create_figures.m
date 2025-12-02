clear
close all
fig_name_one = "orbit_comp_one_mode";
fig_name_two = "orbit_comp_two_mode";


camera_pos = [-7.32446524714531e-06	-13.5050135796282	3.12801659271550e-07];

sub_axis_position = [0.715,0.775,0.225,0.225];
%--------------------------------------------------
data_directory = get_project_path + "\examples\validation\mems_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
% 


ax1 = plot_invariant_manifold("mems_arch_1",1,2,"colour",3);
lines = findobj(ax1,"Tag","grid_line");
set(lines(4),"LineWidth",2)
plot_invariant_manifold("mems_arch_1",1,3,"colour",1,"axes",ax1);


fig1 = gcf;
ax1.CameraPosition = camera_pos;

ax1_1 = axes(fig1,"Position",sub_axis_position);
box(ax1_1,"on")
data_dir_execute(@compare_orbits,["v-d-1","v-v-1","v-d-2"],"mems_arch_1",{1,1},"colour",3,"tag","stab","axes",ax1_1);
data_dir_execute(@compare_orbits,["q-d-1","q-v-1","q-d-6"],"mems_arch_1",{1,1},"colour",1,"tag","stab","axes",ax1_1);






%-----
ax2 = plot_invariant_manifold("mems_arch_1",1,2,"colour",3);
lines = findobj(ax2,"Tag","grid_line");
set(lines(4),"LineWidth",2)
ignore_lines_manifold = findobj(ax2,"-property","ZData");

plot_invariant_manifold("mems_arch_16",2,1,"axes",ax2,"colour",5);

fig2 = gcf;
ax2.CameraPosition = camera_pos;


ax2_1 = axes(fig2,"Position",sub_axis_position);
box(ax2_1,"on")

data_dir_execute(@compare_orbits,["v-d-1","v-v-1","v-d-2"],"mems_arch_1",{1,24},"colour",3,"tag","stab","axes",ax2_1);
ignore_lines_insert = findobj(ax2_1,"-property","ZData");

data_dir_execute(@compare_orbits,["r-d-1","r-v-1","r-d-2"],"mems_arch_16",{2,20},"colour",5,"tag","stab","axes",ax2_1);


ax2_1.CameraPosition = [49.7197    4.9519    5.5817];

flip_modeshape = 1; %modeshape 'direction' in {1,6} vs {1}:{1,6} may not be consistent
if flip_modeshape
    lines_manifold = setdiff(findobj(ax2,"-property","ZData"),ignore_lines_manifold);
    lines_insert = setdiff(findobj(ax2_1,"-property","ZData"),ignore_lines_insert);

    arrayfun(@(line) set(line,"ZData",-line.ZData),lines_manifold);
    arrayfun(@(line) set(line,"ZData",-line.ZData),lines_insert);
end

%---
% lines = findobj("Tag","stab");
% set(lines,"LineWidth",1,"LineStyle","-")

% 
% 

x_label = "q_1";
y_label = "q̇_1";
z_label = "q_6";

xlabel(ax1,x_label,"Interpreter","tex")
ylabel(ax1,y_label,"Interpreter","tex")
zlabel(ax1,z_label,"Interpreter","tex")
xlabel(ax1_1,x_label,"Interpreter","tex")
ylabel(ax1_1,y_label,"Interpreter","tex")
zlabel(ax1_1,z_label,"Interpreter","tex")

% ax1_1.XLabel.Position(1:2) = [9,14];
% ax1_1.YLabel.Position(1:2) = [10,7];
% ax1_1.ZLabel.Position(1:2) = [0,-9];

ylim(ax1,[-1.45,1.3]);
zlim(ax1,[-1.5e-7,1.6e-7]);

% ax1_1.XLabel.Rotation = 33;
ax1_1.XLabel.BackgroundColor = "white";

ax1_1.ZLabel.BackgroundColor = "white";
transfer_exponent(ax1_1)
ax1_1.CameraPosition = [-31.541399035132997	-27.923488004856075	13.448632082520803];
ax1_1.FontSize = 6;
% 
xlabel(ax2,x_label,"Interpreter","tex")
ylabel(ax2,y_label,"Interpreter","tex")
zlabel(ax2,z_label,"Interpreter","tex")
xlabel(ax2_1,x_label,"Interpreter","tex")
ylabel(ax2_1,y_label,"Interpreter","tex")
zlabel(ax2_1,z_label,"Interpreter","tex")

% ax2_1.XLabel.Position = [-3,0.8,-2];
% ax2_1.YLabel.Position = [-3,-0.5,-2.5];
% ax2_1.ZLabel.Position([2,3]) = [-1.7,0.1];

ylim(ax2,[-1.45,1.3]);
zlim(ax2,[-1.5e-7,1.6e-7]);

ax2_1.XLabel.Rotation = 35;
ax2_1.XLabel.BackgroundColor = "white";

ax2_1.ZLabel.BackgroundColor = "white";
transfer_exponent(ax2_1,1)
ax2_1.FontSize = 6;


%---
save_fig(fig1,fig_name_one)
save_fig(fig2,fig_name_two)



function ax = transfer_exponent(ax,newline)
if nargin == 1
    newline = 0;
end
directions = ["X","Y","Z"];
num_directions = numel(directions);
lines = findobj(ax,"-property","XData");
num_lines = numel(lines);
for iCoord = 1:num_directions
    direction = directions(iCoord);
    labels = ax.(direction + "TickLabel");
    values = ax.(direction + "Tick");

    exponent = floor(log10(abs(values)));
    exponent(isinf(exponent)) = [];
    power10 = max(exponent);
    if power10 == 0
        continue
    end
    values = values*10^(-power10);
    ax.(direction + "Tick") = values;
    ax_label = ax.(direction + "Label");
    if newline
        ax_label.String = {ax_label.String,"(\times10^{" + power10 + "})"};
    else
        ax_label.String = ax_label.String + " (\times10^{" + power10 + "})";
    end

    for iLine = 1:num_lines
        line = lines(iLine);
        line.(direction + "Data") = line.(direction + "Data")*10^(-power10);
    end
end




end