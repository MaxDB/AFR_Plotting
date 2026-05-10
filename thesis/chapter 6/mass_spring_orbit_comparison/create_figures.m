clear
close all
fig_name = "orbit_comp";

sol_id_1 = 1;

sol_id_2 = 1;

line_width = 2;
orbit_colour = get_plot_colours(1);
orbit_2_colour = get_plot_colours(2);
validation_orbit_colour = get_plot_colours(5);

orbit_frequency = 3;

%--------------------------------------------------
fig = figure;
box on

%--------------------------------------------------
data_directory = get_project_path + "\examples\validation\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Dyn_Data_1 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_1");
Dyn_Data_12 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_12");
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

Sol_1 = data_dir_execute(@Dyn_Data_1.load_solution,sol_id_1);
Sol_2 = data_dir_execute(@Dyn_Data_12.load_solution,sol_id_2);
[~,orbit_ids_1] = min(abs(Sol_1.frequency - orbit_frequency));
[~,orbit_ids_2] = min(abs(Sol_2.frequency - orbit_frequency));

% Dyn_Data_1 = data_dir_execute(@Dyn_Data_1.validate_solution,1,2);
[orbit_1,validation_orbit] = data_dir_execute(@Dyn_Data_1.get_orbit,sol_id_1,orbit_ids_1,1);
orbit_2 = data_dir_execute(@Dyn_Data_12.get_orbit,sol_id_2,orbit_ids_2);

r1_orbit_1 = orbit_1.xbp(:,1:num_modes_1)';
x_orbit_1 = Disp_Poly.evaluate_polynomial(r1_orbit_1);
r2_orbit_1 = evec_2'*mass*x_orbit_1;

r2_orbit_2 = orbit_2.xbp(:,1:num_modes_2)';

r2_validation_orbit = r2_orbit_1 + validation_orbit.h;
time_range = 41:125; %make dotted line cleaner

hold on
plot(r2_orbit_1(2,:),r2_orbit_1(1,:),orbit_style{:},"Color",orbit_colour,"DisplayName","$\mathcal R_{1}$-ROM Orbit")
plot(r2_orbit_2(2,:),r2_orbit_2(1,:),orbit_style{:},"Color",orbit_2_colour,"DisplayName","$\mathcal R_{2}$-ROM Orbit")
plot(r2_validation_orbit(2,time_range),r2_validation_orbit(1,time_range),"--",orbit_style{:},"Color",validation_orbit_colour,"DisplayName","Validation Orbit")
hold off


%------------------------------------------

% legend("Interpreter","latex","Location","best")
xlabel("$q_2$",Interpreter="latex")
ylabel("$q_1$",Interpreter="latex")

xlim([min(stress_manifold_1(2,:)),max(stress_manifold_1(2,:))])
ylim([min(stress_manifold_1(1,:)),max(stress_manifold_1(1,:))]*1.1)

save_fig(fig,fig_name)