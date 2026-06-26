function ax = scale_axis(ax,axis_id,factor)


axis_id = upper(string(axis_id));
switch axis_id
    case {"1","X"}
        axis_type = "X";
    case {"2","Y"}
        axis_type = "Y";
    case {"3","Z"}
        axix_type = "Z";
end 

lim_name = axis_type + "lim";
data_name = axis_type + "data";

scale_property = @(obj,property) set(obj,property,get(obj,property)*factor);

%--
scale_property(ax,lim_name)
%--
lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    if isprop(lines,data_name)
        scale_property(lines(iLine),data_name)
    end
end

%--
%axis ticks and labels?


end