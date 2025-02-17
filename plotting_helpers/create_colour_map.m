function colour_map = create_colour_map(colours,num_points)
if isstring(colours) && colours == "map"
    colour_map_base = get_plot_colours(colours);
    num_colours = size(colour_map_base,1);
    t_base = linspace(0,1,num_colours);
    t_full = linspace(0,1,num_points);

    colour_map = zeros(num_points,3);
    for iTriplet = 1:3
        colour_map(:,iTriplet) = interp1(t_base,colour_map_base(:,iTriplet),t_full);
    end
    return
end

colour_one = colours(1);
colour_two = colours(2);
if isscalar(colour_one)
    colour_one = get_plot_colours(colour_one);
end
if isscalar(colour_two)
    colour_two = get_plot_colours(colour_two);
end

colour_map = zeros(num_points,3);
for iBase = 1:3
    colour_map(:,iBase) = linspace(colour_one(iBase),colour_two(iBase),num_points);
end

end