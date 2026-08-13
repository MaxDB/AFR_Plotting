clear 
close all

fig_name = "validated_backbone_" + [1,2,3,4];

Export_Settings.height = 20;
Export_Settings.width = 45;

% Export_Settings.height = 20;
% Export_Settings.width = 45;
Export_Settings.font_size = 26;
Export_Settings.file_type = "svg";

%--------------------------
figs = open_local_figures(fig_name);

%--------------------------
export_fig(figs,fig_name,Export_Settings)