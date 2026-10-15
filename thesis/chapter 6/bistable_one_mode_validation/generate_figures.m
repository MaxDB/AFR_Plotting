clear
close all

data_directory = get_project_path + "\examples\validation\pinned_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Dyn_Data_10 = data_dir_execute(@initalise_dynamic_data,"pinned_beam_-10_1");
Dyn_Data_20 = data_dir_execute(@initalise_dynamic_data,"pinned_beam_-20_1");
Dyn_Data_30 = data_dir_execute(@initalise_dynamic_data,"pinned_beam_-30_1");
Dyn_Data_40 = data_dir_execute(@initalise_dynamic_data,"pinned_beam_-40_1");

Dyn_Datas = {Dyn_Data_10,Dyn_Data_20,Dyn_Data_30,Dyn_Data_40};


for iDyn = 1:4
    Dyn_Data = Dyn_Datas{iDyn};
    Dyn_Data = data_dir_execute(@Dyn_Data.validate_solution,1,1:7);
    Dyn_Data = data_dir_execute(@Dyn_Data.validate_solution,2,1:7);
end

bb_plot = data_dir_execute(@compare_solutions,"amplitude","pinned_beam_-10_1","all","pinned_beam_-20_1","all","pinned_beam_-30_1","all","pinned_beam_-40_1","all");
ax = bb_plot{1};
bb_fig = gcf;
delete(findobj(bb_fig,"type","legend"))


ax_cell = data_dir_execute(@compare_solutions,"amplitude","pinned_beam_-10_1","all","pinned_beam_-20_1","all","pinned_beam_-30_1","all","pinned_beam_-40_1","all","validation",1);
ax_list = [ax_cell{:,1}];
validation_ax = ax_list(1);
delete(ax_list(2:end))



lines = validation_ax.Children;
delete(findobj(lines,"Color",[0,0,0]));
validation_fig = gcf;
delete(findobj(validation_fig,"type","legend"))
%-------------------
save_fig(bb_fig,"backbone_base")
save_fig(validation_fig,"validation_orbits")
