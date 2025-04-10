function obj = swap_colours(obj,old_colour,new_colour,type)
if nargin == 3
    type = "all";
end

if isscalar(old_colour)
    old_colour = get_plot_colours(old_colour);
end
if isscalar(new_colour)
    new_colour = get_plot_colours(new_colour);
end


if type == "lines" || type == "all"
    lines = findobj(obj,"Color",old_colour);
    arrayfun(@(line) set(line,"Color",new_colour),lines);
end

if type == "markers" || type == "all"
    markers = findobj(obj,"MarkerFaceColor",old_colour);
    arrayfun(@(line) set(line,"MarkerFaceColor",new_colour),markers);
end

end