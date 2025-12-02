clear 
close all

fig_name = "validation_manifold";



labels = {"$\hat{\mathbf x}^*(t)$","label";
          "$\tilde{\mathbf x}^*(t)$","label";
          "$\mathcal V_{\mathbf r^*_2(t_3)}$",{"text","Rotation",7};
          "$\mathcal V_{\mathbf r^*_2(t_2)}$",{"text","Rotation",20};
          "$\mathcal V_{\mathbf r^*_2(t_1)}$",{"text","Rotation",28};
          "$\mathcal V_{\mathbf r^*_2(t_4)}$",{"text","Rotation",-5};
          "$\mathcal V_{\mathbf r^*_2(t_5)}$",{"text","Rotation",-13};
          "1","text";
          "2","text";
          "3","text";
          "4","text";
          "5","text";
          "1","text";
          "2","text";
          "4",{"text","Color",[89,128,122]/256};
          "5","text"};


%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")