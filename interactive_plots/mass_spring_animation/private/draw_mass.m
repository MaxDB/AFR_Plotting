function mass_group = draw_mass(ax,centre,radius,boundary)
hold(ax,"on")
mass_group = viscircles(ax,centre,radius,"EnhanceVisibility",0);


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