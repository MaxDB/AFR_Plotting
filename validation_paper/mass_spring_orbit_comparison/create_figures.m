clear
close all
fig_name = "orbit_comp";

sol_id_1 = 1;
orbit_ids_1 = 281;

sol_id_2 = 1;
orbit_ids_2 = 517;

line_width = 2;
orbit_colour = get_plot_colours(1);
orbit_2_colour = get_plot_colours(2);
validation_orbit_colour = get_plot_colours(5);

%--------------------------------------------------
fig = figure;
box on

%--------------------------------------------------
curret_directory = pwd;
data_directory = get_project_path+"\examples\3_dof_mass_spring";

cd(data_directory)
Dyn_Data_1 = initalise_dynamic_data("mass_spring_roller_1");
Dyn_Data_12 = initalise_dynamic_data("mass_spring_roller_12");
cd(curret_directory)

%------------------------------------------
Rom_1 = Dyn_Data_1.Dynamic_Model;
num_modes_1 = 1;
Rom_12 = Dyn_Data_12.Dynamic_Model;
num_modes_2 = 2;

evec_2 = Rom_12.Model.reduced_eigenvectors;
mass = Rom_12.Model.mass;

Disp_Poly = Rom_1.Physical_Displacement_Polynomial;
r1_lims = Disp_Poly.input_limit;
r1 = linspace(r1_lims(1),r1_lims(2),100);
x1 = Disp_Poly.evaluate_polynomial(r1);

stress_manifold_1 = evec_2'*mass*x1;
hold on
plot(stress_manifold_1(2,:),stress_manifold_1(1,:),"k-","DisplayName","$\mathcal W_{\mathcal R_1}$","LineWidth",line_width)
hold off
%------------------------------------------
orbit_style = {"LineWidth",line_width};

cd(data_directory)
[orbit_1,validation_orbit] = Dyn_Data_1.get_orbit(sol_id_1,orbit_ids_1,1);
orbit_2 = Dyn_Data_12.get_orbit(sol_id_2,orbit_ids_2);
cd(curret_directory)

r1_orbit_1 = orbit_1.xbp(:,1:num_modes_1)';
x_orbit_1 = Disp_Poly.evaluate_polynomial(r1_orbit_1);
r2_orbit_1 = evec_2'*mass*x_orbit_1;

r2_orbit_2 = orbit_2.xbp(:,1:num_modes_2)';

r2_validation_orbit = r2_orbit_1 + validation_orbit.h;

hold on
plot(r2_orbit_1(2,:),r2_orbit_1(1,:),orbit_style{:},"Color",orbit_colour,"DisplayName","$\mathcal R_{1}$-ROM Orbit")
plot(r2_orbit_2(2,:),r2_orbit_2(1,:),orbit_style{:},"Color",orbit_2_colour,"DisplayName","$\mathcal R_{2}$-ROM Orbit")
plot(r2_validation_orbit(2,:),r2_validation_orbit(1,:),"--",orbit_style{:},"Color",validation_orbit_colour,"DisplayName","Validation Orbit")
hold off


%------------------------------------------

legend("Interpreter","latex","Location","best")
xlabel("$q_2$",Interpreter="latex")
ylabel("$q_1$",Interpreter="latex")

xlim([min(stress_manifold_1(2,:)),max(stress_manifold_1(2,:))])
ylim([min(stress_manifold_1(1,:)),max(stress_manifold_1(1,:))])

save_fig(fig,fig_name)