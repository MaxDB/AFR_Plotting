clear
close all
fig_name = "fe_convergence";

%--------------------------------------------------
load("data\plot_data.mat")

% freq_values = sqrt(Plot_Data.eig_values);
freq_values = Plot_Data.eig_values;
dofs = Plot_Data.num_dof;
%------
norm_freq_values = freq_values./freq_values(:,end);
freq_diff = abs(norm_freq_values - norm_freq_values(:,end));
%------
fig = figure;
ax = axes;

loglog(ax,dofs,freq_diff(1,:),"Color",get_plot_colours(1),"LineWidth",2)
hold(ax,"on")
loglog(ax,dofs,freq_diff(2,:),"Color",get_plot_colours(3),"LineWidth",2)
hold(ax,"off")
%----
%70,000 3 s.f. for evals

%----
ax.XScale = "log";
ax.YScale = "log";
box(ax,"on")

xlim(ax,[6837,1e6])
ylim(ax,[5e-5,2e-2])
%---
hold(ax,"on")
line = plot(ax,70000*[1,1],ax.YLim,"k--");
hold(ax,"off")
uistack(line,"bottom")
%---
ylabel(ax,"$\frac{\omega_n^2 - \omega_{n:\textrm{ref}}^2}{\omega_{n:\textrm{ref}}^2}$","Interpreter","latex")
xlabel(ax,"Degrees-of-freedom")
%---
save_fig(fig,fig_name)