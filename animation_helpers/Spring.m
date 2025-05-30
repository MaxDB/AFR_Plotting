classdef Spring
    properties
        initial_length
        boundary_conditions
        end_coords

        alignment
        spring_id

        animation_axis
        graphical_group

        number_of_sections
        segment_angle
        segment_length
    end

    methods
        function obj = Spring(id,ax,coords,bcs)
            obj.spring_id = id;
            obj.animation_axis = ax;
            obj.end_coords = coords;
            obj.boundary_conditions = bcs;
            obj.initial_length = sqrt(sum(diff(coords,1,2).^2));

            coords_diff = diff(coords,1,2);
            if coords_diff(1) == 0
                obj.alignment = "vertical";
            elseif coords_diff(2) == 0
                 obj.alignment = "horizontal";
            end

            [spring_group,Spring_Data] = draw_spring(ax,coords,bcs);
            obj.number_of_sections = Spring_Data.num_sections;
            obj.segment_angle = Spring_Data.segment_angle;
            obj.segment_length = Spring_Data.segment_length;

            spring_transform = hgtransform(ax);
            spring_group.Parent = spring_transform;

            obj.graphical_group = spring_transform;
        end
        %----------------------------------
        function obj = update_state(obj,state)
          
            num_sections = obj.number_of_sections;
            seg_length = obj.segment_length;
            seg_angle = obj.segment_angle;
            initial_coords = obj.end_coords;

            spring_x = (initial_coords(1,2) + state(3) - initial_coords(1,1) - state(1)).^2;
            spring_y = (initial_coords(2,2) + state(4) - initial_coords(2,1) - state(2)).^2;

            length_change = sqrt(spring_x + spring_y) - obj.initial_length;

            segment_width_one = seg_length*cos(seg_angle);
            segment_width_change = length_change/(4*num_sections);
            segment_width_two = segment_width_one + segment_width_change;
            width_raio = segment_width_two/segment_width_one;

            segment_height_one = sqrt(seg_length^2-segment_width_one^2);
            segment_height_two = sqrt(seg_length^2-segment_width_two^2);
            height_ratio = segment_height_two/segment_height_one;

            %----------

            end_one_shift_vector = [initial_coords(:,1);0];
            end_two_shift_vector = [initial_coords(:,2);0];

            spring_angle_one = obj.get_spring_angle(initial_coords);
            spring_angle_two = obj.get_spring_angle(initial_coords + [state(1:2),state(3:4)]);

            align_end_one_horizontally = makehgtform("zrotate",-spring_angle_one,"translate",-end_one_shift_vector);
            align_end_two_horizontally = makehgtform("zrotate",-spring_angle_one,"translate",-end_two_shift_vector);
            
            segment_shift_left = makehgtform("translate",[-seg_length;0;0]);
            segment_shift_right = makehgtform("translate",[seg_length;0;0]);

            scale_sections = makehgtform("scale",[width_raio,height_ratio,1]);

            return_end_one_position = makehgtform("translate",end_one_shift_vector,"zrotate",spring_angle_two);
            return_end_two_position = makehgtform("translate",end_two_shift_vector,"zrotate",spring_angle_two);
            end_one_change = makehgtform("translate",[state(1:2);0]);
            end_two_change = makehgtform("translate",[state(3:4);0]);
            
            
            end_one_transform = end_one_change*return_end_one_position*align_end_one_horizontally;
            sections_transform = end_one_change*return_end_one_position*segment_shift_right*scale_sections*segment_shift_left*align_end_one_horizontally;
            end_two_transform = end_two_change*return_end_two_position*align_end_two_horizontally;

            spring_group = obj.graphical_group;
            end_one = spring_group.Children.Children(3);
            sections = spring_group.Children.Children(2);
            end_two = spring_group.Children.Children(1);

            end_one.Matrix = end_one_transform;
            sections.Matrix = sections_transform;
            end_two.Matrix = end_two_transform;

            % initial_position = [[initial_coords(:,1);0],[initial_coords(:,2);0],[0;0;1]];
            % final_position = initial_position + [[state(1:2);0],[state(3:4);0],[0;0;0]];
            % 
            % transformation_matrix = zeros(4);
            % transformation_matrix(1:3,1:3) = final_position/initial_position;
            % transformation_matrix(4,4) = 1;

            
        end
        %----------------------------------
        function spring_angle = get_spring_angle(~,coords)

            coords_diff = diff(coords,1,2);
            spring_angle = atan2(coords_diff(2),coords_diff(1));
  
        end
    end
end