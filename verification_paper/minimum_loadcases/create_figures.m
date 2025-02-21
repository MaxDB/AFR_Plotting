clear
close all

fig_name = "min_loadcases";
%----

dims = 2:4;
min_degree = 3;
max_degree = 9;


get_T_pot = @(degree,num_dims) num_poly_terms(3,degree+1,num_dims);
get_T_lin = @(degree,num_dims) num_poly_terms(2,degree,num_dims);


degree_range = min_degree:max_degree;
num_degrees = size(degree_range,2);
num_dims = size(dims,2);


force_degree_loadcases = zeros(num_dims,num_degrees);
disp_degree_loadcases = zeros(num_dims,num_degrees);
for iDim = 1:num_dims
    dim = dims(iDim);

    for iDegree = 1:num_degrees
        degree = degree_range(iDegree);
        T_pot = get_T_pot(degree,dim);
        T_lin = get_T_lin(degree,dim);

        force_degree_loadcases(iDim,iDegree) = ceil(T_pot/dim);
        disp_degree_loadcases(iDim,iDegree) = T_lin;
    end
end


plot_colours = get_plot_colours([1:6,8]);
bar_spacing = 0.1;
fig = figure;
T = tiledlayout(1,num_dims);
T.TileSpacing = 'compact';
T.Padding = 'compact';

tile_titles = ["a) $R=2$", "b) $R=3$", "c) $R=4$"];
for iDim = 1:num_dims
    ax = nexttile;
    box on
    hold on
    bar(degree_range,disp_degree_loadcases(iDim,:),"FaceColor",plot_colours(1,:),"BarWidth",1)
    bar(degree_range,force_degree_loadcases(iDim,:),"FaceColor",plot_colours(2,:),"BarWidth",0.7)
    xticks(degree_range)
    xtickangle(0)
    hold off
    xlabel("Polynomial degree")
    ylim([0,disp_degree_loadcases(iDim,end)])
    xlim([2.5,9.5])
    if iDim == 1
        ylabel("Minimum loadcases")
        leg = legend("$I_x$","$I_f$","Interpreter","latex","Location","northwest");
        leg.IconColumnWidth = 10;
    end
    title(tile_titles(iDim),"Interpreter","latex")
    ax.TitleHorizontalAlignment = "left";
end

save_fig(fig,fig_name)
%-------------------------------------------------------------------------
function num_terms = num_poly_terms(min_degree,max_degree,num_dims)
num_degree_terms = @(degree) nchoosek(degree + num_dims -1,num_dims -1);


degrees = min_degree:max_degree;
num_terms = 0;
for iDegree = degrees
    num_terms = num_terms + num_degree_terms(iDegree);
end
end
%------------------------------------------

