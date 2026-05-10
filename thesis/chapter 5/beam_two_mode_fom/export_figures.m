clear
close all


fig_name = "beam_two_mode_comp_" + ["1","1","2","3"];

Export_Settings.height = 6;
Export_Settings.width = 7.8;
Export_Settings.font_size = 12;
Export_Settings.projection = "3d";
Export_Settings.file_type = "png";
Export_Settings.resolution = 500;


figs = open_local_figures(fig_name);
%-------------
fig_name(1) = "beam_two_mode_comp_0";
delete(figs{1}.Children(1));

%--------------------------
export_fig(figs,fig_name,Export_Settings)