clear 
close all

fig_name = "stress_manifold_comp";




labels = ["One mode subspace";
          "Two mode subspace"];

%-----------------------------

figs = open_local_figures(fig_name+"_export");
fig = figs{1};

ax = fig.Children;
lines = findall(ax,"Type","Line");
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    if isempty(line.Tag)
        continue
    end
    if line.Tag(1:2) == "o-"
        line.Color = [line.Color,0.2];
    end
end


%-----------------------------
num_labels = size(labels,1);
for iLabel = 1:num_labels
    draw_annotation(fig,labels(iLabel,:));
end
%------------------------------
export_fig(fig,fig_name + "_annotated","inherit")