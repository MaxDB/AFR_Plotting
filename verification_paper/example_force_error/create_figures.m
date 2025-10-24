clear
close all
fig_name = "force_error";


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


cubic_energy = Rom_One.Potential_Polynomial.evaluate_polynomial(disp_sep);
quintic_energy = Rom_Two.Potential_Polynomial.evaluate_polynomial(disp_sep);

force_error = get_force_error(disp_sep,Rom_One,Rom_Two);

[~,sep_limit_index] = min(abs(cubic_energy - Rom_One.Model.energy_limit));

%---
hold(ax,"on")
plot(lambda_sep,cubic_energy,"Color",get_plot_colours(5))
plot(lambda_sep,quintic_energy,"Color",get_plot_colours(4))

limit_line = plot(lambda_sep(sep_limit_index)*[1,1],[0,ax.YLim(2)],"k--");
uistack(limit_line,"bottom")

yyaxis right
error = semilogy(lambda_sep,force_error,"k-");
hold(ax,"off")

%---
box("on")
xlabel("\lambda")

yyaxis left
ylabel("Energy")
ax.YTick = [0,1.8];
ax.YTickLabel = {"0","$V_L$"};
ax.TickLabelInterpreter = "latex";

yyaxis right
yscale("log")
ylabel("$\epsilon_{f:3}$","Interpreter","latex")
ax.YColor = "k";
ylim([1e-4,1])



%------------------
lines = findobj("-property","XData");
set(lines,"LineWidth",line_width)



limit_line.LineWidth = 1;
%------------------








save_fig(fig,fig_name)
%------------------

