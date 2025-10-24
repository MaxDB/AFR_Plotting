clear
close all
fig_name = "beam_two_mode_comp";

load("Fom_Data.mat","Fom_Data")

%layout
fig = figure;
tiles = tiledlayout(3,1);
tiles.TileSpacing = "tight";
tiles.Padding = "tight";
ax_force_one = nexttile;
ax_force_two = nexttile;
ax_disp = nexttile;

centre_node = 20; %accounting for removed BCs

disp_camera_position = [0.000532577592982408	-0.000881948558100365	0.0106829405991239];
force_one_camera_position = [-0.00265033710851939	-0.000584161766691398	1011.78917969502];
force_two_camera_position = [-0.00236216677149508	-0.000620476105996786	5232.86645682045];
%-----
% fom_style = {"EdgeColor","none","FaceColor",get_plot_colours(2),"FaceAlpha",0.8};
fom_style = {"k.","MarkerSize",3};
outline_style = {"Color",get_plot_colours(0),"LineWidth",0.5,"Visible","off"};
border_style = {"Color",get_plot_colours(0),"LineWidth",0.5};
rom_style = {"EdgeColor","none","FaceColor",get_plot_colours(3),"FaceAlpha",0.8,"LineWidth",0.01};
%--------------------------------------------------
data_directory = get_project_path + "\examples\JH_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});


Static_Data = data_dir_execute(@load_static_data,"JH_beam_2d_13");
Rom = data_dir_execute(@Reduced_System,Static_Data);

%-----
sort_data = @(data) [reshape(data,Fom_Data.mesh_shape)]; 
r1_fom = sort_data(Fom_Data.reduced_disp(1,:));
r2_fom = sort_data(Fom_Data.reduced_disp(2,:));

f1_fom = sort_data(Fom_Data.restoring_force(1,:));
f2_fom = sort_data(Fom_Data.restoring_force(2,:));

f_rom = Rom.Force_Polynomial.evaluate_polynomial(Fom_Data.reduced_disp);
f1_rom = sort_data(f_rom(1,:));
f2_rom = sort_data(f_rom(2,:));

coeff_determination_f1 = get_coeff_determination(Fom_Data.restoring_force(1,:),f_rom(1,:));
coeff_determination_f2 = get_coeff_determination(Fom_Data.restoring_force(2,:),f_rom(2,:));
%--
centre_dof = (centre_node-1)*3 + 2;
centre_fom = sort_data(Fom_Data.physical_disp(centre_dof,:));
centre_rom = Rom.Physical_Displacement_Polynomial.evaluate_polynomial(Fom_Data.reduced_disp,centre_dof);


coeff_determination_disp = get_coeff_determination(Fom_Data.physical_disp(centre_dof,:),centre_rom);

centre_rom = sort_data(centre_fom);
%------------

box(ax_force_one,"on")
hold(ax_force_one,"on")
plot3(ax_force_one,r1_fom,r2_fom,f1_fom,fom_style{:})
% mesh_data(ax_force_one,r1_fom,r2_fom,f1_fom,fom_style,border_style,outline_style)
mesh_data(ax_force_one,r1_fom,r2_fom,f1_rom,rom_style,border_style,outline_style)
hold(ax_force_one,"off")

box(ax_force_two,"on")
hold(ax_force_two,"on")
plot3(ax_force_two,r1_fom,r2_fom,f2_fom,fom_style{:})
% mesh_data(ax_force_two,r1_fom,r2_fom,f2_fom,fom_style,border_style,outline_style)
mesh_data(ax_force_two,r1_fom,r2_fom,f2_rom,rom_style,border_style,outline_style)
hold(ax_force_two,"off")

box(ax_disp,"on")
hold(ax_disp,"on")
plot3(ax_disp,r1_fom,r2_fom,centre_fom,fom_style{:})
% mesh_data(ax_disp,r1_fom,r2_fom,centre_fom,fom_style,border_style,outline_style)
mesh_data(ax_disp,r1_fom,r2_fom,centre_rom,rom_style,border_style,outline_style)
hold(ax_disp,"off")
%-----
xlabel(ax_force_one,"$r_1$","Interpreter","latex")
ylabel(ax_force_one,"$r_2$","Interpreter","latex")
zlabel(ax_force_one,"$\tilde{f}_1$","Interpreter","latex")

xlabel(ax_force_two,"$r_1$","Interpreter","latex")
ylabel(ax_force_two,"$r_2$","Interpreter","latex")
zlabel(ax_force_two,"$\tilde{f}_2$","Interpreter","latex")

xlabel(ax_disp,"$r_1$","Interpreter","latex")
ylabel(ax_disp,"$r_2$","Interpreter","latex")
zlabel(ax_disp,"$\tilde{x}_{62}$","Interpreter","latex")

ax_disp.CameraPosition = disp_camera_position;
ax_force_one.CameraPosition = force_one_camera_position;
ax_force_two.CameraPosition = force_two_camera_position;
%-----
hold(ax_force_one,"on")
leg_mesh = mesh(ax_force_one,zeros(2),zeros(2),zeros(2),rom_style{:},"EdgeColor","k");
leg_point = plot3(ax_force_one,0,0,0,fom_style{:});
hold(ax_force_one,"off")
leg = legend(ax_force_one,[leg_mesh,leg_point],["$\{1,3\}$-ROM","Loadcase"],"AutoUpdate","off","Interpreter","latex");
% leg_mesh.Visible = "off";
% leg_point.Visible = "off";
leg.IconColumnWidth = 10;



save_fig(fig,fig_name)
%------------------


function coeff_determination = get_coeff_determination(y_observed,y_predicted)   
ss_res = sum((y_observed-y_predicted).^2);

y_observed_mean = mean(y_observed);
ss_tot = sum((y_observed-y_observed_mean).^2);

coeff_determination = 1- ss_res/ss_tot;
end


function mesh_data(ax,x,y,z,mesh_style,border_style,outline_style)
if isempty(border_style)
    border_style = {"Visible","off"};
end
if isempty(outline_style)
    outline_style = {"Visible","off"};
end

mesh(ax,x,y,z,mesh_style{:});

num_contours = size(x,1);
for iContour = 2:(num_contours-1)
    plot3(ax,x(iContour,:),y(iContour,:),z(iContour,:),outline_style{:})
end

border_one = mean(abs(x(1,:)));
border_two = mean(abs(x(end,:)));
if border_one > border_two
    border_index = 1;
else
    border_index = num_contours;
end

plot3(ax,x(border_index,:),y(border_index,:),z(border_index,:),border_style{:})

end