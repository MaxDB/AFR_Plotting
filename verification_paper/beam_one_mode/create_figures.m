clear
close all
fig_name = "beam_one_mode";



%layout
fig = figure;
ax = gca();


%-----
error_style = {"Color",get_plot_colours(3),"LineWidth",2};
point_style = {"o","LineWidth",1.5,"MarkerSize",6,"MarkerEdgeColor","w","MarkerFaceColor","k"};
%--------------------------------------------------
data_directory = get_project_path + "\examples\JH_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Static_Data = data_dir_execute(@load_static_data,"JH_beam_2d_1");

Rom_One = data_dir_execute(@Reduced_System,Static_Data,[7,5]);
Rom_Two = data_dir_execute(@Reduced_System,Static_Data,[9,7]);


%-----
point_sep_ratios = Static_Data.unit_sep_ratios;
adjacent_sep_ratios = get_adjacent_sep_ratios(point_sep_ratios);
unit_force_ratios = [point_sep_ratios,adjacent_sep_ratios];
[~,~,reorder_index] = uniquetol(unit_force_ratios', "ByRows",1);
removal_indicies = false(1,size(unit_force_ratios,2));
for iIndex = 1:max(reorder_index)
    matching_indices = reorder_index == iIndex;
    if nnz(matching_indices) > 1
        repeated_index = find(matching_indices);
        repeated_index(1) = [];
        removal_indicies(repeated_index) = 1;
    end
end
unit_force_ratios(:,removal_indicies) = [];

scaled_force_ratios = scale_sep_ratios(unit_force_ratios,Static_Data.Model.calibrated_forces);
num_verified_seps = size(unit_force_ratios,2);


Disp_Error_Inputs.beta_bar_one = data_dir_execute(@Rom_One.get_beta_bar,Rom_One.Physical_Displacement_Polynomial);
Disp_Error_Inputs.beta_bar_two = data_dir_execute(@Rom_Two.get_beta_bar,Rom_Two.Physical_Displacement_Polynomial);
Disp_Error_Inputs.input_order = Rom_Two.get_max_input_order;

Disp_Error_Inputs.Disp_Diff_Data_One = Rom_One.Physical_Displacement_Polynomial.get_diff_data(1);
Disp_Error_Inputs.Disp_Diff_Data_Two = Rom_Two.Physical_Displacement_Polynomial.get_diff_data(1);
%-----
%tested SEPs
rom_limit = Rom_One.Force_Polynomial.evaluate_polynomial(Rom_One.Force_Polynomial.input_limit);
hold(ax,"on")
plot(rom_limit,[1,1],"k--")
for iSep = 1:num_verified_seps
    tested_sep = scaled_force_ratios(:,iSep);
    [disp_sep,lambda_sep] = find_sep_rom(Rom_One,tested_sep,100);

    force_error = get_force_error(disp_sep,Rom_One,Rom_Two);
    disp_error = get_disp_error(disp_sep,Rom_One,Rom_Two,tested_sep,Disp_Error_Inputs);

    norm_force_error = force_error/5e-3;
    norm_disp_error = disp_error/1e-2;

    convergence_error = max(norm_force_error,norm_disp_error);

    force_sep = lambda_sep.*tested_sep;

    potential = Rom_One.Potential_Polynomial.evaluate_polynomial(disp_sep);
    removal_index = potential > Static_Data.Model.energy_limit;
    convergence_error(removal_index) = [];
    force_sep(removal_index) = [];
    plot(force_sep,convergence_error,error_style{:})
end
hold(ax,"off")

%----
yscale(ax,"log")
ylim(ax,[1e-2,2])
box(ax,"on")

%---
hold(ax,"on")
plot(Static_Data.restoring_force,1e-2*ones(size(Static_Data.restoring_force)),point_style{:})
hold(ax,"off")
%--

ylabel("$\bar{\epsilon}_{(7,5)}$","Interpreter","latex")
xlabel("$\tilde{\mathbf f}_1$","Interpreter","latex")



save_fig(fig,fig_name)
%------------------

