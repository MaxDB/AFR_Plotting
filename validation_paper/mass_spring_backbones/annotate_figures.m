clear 
close all

fig_name = "energy_backbone";
Plot_Settings.height = 6; %8.4
Plot_Settings.width = 8.4;


labels = ["$\mathcal R_{1}$-ROM";
          "$\mathcal R_{2}$-ROM";
          "$\mathbf r_1^*$"];

%-----------------------------

figs = open_local_figures(fig_name);
fig = figs{1};

fig = set_fig_style(fig,Plot_Settings);
%-----------------------------
num_labels = size(labels,1);
for iLabel = 1:num_labels
    draw_annotation(fig,labels(iLabel));
end
%------------------------------
save_fig(fig,fig_name + "_annotated")