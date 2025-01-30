clear 
close all

fig_name = "validation_backbone";
height = 6;
width = 17.4; %17.4

Export_Settings.file_type = "pdf";
%--------------------------
figs = open_local_figures;
fig = figs{:};

%--------------------------

fig.Units = 'centimeters';
fig.Position(3) = width;
fig.Position(4) = height; 
fig.PaperSize = fig.InnerPosition([3,4]);
% paperFigExport(figName,fig)
%--------------------------
leg = fig.Children(2);
leg.Location = "southeast";
% leg.Position(1) = leg.Position(1) - 0.05;

%--------------------------
export_fig(fig,fig_name,Export_Settings)