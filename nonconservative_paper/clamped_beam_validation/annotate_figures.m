clear 
close all

fig_num = 4;
fig_name = "validation_"+fig_num;



switch fig_num
    case 1
        labels = ["$\{1\}$-ROM";
            "$\{1\}:\{1,2\}$";
            "$\{1\}:\{1,3\}$";
            "$\{1\}:\{1,1001\}$"];
    case 2
        labels = ["$\{1,1001\}$-ROM";
            "$\{1,1001\}:\{1,1001,2\}$";
            "$\{1,1001\}:\{1,1001,3\}$"];
    case 3
        labels = ["$x = 3$";
            "$x = 5$";
            "$x=6$";
            "$x=8$"];
    case 4
        labels = ["$\{1\}$-ROM";
            "$\{1\}:\{1,2\}$";
            "$\{1\}:\{1,3\}$"];
end



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")