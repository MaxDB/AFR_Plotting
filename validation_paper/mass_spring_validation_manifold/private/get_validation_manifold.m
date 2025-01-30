function [x_hat,orbit_point,validation_point] = get_validation_manifold(t_value,Dyn_Data,orbit_data,ax_lims,offset)
PLOT_RESOLUTION = 2;
SCALE_CUTOFF = 1;
MAX_SCALE_FACTOR = 1.1;


[Orbit, Validation_orbit] = Dyn_Data.get_orbit(orbit_data(1),orbit_data(2),1);
Rom = Dyn_Data.Dynamic_Model;

z = Orbit.xbp';
num_r_modes = size(z,1)/2;
r_t = z(1:num_r_modes,t_value);



x_tilde_t = Rom.Physical_Displacement_Polynomial.evaluate_polynomial(r_t);
x_hat_grad_t = Rom.Low_Frequency_Coupling_Gradient_Polynomial.evaluate_polynomial(r_t);

[~,t_max] = max(Validation_orbit.h,[],2);
[~,t_min] = min(Validation_orbit.h,[],2);

r_max = z(1:num_r_modes,t_max);
r_min = z(1:num_r_modes,t_min);

x_tilde_max = Rom.Physical_Displacement_Polynomial.evaluate_polynomial(r_max);
x_tilde_min = Rom.Physical_Displacement_Polynomial.evaluate_polynomial(r_min);




lim_diff = diff(ax_lims,1,2);
num_h_modes = size(Validation_orbit.h,1);
orbit_lim = zeros(num_h_modes,2);
for iMode = 1:num_h_modes
    h_max = Validation_orbit.h(:,t_max(iMode));
    h_min = Validation_orbit.h(:,t_min(iMode));

    x_hat_grad_max = Rom.Low_Frequency_Coupling_Gradient_Polynomial.evaluate_polynomial(r_max(iMode));
    x_hat_grad_min = Rom.Low_Frequency_Coupling_Gradient_Polynomial.evaluate_polynomial(r_min(iMode));

    x_hat_max = x_tilde_max(:,iMode) + x_hat_grad_max*h_max;
    x_hat_min = x_tilde_min(:,iMode) + x_hat_grad_min*h_min;

    x_hat_diff = diff([x_hat_min,x_hat_max],1,2);
    diff_comp = abs(x_hat_diff./lim_diff);
    scale_factor = 1;
    if all(diff_comp < SCALE_CUTOFF) 
        scale_factor = SCALE_CUTOFF/max(diff_comp);
    end
    orbit_lim(iMode,:) = min(scale_factor,MAX_SCALE_FACTOR)*[h_min(iMode),h_max(iMode)];
end
%-------


x = linspace(orbit_lim(1,1),orbit_lim(1,2),PLOT_RESOLUTION);
y = linspace(orbit_lim(2,1),orbit_lim(2,2),PLOT_RESOLUTION);

[X,Y] = meshgrid(x,y);

num_points = PLOT_RESOLUTION^2;
X_array = reshape(X,1,num_points);
Y_array = reshape(Y,1,num_points);
h_array = [X_array;Y_array];


x_hat = x_tilde_t + x_hat_grad_t*h_array;
num_dof = size(x_hat,1);
x_hat = reshape(x_hat,[num_dof,size(X)]);
x_hat = permute(x_hat,[2,3,1]);



% get normal
x1_norm = x_hat_grad_t(:,1);
x2_norm = x_hat_grad_t(:,2);

normal = cross(x1_norm,x2_norm);
for iCoord = 1:3
    x_hat(:,:,iCoord) = x_hat(:,:,iCoord) + normal(iCoord)*offset;
end


orbit_point = x_tilde_t;

h_t = Validation_orbit.h(:,t_value);
validation_point = x_tilde_t + x_hat_grad_t*h_t;
end