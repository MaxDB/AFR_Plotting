clear
close all
validation_one_name = "arch_validation_one";
validation_two_name = "arch_validation_two";
resonance_two_name = "arch_resonance_two_base";
bb_one_name = "arch_bb_one";
bb_two_name = "arch_bb_two";
bb_three_name = "arch_bb_three";

%------------------------------------------
figs = open_local_figures(["validation_one_base","validation_two_base","resonance_two_base"]);
fig_validation_one = figs{1};
fig_validation_two = figs{2};
fig_resonance_two = figs{3};
%------------------------------------------

%--------
data_directory = get_project_path + "\examples\size_test";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});


ax_bb_one = data_dir_execute(@compare_solutions,"energy","mems_arch_1",1,"legend",0);
fig_bb_one = gcf;

ax_bb_two = data_dir_execute(@compare_solutions,"energy","mems_arch_16",[1,2],"legend",0);
fig_bb_two = gcf;

ax_bb_three = data_dir_execute(@compare_solutions,"energy","mems_arch_1611",[1,2,3],"legend",0);
fig_bb_three = gcf;
%--------
freq_range = ax_bb_two.XLim;
xlim(ax_bb_one,freq_range)

ylabel(ax_bb_one,"Energy (mJ)")
ylabel(ax_bb_two,"Energy (mJ)")
ylabel(ax_bb_three,"Energy (mJ)")

set(findobj(fig_validation_one,"-Property","XLim"),"XLim",freq_range)

%--------
swap_colours(fig_resonance_two,1,4)
swap_colours(fig_resonance_two,3,1)
swap_colours(fig_resonance_two,2,9)

%--------
lines = findobj("Type","line");
set(lines,"LineWidth",3)

ax = findobj("Type","axes");
set(ax,"Title",[])
%-------
save_fig(fig_validation_one,validation_one_name)
save_fig(fig_validation_two,validation_two_name)
save_fig(fig_resonance_two ,resonance_two_name)
save_fig(fig_bb_one,bb_one_name)
save_fig(fig_bb_two,bb_two_name)
save_fig(fig_bb_three,bb_three_name)
