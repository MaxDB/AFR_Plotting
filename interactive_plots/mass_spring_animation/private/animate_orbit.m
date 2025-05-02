function animate_orbit(System,Rom,Orbit,num_repeats)
time = Orbit.tbp';
state = Orbit.xbp';

num_time_points = size(time,2);
state_size = size(state,1);

displacement = state(1:(state_size/2),:);
x = Rom.expand(displacement);

for iRepeat = 1:num_repeats
    for iTime = 1:num_time_points
        iDisp = x(:,iTime);
        System.set_displacement(iDisp);
        if iTime == num_time_points
            break
        end
        delay = time(iTime+1) - time(iTime);
        pause(delay)
    end
end
end