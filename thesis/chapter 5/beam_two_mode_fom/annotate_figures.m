clear 
close all

fig_name = "beam_two_mode_comp_1";

% labels = {
%     "$R^2 = 1.000$","text";
%     "$R^2 = 1.000$","text";
%     "$R^2 = 1.000$","text";
%     };

labels = {
    "$R^2 = 1.000$","text";
    "For all","text";
    };



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")