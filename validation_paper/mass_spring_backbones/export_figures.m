clear 
close all


fig_name = "energy_backbone";
annotated = 1;

if ~annotated
    Export_Settings.height = 6; %8.4
    Export_Settings.width = 8.4;
else
    fig_name = fig_name + "_annotated";
    Export_Settings = struct([]);
end

figs = open_local_figures(fig_name);
%--------------------------
export_fig(figs,fig_name,Export_Settings)