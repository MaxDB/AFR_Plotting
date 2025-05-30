classdef Mass_Spring_System
    properties
        animated_masses
        num_animated_masses

        animated_springs
        num_animated_springs

        mass_spring_connections
        degrees_of_freedom
        animation_ax

        base_state

        animation_function
    end

    methods
        function obj = Mass_Spring_System(masses,springs,dofs_description,connections,ax)
            obj.animated_masses = masses;
            num_masses = size(masses,2);
            obj.num_animated_masses = num_masses;

            obj.animated_springs = springs;
            obj.num_animated_springs = size(springs,2);

            
            obj.animation_ax = ax;
            
            state = zeros(2*num_masses,1);
            for iMass = 1:num_masses
                state_span = (2*(iMass-1) + 1):(2*iMass);
                state(state_span) = masses{iMass}.mass_centre;
            end
            obj.base_state = state;
            obj.degrees_of_freedom = Mass_Spring_System.parse_dofs(dofs_description,state);

            obj.mass_spring_connections = Mass_Spring_System.parse_connections(obj.degrees_of_freedom,obj.num_animated_springs,connections);

            obj.set_axes_limits
        end
        %-----------------
        function set_axes_limits(obj)
            ax = obj.animation_ax;
            lines = findobj(ax,"-property","YData");
            num_lines = size(lines,1);
            x_lim = ax.XLim;
            y_lim = ax.YLim;

            x_range = [0,0];
            y_range = [0,0];
            for iLine = 1:num_lines
                line = lines(iLine);
                x_range(1) = min(x_range(1),min(line.XData));
                x_range(2) = max(x_range(2),max(line.XData));
                y_range(1) = min(y_range(1),min(line.YData));
                y_range(2) = max(y_range(2),max(line.YData));
            end
        

        xlim(x_range)
        ylim(y_range)
        
        ax_width = diff(x_range);
        ax_height = diff(y_range);
        ax_aspect = ax_width/ax_height;
        
        fig = ax.Parent;
        fig_dims = fig.Position;
        
        fig_width = fig_dims(3);
        fig_height = fig_dims(4);
        fig_aspect = fig_width/fig_height; 
       
        if ax_aspect < fig_aspect 
            %need to reduce figure width
            fig.Position(3) = fig_height*ax_aspect;
            
        elseif ax_ratio > fig_aspect
            %need to reduce figure height
            fig.Position(4) = fig_width/ax_aspect;
        end
        set(ax,"Color",[1,1,1,0])
        set(fig,"Color",[1,1,1,0])

        % x_system_span = diff(x_range);
        % y_system_span = diff(y_range);
        % 
        % if x_system_span > y_system_span
        %     xlim(x_range)
        % else
        %     ylim(y_range)
        % end
        % 
        % x_length = diff(x_lim);
        % 
        % x_padding = (x_length - x_system_span)/2;
        % xlim(ax,x_range + [-x_padding,+x_padding])
        % 
        % y_length = diff(y_lim);
        % 
        % y_padding = (y_length - y_system_span)/2;
        % ylim(ax,y_range + [-y_padding,y_padding])

        end
        %-----------------
        function obj = set_displacement(obj,x)
            dofs = obj.degrees_of_freedom;
            
            connections = obj.mass_spring_connections;

            displacement = dofs*x;
           
            mass_change = displacement;
            spring_change = connections*displacement;
            
            obj = obj.set_state(mass_change,spring_change);
        end
        %-----------------
        function obj = set_state(obj,mass_change,spring_change)
            masses = obj.animated_masses;
            num_masses = obj.num_animated_masses;

            for iMass = 1:num_masses
                state_span = (2*(iMass-1) + 1):(2*iMass);
                Mass = masses{iMass};
                Mass.update_state(mass_change(state_span));
            end
            
            springs = obj.animated_springs;
            num_springs = obj.num_animated_springs;

            for iSpring = 1:num_springs
                spring_span = (4*(iSpring-1) + 1):(4*iSpring);
                Spring = springs{iSpring};
                Spring.update_state(spring_change(spring_span));
            end
        end


        %--------------
        function obj = setup_animation_function(obj,Dyn_Data,data_dir_execute)
            Rom = Dyn_Data.Dynamic_Model;
            obj.animation_function = @(sol_num,orbit_id) get_animation_data(sol_num,orbit_id,Dyn_Data,Rom,data_dir_execute);


            function [t,x] = get_animation_data(sol_num,orbit_id,Dyn_Data,Rom,data_dir_execute)
                Orbit = data_dir_execute(@Dyn_Data.get_orbit,sol_num,orbit_id);
                t = Orbit.tbp';
                state = Orbit.xbp';
                state_size = size(state,1);

                displacement = state(1:(state_size/2),:);
                x = Rom.expand(displacement);
            end
        end


        %--------------
        function animation = animate_orbit(obj,sol_num,orbit_id,animation_scale_factor,frame_rate)
            

           


            [t,x] = obj.animation_function(sol_num,orbit_id);
            
            frame_t = t(1):1/frame_rate:t(end);

            num_frames = size(frame_t,2);
            num_dof = size(x,1);
            frame_x = zeros(num_dof,num_frames);
            for iDof = 1:num_dof
                frame_x(iDof,:) = interp1(t,x(iDof,:),frame_t);
            end
            
            animation = obj.animate_displacement(frame_t,frame_x,animation_scale_factor,frame_rate);
            
        end
        %--------------
        function animation = animate_displacement(obj,frame_t,frame_x,animation_scale_factor,frame_rate)
             num_frames = size(frame_t,2);
            if nargin == 3
                animation_scale_factor = 1;
                period = frame_t(end) - frame_t(1);
                frame_rate = num_frames/period;
            end
            
            ax = obj.animation_ax;
            fig = ax.Parent;
           

            fig_dims = fig.Position;
            fig_width = fig_dims(3);
            fig_height = fig_dims(4);
            max_scale_factor = min(1280/fig_width,720/fig_height);

            fig.Position = [10,100,fig_width*max_scale_factor,fig_height*max_scale_factor];

            system_frames(num_frames) = struct('cdata',[],'colormap',[]);
            for iFrame = 1:num_frames
                iDisp = frame_x(:,iFrame).*animation_scale_factor;
                obj.set_displacement(iDisp);
                drawnow
                system_frames(iFrame) = getframe(obj.animation_ax);
                if iFrame == num_frames
                    break
                end
            end


            animation.frames = system_frames;
            animation.frame_rate = frame_rate;
            animation.num_frames = num_frames;
            animation.size = fig.Position;

            fig.Position = fig_dims;
        end

        %--------------
        %-- Style

        %--------------
        function set_mass_colour(obj,colour)
            masses = obj.animated_masses;
            num_masses = obj.num_animated_masses;

            for iMass = 1:num_masses
                Mass = masses{iMass};
                mass_circle = findobj(Mass.graphical_group,"Tag","mass");
                mass_circle.Color = colour;
            end

        end

    end

    %---------------------------------------------------------------------------
    methods(Static)
        function dof_shapes = parse_dofs(dofs_description,state)
            num_dofs = size(dofs_description,2);
            state_size = size(state,1);
            dof_shapes = zeros(state_size,num_dofs);

            for iDof = 1:num_dofs
                dof = dofs_description{iDof};
                mass_id = dof{1};
                cardinal_direction = dof{2};

                state_span = (2*(mass_id-1) + 1):(2*mass_id);
                switch cardinal_direction
                    case "north"
                        direction = 1;
                        state_span = state_span(2);
                    case "west"
                        direction = -1;
                        state_span = state_span(1);
                    case "east"
                        direction = 1;
                        state_span = state_span(1);
                    case "south"
                        direction = -1;
                        state_span = state_span(2);
                end
                dof_shapes(state_span,iDof) = direction;  
            end
        end
        %---------------------------------
        function connection_shapes = parse_connections(dofs,num_springs,connections)
            DIRECTIONS = ["north","east","south","west"];
            num_directions = size(DIRECTIONS,2);
            num_masses = size(connections,2);
            
            num_dofs = size(dofs,2);
            state_size = size(dofs,1);
 
            connection_shapes = zeros(4*num_springs,state_size);
            for iMass = 1:num_masses
                connection = connections{iMass};
                mass_span = (2*(iMass-1) +1):(2*iMass);
                mass_dofs = dofs(mass_span,:);
                for iDirection = 1:num_directions
                    direction_connection = connection(DIRECTIONS(iDirection));
                    if direction_connection == 0
                        continue
                    end
                    spring_id = abs(direction_connection);
                    spring_span = (4*(spring_id-1) + 1):(4*spring_id);

                    direction = sign(direction_connection);
                    if direction == 1
                        spring_state = spring_span(3:4);
                    else
                        spring_state = spring_span(1:2);
                    end
                    connection_shapes(spring_state,:) = mass_dofs*dofs';

                end
            end

        end
        %---------------------------------
    end

end