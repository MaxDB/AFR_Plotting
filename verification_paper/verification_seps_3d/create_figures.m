clear
close all
fig_name = "verification_seps_3d";

%--
line_width = 2.5;
origin_style = {".k","MarkerSize",20};
line_colours = get_plot_colours(1:3);

camera_position = [-7876.74070855280	-59578.6893806428	25124.3012448831];

mesh_style = {"EdgeColor","none","FaceColor",get_plot_colours(5),"FaceAlpha",0.1};
edge_style = {"Color","k"};
%--

fig = figure;
ax = gca();
%--------------------------------------------------
data_directory = get_project_path + "\examples\rom_challenge";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});




% calibration data
load(data_directory + "\geometry\exhaust\force_calibration.mat","Force_Calibration");
calibration_index = Force_Calibration.energy_limit == 1.8;
force_limits = Force_Calibration.force_limit{calibration_index};

% approximate contour
res = 25;
phi_one = linspace(0,pi/2,res);
phi_two = linspace(0,pi/2,res);

[PHI_ONE,PHI_TWO] = meshgrid(phi_one,phi_two);

Z_ONE = zeros(size(PHI_ONE));
Z_TWO = Z_ONE;
Z_THREE = Z_ONE;

for iPhi = 1:res
    for jPhi = 1:size(phi_two,2)
        index = {jPhi,iPhi};
        Z_ONE(index{:}) = cos(PHI_ONE(index{:}));
        Z_TWO(index{:}) = sin(PHI_ONE(index{:})).*cos(PHI_TWO(index{:}));
        Z_THREE(index{:}) = sin(PHI_ONE(index{:})).*sin(PHI_TWO(index{:}));
    end
end

function Z = deform_coords(Z,force_limits)
Z(Z >=0) = Z(Z >=0)*abs(force_limits(1));
Z(Z <0) = Z(Z <0)*abs(force_limits(2));
end

Z_ONE = deform_coords(Z_ONE,force_limits(1,:));
Z_TWO = deform_coords(Z_TWO,force_limits(2,:));
Z_THREE = deform_coords(Z_THREE,force_limits(3,:));

mesh(Z_ONE,Z_TWO,Z_THREE,mesh_style{:});

hold on
plot3(Z_ONE(1,:),Z_TWO(1,:),Z_THREE(1,:),edge_style{:});
plot3(Z_ONE(end,:),Z_TWO(end,:),Z_THREE(end,:),edge_style{:});
plot3(Z_ONE(:,end),Z_TWO(:,end),Z_THREE(:,end),edge_style{:});
hold off

% seps
primary_frs = get_force_ratios(1,force_limits);
secondary_frs = get_force_ratios(2,force_limits);
tertiary_frs = get_force_ratios(3,force_limits);


hold(ax,"on")
% plot_force_ratios(ax,tertiary_frs,{"Color",line_colours(1,:)})
plot_force_ratios(ax,secondary_frs,{"Color",line_colours(2,:)})
plot_force_ratios(ax,primary_frs,{"Color",line_colours(3,:)})



plot(0,0,origin_style{:})
hold(ax,"off")


%%%
box(ax,"on")
ax.XTick = [0,force_limits(1,1)];
ax.XTickLabel = {"0","$F^+_1$"};

ax.YTick = [0,force_limits(2,1)];
ax.YTickLabel = {"0","$F^+_2$"};

ax.ZTick = [0,force_limits(3,1)];
ax.ZTickLabel = {"0","$F^+_3$"};

ax.TickLabelInterpreter = "latex";

xlabel("$\tilde{f}_1$","Interpreter","latex")
ylabel("$\tilde{f}_2$","Interpreter","latex")
zlabel("$\tilde{f}_3$","Interpreter","latex")

ax.CameraPosition = camera_position;
%-------------------------------------------------
lines = findobj("-property","XData");
set(lines,"LineWidth",line_width)

uistack(ax.Children((end-3):end),"top");
%--

save_fig(fig,fig_name)
%------------------

function force_ratios = get_force_ratios(index,force_limits)
found_force_ratios = add_sep_ratios(3,index-1);
if index == 1
    found_force_ratios = [];
end
unit_force_ratios = add_sep_ratios(3,index,found_force_ratios);
force_ratios = scale_sep_ratios(unit_force_ratios,force_limits);
end

function plot_force_ratios(ax,force_ratios,style)
num_seps = size(force_ratios,2);

for iSep = 1:num_seps
    if any(force_ratios(:,iSep) < 0)
        continue
    end
    plot3(ax,[0,force_ratios(1,iSep)],[0,force_ratios(2,iSep)],[0,force_ratios(3,iSep)],style{:})
end

end