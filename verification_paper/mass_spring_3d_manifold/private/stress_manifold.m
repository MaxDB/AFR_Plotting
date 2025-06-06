function x_tilde = stress_manifold(X,omega_1,omega_2)
%    This function was generated by the Symbolic Math Toolbox version 24.2.
%    20-Sep-2024 15:43:14

t2 = X.*2.0;
t3 = X.^2;
t4 = omega_1.^2;
t5 = omega_2.^2;
t9 = sqrt(3.0);
t6 = t5.^2;
t7 = 1.0./t4;
t10 = X.*t4;
t11 = X.*t5;
t19 = t9.*5.0e-1i;
t8 = t7.^2;
t13 = t5.*t7;
t25 = t5+t10+t11;
t27 = t19+1.0./2.0;
t30 = t19-1.0./2.0;
t12 = t8.^2;
t14 = t13.*2.0;
t15 = t13.*3.0;
t16 = t13+1.0;
t17 = t6.*t8.*9.0;
t20 = t13./2.0;
t21 = t13.*(3.0./2.0);
t23 = t6.*t8.*(9.0./4.0);
t31 = t25.^2;
t34 = t5.*t8.*t25.*2.7e+1;
t18 = t15+3.0;
t26 = t3.*t16;
t28 = t20+1.0./2.0;
t29 = t21+3.0./2.0;
t35 = -t34;
t38 = t6.*t12.*t31.*7.29e+2;
t32 = 1.0./t29;
t33 = t3.*t28;
t36 = t2+t14+t26;
t37 = X+t13+t33;
t39 = t18.*t36;
t40 = t29.*t37;
t42 = -(t17-t39).^3;
t44 = t38+t42;
t45 = sqrt(t44);
t46 = t35+t45;
t47 = t46.^(1.0./3.0);
t48 = 1.0./t47;
x_tilde = [-t32.*(t21+t47./2.0+t48.*(t23-t40).*2.0);-t32.*(t21+(t30.*t47)./2.0+(t48.*(t23-t40).*2.0)./t30);t32.*(-t21+(t27.*t47)./2.0+(t48.*(t23-t40).*2.0)./t27)];
end
