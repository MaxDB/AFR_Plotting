clear 
close all

fig_num = 1;
fig_name = "validation_"+fig_num;



switch fig_num
    case 1
        labels = ["$\{1\}$-ROM";
            "$\{1\}:\{1,2\}$";
            "$\{1\}:\{1,1001\}$"];
    case 2
        labels = ["$\{1,2\}$-ROM";
            "$\{1,2\}:\{1,2,1001\}$"];
    case 3
end



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")