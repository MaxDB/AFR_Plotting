clear
close all
fig_name = "modal_backbone_base";

%--------------------------------------------------
data_directory = get_project_path + "\examples\validation\mems_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});
data_dir_execute(@compare_solutions,"amplitude","mems_arch_16",[1,2,4]);
fig_1 = gcf;
leg = findobj(fig_1,"Type","Legend");
delete(leg);
%---------
axes = findobj(fig_1,"Type","axes");
tiles_1 = findobj(fig_1,"Type","TiledLayout");

ax_1 = axes(2);
ax_6 = axes(1);
%--



%--


fig_2 = figure;
tiles_2 = tiledlayout(2,3);
tile_bb_1 = nexttile(tiles_2,[1,2]);
tile_orbit_1 = nexttile(tiles_2);
tile_bb_2 = nexttile(tiles_2,[1,2]);
tile_orbit_2 = nexttile(tiles_2);

copyobj(ax_1.Children,tile_bb_1);
copyobj(ax_6.Children,tile_bb_2);

%---
data_dir_execute(@compare_orbits,["q-d-1","q-v-1","q-d-6"],"mems_arch_16",{2,7},"axes",tile_orbit_1);
data_dir_execute(@compare_orbits,["q-d-1","q-v-1","q-d-6"],"mems_arch_16",{1,6},"axes",tile_orbit_2);
%---------
hold(tile_bb_1,"on")
plot(tile_bb_1,2657270,2.93339e-7,"*","Tag","orbit_1")
plot(tile_bb_1,2740600,2.92873e-7,"*","Tag","orbit_2")
hold(tile_bb_1,"off")

hold(tile_bb_2,"on")
plot(tile_bb_2,2657270,1.09955e-7,"*","Tag","orbit_1")
plot(tile_bb_2,2740600,9.99516e-8,"*","Tag","orbit_2")
hold(tile_bb_2,"off")
%---
save_fig(fig_2,fig_name)