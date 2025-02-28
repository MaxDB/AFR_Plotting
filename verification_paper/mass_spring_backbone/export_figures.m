clear 
close all

fig_names = ["mass_spring_bb"];

Export_Settings.height = 4;
Export_Settings.width = 8.4;


Export_Settings.font_name = "Times New Roman";
Export_Settings.font_size = 8;
%--------------------------
figs = open_local_figures;
leg = figs{1}.Children(1);
leg.Location = "southwest";
%--------------------------

%--------------------------
export_fig(figs,fig_names,Export_Settings)