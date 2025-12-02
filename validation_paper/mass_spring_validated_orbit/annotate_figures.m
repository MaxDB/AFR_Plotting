clear 
close all

fig_name = "validation_orbit";



num_labels = {"1","text";
          "2","text";
          "3","text";
          "4","text";
          "5","text";
          "4","text";
          "3","text";
          "2","text"};

labels = [{"","arrow";
          "$\mathbf h(t_1)$",{"text","rotation",15};  
          "$q_1$","text";
          "$\dot{q}_1$","text";
          "$\mathbf r_2^*(t)$","label";
          "$\mathbf r_2^*(t) + \mathbf h(t)$","label"};
          num_labels];
%-----------------------------

%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")