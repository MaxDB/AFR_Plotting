clear
close all
fig_name = "beam_one_mode_comp";



%layout
fig = figure;
tiles = tiledlayout(1,2);
tiles.TileSpacing = "tight";
tiles.Padding = "tight";
ax_force = nexttile;
ax_disp = nexttile;

centre_node = 20; %accounting for removed BCs

%-----
fom_style = {"Color","k","LineWidth",1.5};
rom_style = {"Color",get_plot_colours(3),"LineWidth",1.5,"LineStyle","--"};
%--------------------------------------------------
data_directory = get_project_path + "\examples\JH_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Fom_Data = data_dir_execute(@load_static_data,"JH_beam_2d_comp_1");
num_points = size(Fom_Data,2);

Static_Data = data_dir_execute(@load_static_data,"JH_beam_2d_1");
Rom = data_dir_execute(@Reduced_System,Static_Data);

%-----
sort_data = @(data) [flip(data((num_points/2+1):end)),0,data(1:num_points/2)]; 
r_fom = sort_data(Fom_Data.reduced_displacement);

f_fom = sort_data(Fom_Data.restoring_force);
f_rom = Rom.Force_Polynomial.evaluate_polynomial(r_fom);
coeff_determination_force = get_coeff_determination(f_fom,f_rom);

x_fom = data_dir_execute(@Fom_Data.get_dataset_values,"physical_displacement");
centre_dof = (centre_node-1)*3 + 2;
centre_fom = sort_data(x_fom(centre_dof,:));
centre_rom = Rom.Physical_Displacement_Polynomial.evaluate_polynomial(r_fom,centre_dof);
coeff_determination_disp = get_coeff_determination(centre_fom,centre_rom);
%---
box(ax_force,"on")
hold(ax_force,"on")
plot(ax_force,r_fom,f_fom,fom_style{:})
plot(ax_force,r_fom,f_rom,rom_style{:})
hold(ax_force,"off")

box(ax_disp,"on")
hold(ax_disp,"on")
plot(ax_disp,r_fom,centre_fom,fom_style{:})
plot(ax_disp,r_fom,centre_rom,rom_style{:})
hold(ax_disp,"off")
%-----
xlabel(ax_force,"$r_1$","Interpreter","latex")
ylabel(ax_force,"$\tilde{f}_1$","Interpreter","latex")

xlabel(ax_disp,"$r_1$","Interpreter","latex")
ylabel(ax_disp,"$\tilde{x}_{62}$ (m)","Interpreter","latex")

%-----
save_fig(fig,fig_name)
%------------------


function coeff_determination = get_coeff_determination(y_observed,y_predicted)   
ss_res = sum((y_observed-y_predicted).^2);

y_observed_mean = mean(y_observed);
ss_tot = sum((y_observed-y_observed_mean).^2);

coeff_determination = 1- ss_res/ss_tot;
end