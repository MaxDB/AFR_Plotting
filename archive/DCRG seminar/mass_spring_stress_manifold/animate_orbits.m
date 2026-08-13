clear
close all

sol_ids = [1,1,1];
orbit_ids = [10,66,90];
disp_scale_factors = [10,2,2];
speed_scale_factors = [1,1,1];
mass_colours = get_plot_colours([4,5,6]);

plot_order = [3,2,1];
slow_down_factor = 4;
FRAME_RATE = 20;
            

%--------------------
data_directory = get_project_path + "\examples\3_dof_mass_spring";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});


Dyn_Data = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_12");
Rom = Dyn_Data.Dynamic_Model;

num_orbits = size(orbit_ids,2);

for iOrbit = 1:num_orbits
 
    Orbit = data_dir_execute(@Dyn_Data.get_orbit,sol_ids(iOrbit),orbit_ids(iOrbit));
    t = Orbit.tbp*slow_down_factor;
    r = Orbit.xbp';
    num_modes = size(r,1)/2;
    r = r(1:num_modes,:);

    x = Rom.expand(r);

    %--------------------
    open("figures\stress_manifold_comp_export.fig")
    fig = gcf;

    fig.Position(4) = fig.Position(4)*0.92;
    fig.Color = [0.8,0.8,0.8];
    ax = gca;
    xlim(ax,ax.XLim);
    ylim(ax,ax.YLim);
    zlim(ax,ax.ZLim);

    lines = findobj(ax,"-property","XData");
    set(lines,"Visible","off")
    axis("off")

    %-----------------
    frame_t = t(1):1/FRAME_RATE:t(end);

    num_frames = size(frame_t,2);
    num_dof = size(x,1);
    frame_x = zeros(num_dof,num_frames);
    
    for iDof = 1:num_dof
        frame_x(iDof,:) = interp1(t,x(iDof,:),frame_t);
    end
    if exist("system_frames","var")
        clear("system_frames")
    end
    system_frames(num_frames) = struct('cdata',[],'colormap',[]); %#ok<SAGROW>
    hold(ax,"on")
    ani_marker = plot3(ax,0,0,0,"o","MarkerSize",8,"LineWidth",1,"MarkerEdgeColor","w","MarkerFaceColor",mass_colours(iOrbit,:));
    hold(ax,"off")

    if iOrbit == 2
        is_visible = true(1,num_frames);
        is_visible([12:14,34:36]) = false;
        is_visible([103:105,126:128]) = false;
        is_visible([193:195,217:219]) = false;
    end
    
    for iFrame = 1:num_frames
        iDisp = frame_x(:,iFrame);
        ani_marker.XData = iDisp(plot_order(1));
        ani_marker.YData = iDisp(plot_order(2));
        ani_marker.ZData = iDisp(plot_order(3));
        if iOrbit == 2
            if is_visible(iFrame)
                ani_marker.Visible ="on";
            else
                ani_marker.Visible = "off";
            end
        end
        drawnow
        system_frames(iFrame) = getframe(fig);
        if iFrame == num_frames
            break
        end
    end

    animation.frames = system_frames;
    animation.frame_rate = FRAME_RATE;
    animation.num_frames = num_frames;
    animation.fig_size = fig.Position;
    animation.ax_size = ax.Position;
    %-----------------
    export_gif(animation,"orbit_marker_" + iOrbit)
    close all
end

