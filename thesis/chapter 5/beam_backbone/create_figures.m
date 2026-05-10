clear
close all

fig_name = "beam_bb";
%----
rom_style = {"Color",get_plot_colours(3),"Marker","none"};
fom_style = {"k.","MarkerSize",7};
%----
data_directory = get_project_path + "\examples\JH_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});


data_dir_execute(@compare_solutions,"energy","JH_beam_2d_135","all")

%------------------------------------------

fig = gcf();
delete(findobj(fig,"Type","Legend"))
ax = findobj(fig,"Type","Axes");
rom_lines = findobj(ax,"Type","Line");

set(rom_lines,rom_style{:})
%----------
load("C:\Users\gg19546\Documents\PhD\Year 3\ROM verification\JH_beam\JH_bb_data.mat","Backbone_Data");
hold(ax,"on")
plot(Backbone_Data.frequency,Backbone_Data.energy,fom_style{:});
hold(ax,"off")


xlim(ax,[450,850])
ylabel(ax,"Energy (J)")
%------------------------------------------
save_fig(fig,fig_name)

