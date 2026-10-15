clear
close all
fig_name = "orbit_stability";

%----------------------------------
frequency_range = [800,1000];
x_lim_sub = [-1.7,0.1];
x_lim_main = [-1,1]*diff(x_lim_sub);

%-----
data_directory = get_project_path + "\examples\validation\pinned_beam";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

Dyn_Data = data_dir_execute(@initalise_dynamic_data,"pinned_beam_-40_1");

[orbit_evals_temp,orbit_evecs] = data_dir_execute(@get_statbility_data,Dyn_Data,3,frequency_range);
perturbed_modes_temp = process_evecs(orbit_evecs);
[perturbed_modes,mode_order] = sort(perturbed_modes_temp);

num_modes = size(perturbed_modes,1)/2;
num_orbits = size(perturbed_modes,2);

orbit_evals = zeros(size(orbit_evals_temp));
for iOrbit = 1:num_orbits
    orbit_evals(:,iOrbit) = orbit_evals_temp(mode_order(:,iOrbit),iOrbit);
end

perturbed_modes_all = zeros(num_modes,num_orbits,2);
orbit_evals_all = zeros(num_modes,num_orbits,2);

perturbed_modes_all(:,:,1) = perturbed_modes(8:14,:);
orbit_evals_all(:,:,1) = orbit_evals(8:14,:);

perturbed_modes_all(:,:,2) = flip(perturbed_modes(1:num_modes,:));
orbit_evals_all(:,:,2) = flip(orbit_evals(1:num_modes,:));

orbit_evals_sorted = sort_eigenvalues(orbit_evals_all);

%-----
plot_eval = @(ax,mode,direction,index,style) plot(real(orbit_evals_sorted(mode,index,direction)),imag(orbit_evals_sorted(mode,index,direction)),style{:});

fig = figure;
tiles = tiledlayout(1,4);
tiles.Padding = "compact";
tiles.TileSpacing = "tight";
ax = nexttile;
ax = set_ax_style(ax);
colour = get_plot_colours(2);

for iDirection = 1:2
    plot_eval(ax,2,iDirection,':',{"-","Color",colour,"LineWidth",2})
    plot_eval(ax,2,iDirection,1,{"o","Color",colour,"LineWidth",2,"MarkerFaceColor","w"})
    plot_eval(ax,2,iDirection,num_orbits,{"o","MarkerEdgeColor","w","LineWidth",2,"MarkerFaceColor",colour})
 
end

xlim(ax,x_lim_sub)
ylim(ax,x_lim_main)
ylabel("Imag \lambda")
y_ticks = ax.YTick;

%---
ax = nexttile;
ax = set_ax_style(ax);
colour = get_plot_colours(3);

for iDirection = 1:2
    plot_eval(ax,3,iDirection,':',{"-","Color",colour,"LineWidth",2})
    plot_eval(ax,3,iDirection,1,{"o","Color",colour,"LineWidth",2,"MarkerFaceColor","w"})
    plot_eval(ax,3,iDirection,num_orbits,{"o","MarkerEdgeColor","w","LineWidth",2,"MarkerFaceColor",colour})
end

xlim(ax,x_lim_sub)
ylim(ax,x_lim_main)
yticklabels(ax,[])
yticks(ax,y_ticks);

%---
ax = nexttile([1,2]);
ax = set_ax_style(ax);
for iMode = [1,4,5,6,7]
    colour = get_plot_colours(iMode);
    for iDirection = 1:2
        plot_eval(ax,iMode,iDirection,':',{"-","Color",colour,"LineWidth",2})
        plot_eval(ax,iMode,iDirection,1,{"o","Color",colour,"LineWidth",2,"MarkerFaceColor","w"})
        plot_eval(ax,iMode,iDirection,num_orbits,{"o","MarkerEdgeColor","w","LineWidth",2,"MarkerFaceColor",colour})
    end
end

xlim(ax,x_lim_main)
ylim(ax,x_lim_main)
yticklabels(ax,[])
yticks(ax,y_ticks);

%-------------------
save_fig(fig,fig_name)


%----------
function ax = set_ax_style(ax)
hold(ax,"on")
box(ax,"on")
daspect(ax,[1,1,1])
theta = linspace(-pi,pi,100);
plot(ax,cos(theta),sin(theta),"--","Color",get_plot_colours("grey"))
xlabel("Real \lambda")
end

%---

function [orbit_evals,orbit_evecs] = get_statbility_data(Dyn_Data,sol_num,freq_range)
Sol_v = Dyn_Data.load_solution(sol_num,"validation");
num_orbits = size(Sol_v.h_energy,2);

if nargin == 3
    Sol = Dyn_Data.load_solution(sol_num);
    freq = Sol.frequency;
    in_range = (freq >= freq_range(1)) & (freq <= freq_range(2));
end


