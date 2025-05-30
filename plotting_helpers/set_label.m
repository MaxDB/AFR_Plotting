function set_label(ax,axis,text,interpreter)
if nargin == 3
    interpreter = "tex";
end
switch axis
    case "x"
        axis_label = @(text,interpreter) xlabel(ax,text,"Interpreter",interpreter);
    case "y"
        axis_label = @(text,interpreter) ylabel(ax,text,"Interpreter",interpreter);
    case "z"
        axis_label = @(text,interpreter) zlabel(ax,text,"Interpreter",interpreter);
end
axis_label(text,interpreter)