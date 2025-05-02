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
        function obj = animate_orbit(obj,sol_num,orbit_id)
            num_repeats = 100;
            [t,x] = obj.animation_function(sol_num,orbit_id);

            num_time_points = size(t,2);
            for iRepeat = 1:num_repeats
                for iTime = 1:num_time_points
                    iDisp = x(:,iTime);
                    obj.set_displacement(iDisp);
                    if iTime == num_time_points
                        break
                    end
                    delay = t(iTime+1) - t(iTime);
                    pause(delay)
                end
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