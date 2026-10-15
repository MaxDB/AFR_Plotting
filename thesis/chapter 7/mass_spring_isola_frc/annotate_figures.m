clear 
close all

% fig_name = "mass_spring_frc_1";
% labels = {["ROM and FOM","are indistinguishable"],"text"};

% fig_name = "mass_spring_frc_2";
% labels = ["$\{1,2\}$-ROM";
%     "FOM"];

fig_name = "mass_spring_frc_3";
labels = ["$\{1,2\}$-ROM";
    "FOM"];



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")