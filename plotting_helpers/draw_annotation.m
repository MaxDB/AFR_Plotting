function draw_annotation(fig,label)
ax = findall(fig,"Type","axes");
font_name = ax.FontName;
font_size = ax.FontSize;
font_units = ax.FontUnits;

%place text
text_style = {"FontName",font_name,"FontSize",font_size,"FontUnits",font_units};
if contains(label,"$")
    text_style((end+1):(end+2)) = {"Interpreter","latex"};
end

test_ax = axes("Visible","off");
test_text = text(test_ax,0.5,0.5,label,text_style{:});
text_size = test_text.Extent;
coord_conversion = @(ax_coord) axes_to_fig_coord(fig,ax_coord);
text_bottom_left = coord_conversion(text_size(1:2));
text_top_right = coord_conversion([text_size(1)+text_size(3),text_size(2)+text_size(4)]);
text_span = text_top_right - text_bottom_left;

% annotation(fig,"rectangle",[text_bottom_left,text_span])
delete(test_ax)

text_ann = annotation(fig,"textbox",[0.5,0.5,text_span],"String",label,text_style{:},"EdgeColor","none","Margin",0);
set(fig, 'WindowButtonMotionFcn', @(object,event_data) mouse_move_text(object,event_data,text_ann));
waitforbuttonpress
set(fig,"WindowButtonMotionFcn",'');


%convert between coordiantes
text_dim = text_ann.Position;

x_line = [text_dim(1),text_dim(1) + text_dim(3)];
y_line = [text_dim(2),text_dim(2)];
underline_ann = annotation(fig,"line",x_line,y_line);

%draw arraw
arrow_style = {"LineWidth",0.5,"HeadStyle","none","HeadLength",10,"HeadWidth",10};


x_arrow = [0.5,0.5];
y_arrow = [0.5,0.5];

% [x_arrow,y_arrow] = apply_arrow_offset(x_arrow,y_arrow,0.05);
arrow_ann = annotation(fig,"arrow",x_arrow,y_arrow,arrow_style{:});

set(fig, 'WindowButtonMotionFcn', @(object,event_data) mouse_move_arrow(object,event_data,arrow_ann,underline_ann));
fig.Pointer = "circle";
waitforbuttonpress
set(fig,"WindowButtonMotionFcn",'');
fig.Pointer = "arrow";

end

function fig_coord = axes_to_fig_coord(fig,ax_coord)
ax = findall(fig,"Type","Axes");
ax_position = ax.Position;
ax_xspan = [ax_position(1),ax_position(1) + ax_position(3)];
ax_yspan = [ax_position(2),ax_position(2) + ax_position(4)];
x_lim = ax.XLim;
y_lim = ax.YLim;

ax_x = ax_coord(1);
ax_x_norm = (ax_x - x_lim(1))/diff(x_lim);
fig_x = ax_xspan(1) + ax_x_norm*diff(ax_xspan);

ax_y = ax_coord(2);
ax_y_norm = (ax_y - y_lim(1))/diff(y_lim);
fig_y = ax_yspan(1) + ax_y_norm*diff(ax_yspan);

fig_coord = [fig_x,fig_y];
end

function [x_arrow,y_arrow] = apply_arrow_offset(x_arrow,y_arrow,offset)
arrow_line = [x_arrow(1);y_arrow(1)] + (1 - offset) * ([x_arrow(2);y_arrow(2)] - [x_arrow(1);y_arrow(1)]);

x_arrow(2) = arrow_line(1);
y_arrow(2) = arrow_line(2);
end

function mouse_move_text(object, eventdata, text_label)
    cursor_position = get(object, 'CurrentPoint');
    text_label.Position(1:2) = cursor_position./object.Position(3:4);
end

function mouse_move_arrow(object, eventdata, arrow_ann , underline_ann)
    cursor_position = get(object, 'CurrentPoint');
    arrow_ann.X(2) = cursor_position(1)/object.Position(3);
    arrow_ann.Y(2) = cursor_position(2)/object.Position(4);
    
    if arrow_ann.X(2) < underline_ann.X(1)
        arrow_ann.X(1) = underline_ann.X(1);
        arrow_ann.Y(1) = underline_ann.Y(1);
    else
        arrow_ann.X(1) = underline_ann.X(2);
        arrow_ann.Y(1) = underline_ann.Y(2);
    end
end