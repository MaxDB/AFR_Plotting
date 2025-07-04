function [spring_group,Spring_Data] = draw_spring(ax,end_coords,boundary,Plot_Style)

spring_style = {"Color","k","LineWidth",Plot_Style.thickness};

segment_angle = 80;
num_sections = 8; 
% Section:  /\    Segment: / and \     End segments: _ ... _
%             \/


segment_angle = segment_angle*pi/180;
[spring_coords,segment_length] = get_spring_segment_coords(num_sections,segment_angle,end_coords);

x_spring = spring_coords(1,:);
y_spring = spring_coords(2,:);


end_one = hggroup;
sections = hggroup;
end_two = hggroup;
spring_group = hggroup;

end_one_transform = hgtransform(spring_group);
section_transform = hgtransform(spring_group);
end_two_transform = hgtransform(spring_group);

set(end_two_transform,"Parent",spring_group)
set(section_transform,"Parent",spring_group)
set(end_one_transform,"Parent",spring_group)


set(end_two,"Parent",end_two_transform)
set(sections,"Parent",section_transform)
set(end_one,"Parent",end_one_transform)


hold(ax,"on")
plot(ax,x_spring(1:2),y_spring(1:2),"Parent",end_one,spring_style{:})
plot(ax,x_spring(2:(end-1)),y_spring(2:(end-1)),"Parent",sections,spring_style{:})
plot(ax,x_spring((end-1):end),y_spring((end-1):end),"Parent",end_two,spring_style{:})


for iBoundary = 1:2
    boundary_coords = end_coords(:,iBoundary);
    boundary_type = boundary(iBoundary);
    direction = 1;
    if iBoundary == 1
        direction = -1;
    end
    boundary_group = draw_boundary(ax,boundary_type,boundary_coords,direction);
    if ~isempty(boundary_group.Children)
        set(boundary_group,"Parent",spring_group)
    end
end


hold(ax,"off")



Spring_Data.segment_angle = segment_angle;
Spring_Data.num_sections = num_sections;
Spring_Data.segment_length = segment_length;
end


function [spring_coords,segment_length] = get_spring_segment_coords(num_sections,segment_angle,end_coords)

spring_length = sqrt(sum(diff(end_coords,1,2).^2));

segment_length = spring_length/(2+4*num_sections*cos(segment_angle));
segment_width = segment_length*cos(segment_angle);
segment_height = sqrt(segment_length^2-segment_width^2);


%assume horizontal and thne rotate if necessary
num_points = 2 + num_sections*4 + 1;
spring_coords = zeros(2,num_points);

spring_coords(:,1) = end_coords(:,1);

spring_coords(:,2) = spring_coords(:,1) + [segment_length;0];
point_counter = 2;
for iSection = 1:num_sections
    point_counter = point_counter + 1;
    spring_coords(:,point_counter) = spring_coords(:,point_counter - 1) + [segment_width;segment_height];
    point_counter = point_counter + 1;
    spring_coords(:,point_counter) = spring_coords(:,point_counter - 1) + [segment_width;-segment_height];
    point_counter = point_counter + 1;
    spring_coords(:,point_counter) = spring_coords(:,point_counter - 1) + [segment_width;-segment_height];
    point_counter = point_counter + 1;
    spring_coords(:,point_counter) = spring_coords(:,point_counter - 1) + [segment_width;+segment_height];
end

spring_coords(:,num_points) = spring_coords(:,num_points-1) + [segment_length;0];

if ~isapprox(spring_coords(:,end),end_coords(:,2))
    % transformation_matrix = [end_coords(:,1),end_coords(:,2)]/[spring_coords(:,1),spring_coords(:,end)];
    rotation_matrix = [0,-1;1,0];
    shift_vector = spring_coords(:,1);
    spring_coords = rotation_matrix*(spring_coords-shift_vector) + shift_vector;
end

end