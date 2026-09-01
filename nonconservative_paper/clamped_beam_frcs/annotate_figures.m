clear 
close all

fig_num = 3;
fig_name = "frc_"+fig_num;



switch fig_num
    case 1
        labels = ["$\{1,3\}$-ROM";
            "FOM"];
    case 2
        labels = ["$\{1,3\}$-ROM";
            "FOM";
            "$\{1,2,1001\}$-ROM"];
    case 3
        labels = ["FOM";
            "$\{1,2,1001\}$-ROM";
            "$\{1\}$-ROM";
            "$\{1,1001\}$-ROM";
            "$\{1,2\}$-ROM"];
end



%-----------------------------
[fig,fig_name] = annotate_fig(fig_name,labels);
%------------------------------
export_fig(fig,fig_name,"inherit")