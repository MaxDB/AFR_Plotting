clear
close all
fig_name = "overall_error";


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
force_error = get_force_error(disp_sep,Rom_One,Rom_Two);

cubic_energy = Rom_One.Potential_Polynomial.evaluate_polynomial(disp_sep);

[~,sep_limit_index] = min(abs(cubic_energy - Rom_One.Model.energy_limit));

norm_force_error = force_error/1e-3;
norm_disp_error = disp_error/1e-2;

overall_error = max(norm_force_error,norm_disp_error);
%---
hold(ax,"on")
plot(lambda_sep,norm_force_error,"Color",get_plot_colours(1))
plot(lambda_sep,norm_disp_error,"Color",get_plot_colours(2))
plot(lambda_sep,overall_error,"--","Color",get_plot_colours(3))
yscale("log")
ylim(ax.YLim)
limit_line = plot(lambda_sep(sep_limit_index)*[1,1],ax.YLim,"k--");
uistack(limit_line,"bottom")

xlim(ax.XLim)
error_lim = plot(ax.XLim,[1,1],"k--");
uistack(error_lim,"bottom")
%---
box("on")
xlabel("\lambda")
xlim([0,1.5])

ylim([1e-1,1e3])
ylabel("Normalised error")
ax.TickLabelInterpreter = "latex";





%------------------
lines = findobj("-property","XData");
set(lines,"LineWidth",line_width)



limit_line.LineWidth = 1;
error_lim.LineWidth = 1;
%------------------








save_fig(fig,fig_name)
%------------------

