clear 
close all

fig_name = "orbit_comp";

Export_Settings.height = 6;
Export_Settings.width = 8.4;
Export_Settings.file_type = "pdf";
%--------------------------
figs = open_local_figures(fig_name);
fig = figs{:};

%--------------------------

%--------------------------
export_fig(fig,fig_name,Export_Settings)