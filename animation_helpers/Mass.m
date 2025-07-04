classdef Mass
    properties
        mass_radius
        mass_centre

        boundary_conditions

        mass_id
        animation_axis
        graphical_group
        Plotting_Style
    end

    methods
        function obj = Mass(id,ax,centre,radius,bcs,varargin)
             num_args = length(varargin);
            if mod(num_args,2) == 1
                error("Invalid keyword/argument pairs")
            end
            keyword_args = varargin(1:2:num_args);
            keyword_values = varargin(2:2:num_args);

            Plot_Style.thickness = 2;
            for arg_counter = 1:num_args/2
                switch keyword_args{arg_counter}
                    case "thickness"
                        Plot_Style.thickness = keyword_values{arg_counter};
                    otherwise
                        error("Invalid keyword: " + keyword_args{arg_counter})
                end
            end
            %----
            obj.mass_id = id;
            obj.animation_axis = ax;
            obj.mass_radius = radius;
            obj.mass_centre = centre;
            obj.Plotting_Style = Plot_Style;

    
            obj.boundary_conditions = bcs;

            mass_group = draw_mass(ax,centre,radius,bcs,Plot_Style);
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