clear 
close all
% 
% 

fig_name = ["arch_validation_one","arch_validation_two","arch_resonance_two_base","arch_bb_one","arch_bb_two","arch_bb_three"];

Export_Settings.file_type = "svg";


Export_Settings.height = 5;
Export_Settings.width = 10;
% Export_Settings.font_size  = 12;



%--------------------------
figs = open_local_figures(fig_name);
% ax = findobj("YScale","log");
% set(ax,"YLim",[1e-5,1.01]);

%----
export_fig(figs,fig_name,Export_Settings)
