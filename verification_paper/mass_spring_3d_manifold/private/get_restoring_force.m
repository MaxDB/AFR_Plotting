function [x1,x2,f1,f2,Grid_Data] = get_restoring_force(x1_lim,x2_lim)
omega_1 = 1;
omega_2 = 5;
NUM_R = 30;
NUM_THETA = 50;
mesh_points = NUM_R * NUM_THETA;

a1 = x1_lim(2);
a2 = abs(x1_lim(1));
b1 = x2_lim(2);
b2 = abs(x2_lim(1));

centre_x = (a1-a2)/2;
centre_y = (b1-b2)/2;

r1 = [a2 + centre_x,a1 - centre_x];
r2 = [b2 + centre_y,b1 - centre_y];


r_base = linspace(0,1,NUM_R);
theta = linspace(-pi,pi,NUM_THETA);

quad_pp = theta >= 0 & theta < pi/2;
quad_pm = theta >= -pi/2 & theta < 0;
quad_mm = theta >= -pi & theta < -pi/2;
quad_mp = theta >= pi/2 & theta <= pi;

[R,THETA] = meshgrid(r_base,theta);

Q1_polar = R.*cos(THETA);
Q2_polar = R.*sin(THETA);

Q1_polar(quad_pp,:) = r1(2)*Q1_polar(quad_pp,:);
Q1_polar(quad_pm,:) = r1(2)*Q1_polar(quad_pm,:);
Q1_polar(quad_mp,:) = r1(1)*Q1_polar(quad_mp,:);
Q1_polar(quad_mm,:) = r1(1)*Q1_polar(quad_mm,:);

Q2_polar(quad_pp,:) = r2(2)*Q2_polar(quad_pp,:);
Q2_polar(quad_pm,:) = r2(1)*Q2_polar(quad_pm,:);
Q2_polar(quad_mp,:) = r2(2)*Q2_polar(quad_mp,:);
Q2_polar(quad_mm,:) = r2(1)*Q2_polar(quad_mm,:);

Q1_polar = Q1_polar + centre_x;
Q2_polar = Q2_polar + centre_y;

Q1_polar_lin = reshape(Q1_polar,1,mesh_points);
Q2_polar_lin = reshape(Q2_polar,1,mesh_points);


f_lin = restoring_force(Q1_polar_lin,Q2_polar_lin,omega_1,omega_2);
f2 = reshape(f_lin(2,:),NUM_THETA,NUM_R);
f1 = reshape(f_lin(1,:),NUM_THETA,NUM_R);

x1 = Q1_polar;
x2 = Q2_polar;

Grid_Data.centre = [centre_x,centre_y];
Grid_Data.radius = [r1(1),r2(1)];
Grid_Data.z_function = @(x,y,index) z_function(x,y,index,omega_1,omega_2);
end

function z = z_function(x,y,index,omega_1,omega_2)
    z_all = restoring_force(x,y,omega_1,omega_2); 
    z = z_all(index,:);
end