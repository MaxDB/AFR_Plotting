function mass_group = draw_mass(ax,centre,radius,boundary,force_direction,Plot_Style)
mass_style = {"LineWidth",Plot_Style.thickness};

hold(ax,"on")
mass_group = viscircles(ax,centre,radius,"EnhanceVisibility",0,mass_style{:});
set(mass_group.Children,"Tag","mass");


if ~isempty(force_direction)
    force_group = draw_force(ax,force_direction,centre,radius);
    force_transform = hgtransform(ax);
    if ~isempty(force_group.Children)
        set(force_group,"Parent",force_transform,"Tag","force group")
        set(force_transform,"Parent",mass_group,"Tag","force transform")
    end
end

switch boundary
    case "free"
        return
    case "roller east"
        boundary_coords = centre + [radius,0];
        boundary_type = "wall roller";
        direction = 1;

end
boundary_group = draw_boundary(ax,boundary_type,boundary_coords,direction);
if ~isempty(boundary_group.Children)
    set(boundary_group,"Parent",mass_group)
end
hold(ax,"off")
end