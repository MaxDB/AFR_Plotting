clear 
close all

fig_name = "exhaust_validated_backbone";


Export_Settings.height = 10; 
Export_Settings.width = 15.4;
Export_Settings.font_size = 12;



%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};

%----
export_fig(fig,fig_name,Export_Settings)
