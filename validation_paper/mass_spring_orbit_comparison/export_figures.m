clear 
close all

fig_name = "orbit_comp";
height = 6;
width = 8.4;

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

%--------------------------
export_fig(fig,fig_name,Export_Settings)