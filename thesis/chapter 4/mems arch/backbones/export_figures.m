clear
close all


fig_name = "modal_backbone";

Export_Settings.font_size = 12;
Export_Settings.height = 8; 
Export_Settings.width = 15.6;
Export_Settings.projection = "3D";



figs = open_local_figures(fig_name);

% camera_position = [1.5277e-06,-16.7330, 3.4926e-07];
% ax = findobj(figs{1},"Type","axes");
% orbit_ax = ax([1,3]);
% set(orbit_ax,"CameraPosition",camera_position)
% zlim(orbit_ax(2),[-0.1071, 0.1128]*1e-6)

%--------------------------
export_fig(figs,fig_name,Export_Settings)