clear
close all

fig_name = "mass_spring_bb";
%----
system_name = "cubic_mass_spring_12";
sol_num = [2,3,4];
num_modes = 2;

max_x1 = 0.65;
freq_range = [0.65,1];

%---------------------------------------

line_width = 1;
%--------------------------------------


data_directory = get_project_path+"\examples\verification";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

fig = figure;
ax = axes(fig);


ax = data_dir_execute(@compare_solutions,"physical amplitude","cubic_mass_spring_12",2:4,"axes",ax,"legend",0);
ax = data_dir_execute(@compare_solutions,"physical amplitude","cubic_mass_spring_1",1,"axes",ax,"legend",0);
ax = data_dir_execute(@compare_solutions,"physical amplitude","cubic_mass_spring_1",2,"axes",ax,"legend",0);

xlim(freq_range)
ylim([0,max_x1])


lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    lines(iLine).LineWidth = line_width;
end


uistack(lines(end-1),"bottom")
lines(end-1).Color = get_plot_colours(3);
lines(end-1).LineStyle = "-";
lines(end-1).DisplayName = "$\{1\}$-ICE-IC";

uistack(lines(end),"bottom")
lines(end).Color = get_plot_colours(2);
lines(end).LineStyle = "-";
lines(end).DisplayName = "$\{1\}$-ICE";

lines(2).DisplayName = "FOM";

legend(ax,[lines(end),lines(end-1),lines(2)],"interpreter","latex")

ylabel("max($x_1$)","Interpreter","latex")
%------------------------------------------
save_fig(fig,fig_name)