num_validation_modes = size(Sol_v.h_amplitude,1);
orbit_evecs = zeros(2*num_validation_modes,2*num_validation_modes,num_orbits);
orbit_evals = zeros(2*num_validation_modes,num_orbits);
for iOrbit = 1:num_orbits
    [~,Orbit_v] = Dyn_Data.get_orbit(sol_num,iOrbit,1);
    orbit_evals(:,iOrbit) = Orbit_v.evals;
    orbit_evecs(:,:,iOrbit) =Orbit_v.evecs;
end

if nargin == 3
    orbit_evecs(:,:,~in_range) = [];
    orbit_evals(:,~in_range) = [];
end

end

function perturbed_modes = process_evecs(orbit_evecs)
num_orbits = size(orbit_evecs,3);
state_size = size(orbit_evecs,1);
perturbed_modes = zeros(state_size,num_orbits);
for iOrbit = 1:num_orbits
    perturbed_mode = zeros(1,state_size);

    orbit_evec = orbit_evecs(:,:,iOrbit);
    abs_orbit_evec = abs(orbit_evec);
    
    for iMult = 1:state_size
        [~,mode_id] = max(abs_orbit_evec(1:(state_size/2),iMult));
        
        perturbed_mode(iMult) = mode_id;
    end



    for iMode = 1:(state_size/2)
        col_index = perturbed_mode == iMode;
        row_index = iMode + [0,state_size/2];
        mode_evecs = orbit_evec(row_index,col_index);

        disp_equal = isapprox(mode_evecs(1,1),mode_evecs(1,2));
        vel_equal = isapprox(mode_evecs(2,1),mode_evecs(2,2));

        if ~disp_equal && vel_equal
            mode_sign = sign(imag(mode_evecs(1,:)));
        elseif ~disp_equal && ~vel_equal
            if all(isreal(mode_evecs))
                if all(diff(sign(mode_evecs),1,2) == 0)
                    mode_sign = [1,1];
                    [~,min_index] = min(mode_evecs(1,:));
                    mode_sign(min_index) = -1;
                end
            end
        end
        perturbed_modes(col_index,iOrbit) = mode_sign.*perturbed_mode(col_index);
    end
end

end

function evals_sorted = sort_eigenvalues(orbit_evals)
sort_type = [1,3,3,1,1,2,2];
num_modes = size(orbit_evals,1);
num_orbits = size(orbit_evals,2);

evals_sorted = zeros(num_modes,num_orbits,2);

for iMode = 1:num_modes
    orbit_eval = squeeze(orbit_evals(iMode,:,:))';
    eval_sorted = zeros(size(orbit_eval));
    eval_angle = angle(orbit_eval);


    is_positive = eval_angle >= 0;
    eval_sorted(1,is_positive(1,:)) = orbit_eval(1,is_positive(1,:));
    eval_sorted(1,is_positive(2,:)) = orbit_eval(2,is_positive(2,:));

    eval_sorted(2,~is_positive(1,:)) = orbit_eval(1,~is_positive(1,:));
    eval_sorted(2,~is_positive(2,:)) = orbit_eval(2,~is_positive(2,:));
    
    duplicate_index = diff(is_positive,1,1) == 0;
    if any(duplicate_index)
        eval_sorted(1,duplicate_index) = orbit_eval(1,duplicate_index);
        eval_sorted(2,duplicate_index) = orbit_eval(2,duplicate_index);
    end




    switch sort_type(iMode)
        case 2
            eval_angle = angle(eval_sorted);
            grad_sign_change = diff(sign(diff(eval_angle,1,2)),1,2);
            if find(grad_sign_change(1,:)) == find(grad_sign_change(2,:))
                swap_start = find(grad_sign_change(1,:),1) + 2;
                eval_temp = eval_sorted;

                eval_sorted(1,swap_start:end) = eval_temp(2,swap_start:end);
                eval_sorted(2,swap_start:end) = eval_temp(1,swap_start:end);
                

            end

        case 3
            eval_angle = angle(eval_sorted);
            angle_check = isapprox(eval_angle,0) | isapprox(eval_angle,pi);
            if find(angle_check(1,:),1) == find(angle_check(2,:),1)
                leave_start = find(angle_check(1,:),1);
                leave_index = leave_start:num_orbits;
                eval_abs = abs(eval_sorted(:,leave_index));
                abs_index = eval_abs >= 1;


                eval_temp = eval_sorted(:,leave_index);
                eval_sorted(1,leave_index(abs_index(1,:))) = eval_temp(1,abs_index(1,:));
                eval_sorted(1,leave_index(abs_index(2,:))) = eval_temp(2,abs_index(2,:));

                eval_sorted(2,leave_index(~abs_index(1,:))) = eval_temp(1,~abs_index(1,:));
                eval_sorted(2,leave_index(~abs_index(2,:))) = eval_temp(2,~abs_index(2,:));
            end

    end

    evals_sorted(iMode,:,:) = eval_sorted';
end


end
