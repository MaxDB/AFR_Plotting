function ax = plot_manifold(ax,X,Y,Z,z_index,Grid_Data)
MESH_ALPHA = 1;
GRID_DENSITY = 50;
colour_map = create_colour_map("map",256);
% colour_map = get_plot_colours("map");
colormap(flip(colour_map,1))

grid_line_style = {"Color",[0,0,0,MESH_ALPHA],"LineWidth",1,"Tag","grid_line"};
mesh_settings = {"EdgeColor","none","LineWidth",0.01,"FaceColor","interp","FaceLighting","gouraud","FaceAlpha",MESH_ALPHA,"Tag","force_manifold"};

%-------------------------------------------------
x_edge = X(:,end); 
y_edge = Y(:,end); 
z_grid = Z(:,end); 

hold(ax,"on")
surf(X,Y,Z,mesh_settings{:})
shading(ax,"interp")
plot3(x_edge,y_edge,z_grid,grid_line_style{:})
hold(ax,"off")

% light(ax,"Position",[0,0,1],"Color",0.8*[1,1,1])

x_spacing = 0.5;
y_spacing = 0.5;


x_coord = 0:x_spacing:Grid_Data.radius(1);
x_coord = [flip(-x_coord),x_coord(2:end)] + Grid_Data.centre(1);

y_coord = 0:y_spacing:Grid_Data.radius(2);
y_coord = [flip(-y_coord),y_coord(2:end)] + Grid_Data.centre(2);

get_edge_coord = @(coord_in,coord_num) get_ellipse_coord(coord_in,coord_num,Grid_Data.radius,Grid_Data.centre);

num_x_lines = size(x_coord,2);
hold(ax,"on")
for iLine = 1:num_x_lines
    y_edge = get_edge_coord(x_coord(iLine),1);
    y_grid = linspace(y_edge(1),y_edge(2),GRID_DENSITY);
    x_grid = repmat(x_coord(iLine),1,GRID_DENSITY);
    z_grid = Grid_Data.z_function(x_grid,y_grid,z_index);

    plot3(x_grid,y_grid,z_grid,grid_line_style{:})
end

num_y_lines = size(y_coord,2);
for iLine = 1:num_y_lines
    x_edge = get_edge_coord(y_coord(iLine),2);
    x_grid = linspace(x_edge(1),x_edge(2),GRID_DENSITY);
    y_grid = repmat(y_coord(iLine),1,GRID_DENSITY);
    z_grid = Grid_Data.z_function(x_grid,y_grid,z_index);

    plot3(x_grid,y_grid,z_grid,grid_line_style{:})
end
hold(ax,"off")


end

function coords_out = get_ellipse_coord(coord_in,coord_num,radii,centre)
    alpha = radii(3-coord_num);
    beta = radii(coord_num);

    norm_in = coord_in - centre(coord_num);
    norm_out = alpha*sqrt(1-(norm_in/beta)^2);

    coords_out = norm_out*[-1,1] + centre(3-coord_num);
end