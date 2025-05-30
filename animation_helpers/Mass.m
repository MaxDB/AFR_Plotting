classdef Mass
    properties
        mass_radius
        mass_centre

        boundary_conditions

        mass_id
        animation_axis
        graphical_group
    end

    methods
        function obj = Mass(id,ax,centre,radius,bcs)
            obj.mass_id = id;
            obj.animation_axis = ax;
            obj.mass_radius = radius;
            obj.mass_centre = centre;

            if nargin == 4
                bcs = "free";
            end
            obj.boundary_conditions = bcs;

            mass_group = draw_mass(ax,centre,radius,bcs);
            mass_transform = hgtransform(ax);
            mass_group.Parent = mass_transform;

            obj.graphical_group = mass_transform;
        end
        %---------------------

        function obj = update_state(obj,state)
            state_change = state';
            
            shift_matrix = makehgtform("translate",[state_change,0]);

            mass_group = obj.graphical_group;
            mass_group.Matrix = shift_matrix;
        end
    end
end