clear
close all
fig_name = "displacement_error";


line_width = 2;

%layout
fig = figure;
ax = gca();

%--------------------------------------------------
data_directory = get_project_path + "\examples\rom_challenge";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Static_Data = data_dir_execute(@load_static_data,"exhaust_17");

Rom_One = data_dir_execute(@Reduced_System,Static_Data,3);
Rom_Two = data_dir_execute(@Reduced_System,Static_Data,5);


%-----
%tested SEPs

adjusted_force_limits = Rom_One.Model.calibrated_forces;
unit_force_ratios = add_sep_ratios(2,2,add_sep_ratios(2,1));
scaled_force_ratios = scale_sep_ratios(unit_force_ratios,adjusted_force_limits);

tested_sep = scaled_force_ratios(:,4);


[disp_sep,lambda_sep] = find_sep_rom(Rom_One,tested_sep,100);


Disp_Error_Inputs.beta_bar_one = data_dir_execute(@Rom_One.get_beta_bar,Rom_One.Physical_Displacement_Polynomial);
Disp_Error_Inputs.beta_bar_two = data_dir_execute(@Rom_Two.get_beta_bar,Rom_Two.Physical_Displacement_Polynomial);
Disp_Error_Inputs.input_order = Rom_Two.get_max_input_order;

Disp_Error_Inputs.Disp_Diff_Data_One = Rom_One.Physical_Displacement_Polynomial.get_diff_data(1);
Disp_Error_Inputs.Disp_Diff_Data_Two = Rom_Two.Physical_Displacement_Polynomial.get_diff_data(1);

disp_error = get_disp_error(disp_sep,Rom_One,Rom_Two,tested_sep,Disp_Error_Inputs);
[cubic_acceleration,quintic_acceleration] = get_acceleration(disp_sep,Rom_One,Rom_Two,Disp_Error_Inputs);

cubic_energy = Rom_One.Potential_Polynomial.evaluate_polynomial(disp_sep);

[~,sep_limit_index] = min(abs(cubic_energy - Rom_One.Model.energy_limit));

%---
hold(ax,"on")
plot(lambda_sep,cubic_acceleration,"Color",get_plot_colours(5))
plot(lambda_sep,quintic_acceleration,"Color",get_plot_colours(4))
ylim(ax.YLim)
limit_line = plot(lambda_sep(sep_limit_index)*[1,1],ax.YLim,"k--");
uistack(limit_line,"bottom")

yyaxis right
error = semilogy(lambda_sep,disp_error,"k-");
hold(ax,"off")

%---
box("on")
xlabel("\lambda")

yyaxis left
ylabel("Acceleration")
ax.TickLabelInterpreter = "latex";

yyaxis right
yscale("log")
ylabel("$\epsilon_{d:3}$","Interpreter","latex")
ax.YColor = "k";
ylim([1e-2,1e3])



%------------------
lines = findobj("-property","XData");
set(lines,"LineWidth",line_width)



limit_line.LineWidth = 1;
%------------------








save_fig(fig,fig_name)
%------------------

function [r_ddot_one,r_ddot_two] = get_acceleration(disp,Rom_One,Rom_Two,Disp_Error_Inputs)
  beta_bar_one = Disp_Error_Inputs.beta_bar_one;
    beta_bar_two = Disp_Error_Inputs.beta_bar_two;
    input_order = Disp_Error_Inputs.input_order;
    Disp_Diff_One = Disp_Error_Inputs.Disp_Diff_Data_One;
    Disp_Diff_Two = Disp_Error_Inputs.Disp_Diff_Data_Two;

    scale_factor = Rom_One.Force_Polynomial.scaling_factor;
    shift_factor = Rom_One.Force_Polynomial.shifting_factor;
    r_transformed = scale_factor.*(disp + shift_factor);

    num_disp_coeffs = [size(beta_bar_one,1),size(beta_bar_two,1)];
    num_force_coeffs = [Rom_One.Force_Polynomial.num_element_coefficients,Rom_Two.Force_Polynomial.num_element_coefficients];
    num_coeffs = max(max(num_disp_coeffs),max(num_force_coeffs));

    num_x = size(r_transformed,2);
    num_modes = size(r_transformed,1);

    r_ddot_one = zeros(num_modes,num_x);
    r_ddot_two = zeros(num_modes,num_x);
    for iX = 1:num_x
        r_i = r_transformed(:,iX);

        r_power_products = ones(num_coeffs,1);
        for iMode = 1:num_modes
            r_power_products = r_power_products.*r_i(iMode).^input_order(:,iMode);
        end
        
        r_products_disp_one = r_power_products(1:num_disp_coeffs(1),:);
        r_products_disp_two = r_power_products(1:num_disp_coeffs(2),:);

        r_dr_products_disp_one = r_products_disp_one(Disp_Diff_One.diff_mapping{1,1}).*Disp_Diff_One.diff_scale_factor{1,1};
        r_dr_products_disp_two = r_products_disp_two(Disp_Diff_Two.diff_mapping{1,1}).*Disp_Diff_Two.diff_scale_factor{1,1};

        r_products_force_one = r_power_products(1:num_force_coeffs(1),:);
        r_products_force_two = r_power_products(1:num_force_coeffs(2),:);
    
        %----------
        force_one = Rom_One.Force_Polynomial.coefficients*r_products_force_one;
        force_two = Rom_Two.Force_Polynomial.coefficients*r_products_force_two;

        %---------
        inertia_one = r_dr_products_disp_one'*beta_bar_one*r_dr_products_disp_one;
        inertia_two = r_dr_products_disp_two'*beta_bar_two*r_dr_products_disp_two;

        %---------
        r_ddot_one(:,iX) = - inertia_one\force_one;
        r_ddot_two(:,iX) = - inertia_two\force_two;
    end
end