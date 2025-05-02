function boundary_group = draw_boundary(ax,boundary_type,boundary_coords,direction)
ground_size = 0.5;
ground_depth = 0.1;
roller_radius = 0.03;

boundary_style = {"color","k","LineWidth",1};

boundary_group = hggroup;

switch boundary_type
    case "wall"
        wall_y = boundary_coords(2) + [-ground_size,ground_size]/2;
        wall_x = boundary_coords(1) + [0,0];
        plot(ax,wall_x,wall_y,boundary_style{:});

        dims = [wall_x(1),wall_y(1),ground_depth,ground_size];
        angle = 0;
        if direction == -1
            dims(1) = dims(1) - dims(3);
        end
        plot_cross_hatching(ax,dims,angle,boundary_style)
    case "ground"
        ground_x = boundary_coords(1) + [-ground_size,ground_size]/2;
        ground_y = boundary_coords(2) + [0,0];
        plot(ax,ground_x,ground_y,boundary_style{:});

        dims = [ground_x(1),ground_y(1),ground_depth,ground_size];
        angle = -pi/2;
        if direction == 1
            dims(2) = dims(2) + dims(3);
        end
        plot_cross_hatching(ax,dims,angle,boundary_style)

    case "wall roller"
        support_height = 2*sqrt(3)*roller_radius;
        trig_x = boundary_coords(1) + [0,support_height,support_height];
        trig_y = boundary_coords(2) + [0,2*roller_radius,-2*roller_radius];

        trig_x(end+1) = trig_x(1);
        trig_y(end+1) = trig_y(1);

        plot(ax,trig_x,trig_y,"Parent",boundary_group,boundary_style{:});

        roller_centre = boundary_coords + [support_height+roller_radius,0];
        roller_centre = [roller_centre;roller_centre] + [0,roller_radius;0,-roller_radius];

        roller_group = viscircles(ax,roller_centre,roller_radius,"EnhanceVisibility",0,boundary_style{:});
        set(roller_group,"Parent",boundary_group);

        wall_y = boundary_coords(2) + [-ground_size,ground_size]/2;
        wall_x = boundary_coords(1) + support_height + 2*roller_radius + [0,0];
        plot(ax,wall_x,wall_y,boundary_style{:});

        dims = [wall_x(1),wall_y(1),ground_depth,ground_size];
        angle = 0;
        if direction == -1
            dims(1) = dims(1) - dims(3);
        end
        plot_cross_hatching(ax,dims,angle,boundary_style)

    case "ground roller"

    case "free"
        return
    otherwise
        error("Unrecognised boundary type: '" + boundary_type + "'")

end
end


function plot_cross_hatching(ax,dims,angle,style)
cross_angle = pi/4;
num_hatch_points = 10;

height = dims(4);
width = dims(3);

top_boundary = dims(2) + height;
top_line = [0;top_boundary];
top_line_direction = [1;0];

right_boundary = dims(1) + width;
right_line = [right_boundary;0];
right_line_direction = [0;1];

boundary_length = height + width;

direction = [cos(cross_angle);sin(cross_angle)];
intercept_mat_top = [direction,top_line_direction]^-1;
intercept_mat_right = [direction,right_line_direction]^-1;

vertical_boundary = sort([dims(2),dims(2)+height],"ascend");
horizontal_boundary = sort([dims(1),dims(1) + width],"ascend");


rotation_matrix = makehgtform("translate",[dims(1:2)';0],"zrotate",angle,"translate",[-dims(1:2)';0]);

hatch_points = linspace(0,boundary_length,10);
for iHatch = 1:num_hatch_points
    hatch_point = hatch_points(iHatch);
    
    if hatch_point <= height
        point_x = dims(1);
        point_y = top_boundary - hatch_point;
    else
        point_x = dims(1) + hatch_point - height;
        point_y = dims(2);
    end

    line_point = [point_x;point_y];

    intercept_top = intercept_mat_top*(line_point - top_line);
    intercept_right = intercept_mat_right*(line_point - right_line);


    end_point = line_point - intercept_top(1)*direction;
    if (vertical_boundary(1) <= end_point(2)) && (end_point(2) <= vertical_boundary(2))
        if (horizontal_boundary(1) <= end_point(1)) && (end_point(1) <= horizontal_boundary(2))

        else
            end_point = line_point - intercept_right(1)*direction;
        end
    else
        end_point = line_point - intercept_right(1)*direction;
    end

    line_point = rotation_matrix*[line_point;0;1];
    end_point = rotation_matrix*[end_point;0;1];

    x_points = [line_point(1),end_point(1)];
    y_points = [line_point(2),end_point(2)];
    plot(ax,x_points,y_points,style{:})
end

end