function force_group = draw_force(ax,force_direction,mass_centre,mass_radius)

position = "west";
line_width = 4;
colour = get_plot_colours(3);

head_length_frac = 0.2;
head_angle = 30*(pi/180);

force_style = {"color",colour,"LineWidth",line_width};
force_group = hggroup;

%---
arrow_start_offset = [0;0];
switch position
    case "north"
        arrow_start_offset(2) = 1; 
    case "east"
        arrow_start_offset(1) = 1; 
    case "south"
        arrow_start_offset(2) = -1; 
    case "west"
        arrow_start_offset(1) = -1; 
end

arrow_start_offset = arrow_start_offset*mass_radius*1.2;
arrow_start = mass_centre' + arrow_start_offset;

arrow_vec = [0;0];
switch force_direction
    case "north"
        arrow_vec(2) = 1;
        head_direction = [sin(head_angle);-cos(head_angle)];
    case "east"
        arrow_vec(1) = 1; 
        head_direction = [-cos(head_angle);-sin(head_angle)];
    case "south" 
        arrow_vec(2) = -1; 
        head_direction = [sin(head_angle);cos(head_angle)];
    case "west"
        arrow_vec(1) = -1; 
        head_direction = [sin(head_angle);cos(head_angle)];
end
% arrow_end = arrow_start + arrow_vec*mass_radius*2*0.015/0.02;
arrow_end = arrow_start + arrow_vec*mass_radius*2;

force_line = plot(ax,[arrow_start(1),arrow_end(1)],[arrow_start(2),arrow_end(2)],"Tag","force_line",force_style{:});
set(force_line,"Parent",force_group);

head_length = norm(arrow_end-arrow_start)*head_length_frac;
head_end_1 = arrow_end + head_length*head_direction;
head_end_2 = arrow_end + head_length*head_direction.* sign(-(abs(flip(arrow_vec))) +0.1);

% head_end_cw = plot(ax,[arrow_end(1),head_end_1(1)],[arrow_end(2),head_end_1(2)],"Tag","head_cw",force_style{:});
% head_end_ccw = plot(ax,[arrow_end(1),head_end_2(1)],[arrow_end(2),head_end_2(2)],"Tag","head_cw",force_style{:});
head_tip = plot(ax,arrow_end(1),arrow_end(2),"Marker","^","Tag","head_tip",force_style{:});

% set(head_end_cw,"Parent",force_group);
% set(head_end_ccw,"Parent",force_group);
set(head_tip,"Parent",force_group)
end