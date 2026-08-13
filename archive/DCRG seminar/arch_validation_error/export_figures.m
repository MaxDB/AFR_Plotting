clear 
close all
% 
% 

fig_name = "validation_error";

Export_Settings.height = 8;
Export_Settings.width = 8.4;
Export_Settings.file_type = "png";

% fig_name = "validation_error_single";
% Export_Settings.height = 15; 
% Export_Settings.width = 15;
% Export_Settings.font_size = 22;



%--------------------------
figs = open_local_figures(fig_name);
fig = figs{1};
ax_phy = fig.Children.Children(1);
set(fig,"currentaxes",ax_phy)
leg = legend("Location","northeast");
leg.String = {'\{1\}-ROM','\{1,6\} Validation'};

% colour_2 = ax_phy.Children(2).Color;
% ax_phy.Children(2).Color = "k";
% 
% leg.AutoUpdate = "off";
% 
% ax_phy.Children(2).Color = colour_2;
%----
export_fig(fig,fig_name,Export_Settings)
