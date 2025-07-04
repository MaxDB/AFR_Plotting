clear
close all
validation_two_name = "arch_validation_two";
resonance_two_name = "arch_resonance_two_base";


%------------------------------------------
figs = open_local_figures(["validation_two_base","resonance_two_base"]);

fig_validation_two = figs{1};
fig_resonance_two = figs{2};
%------------------------------------------

%--------
ax = findobj("Type","axes");
set(ax,"Title",[])

%--------



%--------
% swap_colours(fig_validation_two,1,4)
swap_colours(fig_resonance_two,2,9)
swap_colours(fig_resonance_two,1,4)
swap_colours(fig_resonance_two,3,1)

%--------
lines = findobj("Type","line");
set(lines,"LineWidth",2)


%-------
save_fig(fig_validation_two,validation_two_name)
save_fig(fig_resonance_two ,resonance_two_name)

