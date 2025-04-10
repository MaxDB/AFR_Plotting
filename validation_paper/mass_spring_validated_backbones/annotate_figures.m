clear 
close all

fig_name = "validated_backbone";


% labels = {"$\mathcal R_1:\mathcal R_2$" + newline + "validation","label";
%           "$\mathcal R_2$-ROM","label";
%           "$\mathcal R_1$-ROM","label";
%           "3 rad/s",{"text","rotation",-90}};

labels = {"One mode ROM","label";
          "Two mode ROM","label";
          "Validation","label"
          "Example orbit","label"};

%-----------------------------

figs = open_local_figures(fig_name+"_export");
fig = figs{1};
%-----------------------------
num_labels = size(labels,1);
for iLabel = 1:num_labels
    draw_annotation(fig,labels(iLabel,:));
end
%------------------------------
export_fig(fig,fig_name + "_annotated","inherit")