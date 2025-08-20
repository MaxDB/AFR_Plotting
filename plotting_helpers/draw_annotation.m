function annotation_progress = draw_annotation(fig,label)
ax = get_main_axes(fig);
annotation_progress = 0;

font_name = ax.FontName;
font_size = ax.FontSize;
font_units = ax.FontUnits;



if size(label,2) == 1
    label = [label,"label"];
end





label_text = label{1};
label_mode = label{2};

additional_text_args = {};
if iscell(label_mode)
    additional_text_args = label_mode(2:end);
    label_mode = label_mode{1};
end

if label_mode == "skip"
    return
end
%-----------------------
import java.awt.Robot;
import java.awt.*;
mouse = Robot;

set(fig, 'WindowKeyPressFcn', @(object,event_data) move_mouse(object,event_data,mouse));




%place text
text_style = [{"FontName",font_name,"FontSize",font_size,"FontUnits",font_units,"BackgroundColor","white"},additional_text_args];
if contains(label_text,"$")
    text_style((end+1):(end+2)) = {"Interpreter","latex"};
end

test_ax = axes("Visible","off");
test_text = text(test_ax,0.5,0.5,label_text,text_style{:});
text_size = test_text.Extent;
coord_conversion = @(ax_coord) axes_to_fig_coord(fig,ax_coord);
text_bottom_left = coord_conversion(text_size(1:2));
text_top_right = coord_conversion([text_size(1)+text_size(3),text_size(2)+text_size(4)]);
text_span = text_top_right - text_bottom_left;

% annotation(fig,"rectangle",[text_bottom_left,text_span])
delete(test_ax)

text_ann = annotation(fig,"textbox",[0.5,0.5,text_span],"String",label_text,text_style{:},"EdgeColor","none","Margin",0,"FitBoxToText","on");


text_dim = text_ann.Position;
if label_mode ~= "text"
    x_line = [text_dim(1),text_dim(1) + text_dim(3)];
    y_line = [text_dim(2),text_dim(2)];
    underline_ann = annotation(fig,"line",x_line,y_line);
else
    underline_ann = [];
end

set(fig, 'WindowButtonMotionFcn', @(object,event_data) mouse_move_text(object,event_data,text_ann,underline_ann));
mouse_click = 0;
while ~mouse_click
    mouse_click = ~waitforbuttonpress;  
end
if fig.SelectionType == "alt"
    set(fig,"WindowButtonMotionFcn",'');
    set(fig, 'WindowKeyPressFcn','');
    return
end
annotation_progress = annotation_progress + 1;
annotation_progress = annotation_progress + 1;
set(fig,"WindowButtonMotionFcn",'');


if label_mode == "text"
    set(fig, 'WindowKeyPressFcn','');
    clear mouse
    return
end

%convert between coordiantes
text_dim = text_ann.Position;




head_style = "none";
if label_mode == "arrow"
    delete(text_ann)
    delete(underline_ann)
    clear("underline_ann")
    underline_ann.X = [text_dim(1),text_dim(1)];
    underline_ann.Y = [text_dim(2),text_dim(2)];
    head_style = "vback2";
end

%draw arraw
arrow_style = {"LineWidth",0.5,"HeadStyle",head_style,"HeadLength",10,"HeadWidth",10};


x_arrow = [0.5,0.5];
y_arrow = [0.5,0.5];

% [x_arrow,y_arrow] = apply_arrow_offset(x_arrow,y_arrow,0.05);

% zoom_fig = copyobj(fig,groot);
% zoom_ax = zoom_fig.Children(1);
% zoom_ax = project_to_2d(zoom_ax);
% ax_lims = [ax.XLim;ax.YLim;ax.ZLim];

arrow_ann = annotation(fig,"arrow",x_arrow,y_arrow,arrow_style{:});


set(fig, 'WindowButtonMotionFcn', @(object,event_data) mouse_move_arrow(object,event_data,arrow_ann,underline_ann));
fig.Pointer = "circle";
mouse_click = 0;
while ~mouse_click
    mouse_click = ~waitforbuttonpress;
end
if fig.SelectionType == "alt"
    set(fig,"WindowButtonMotionFcn",'');
    set(fig, 'WindowKeyPressFcn','');
    return
end
annotation_progress = annotation_progress + 1;
set(fig,"WindowButtonMotionFcn",'');
fig.Pointer = "arrow";


set(fig, 'WindowKeyPressFcn','');
clear mouse

end

function ax = get_main_axes(fig)
ax = findall(fig,"Type","axes");
num_axes = size(ax,1);
main_index = 0;
max_size = 0;
for iAx = 1:num_axes
    ax_area = ax(iAx).Position(3)*ax(iAx).Position(4);
    if ax_area > max_size
        main_index = iAx;
        max_size = ax_area;
    end
end
ax = ax(main_index);

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

function mouse_move_text(object, eventdata, text_label, text_underline)
    cursor_position = get(object, 'CurrentPoint');

    text_position = cursor_position./object.Position(3:4);
    text_label.Position(1:2) = text_position;
    
    if ~isempty(text_underline)
        x_line = [text_position(1),text_position(1) +  text_label.Position(3)];
        y_line = [text_position(2),text_position(2)];

        text_underline.X = x_line;
        text_underline.Y = y_line;
    end
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
    %---
    % cursor_position = get(gca, 'CurrentPoint');
    % zoom_factor = 10;
    % cursor_x = cursor_position(1,1);
    % cursor_y = cursor_position(1,2);
    % cursor_z = cursor_position(1,3);
    % 
    % zoom_lims = [-0.5,0.5].*diff(ax_lims,1,2)/zoom_factor;
    % xlim(zoom_ax,cursor_x + zoom_lims(1,:))
    % ylim(zoom_ax,cursor_y + zoom_lims(2,:))
    % zlim(zoom_ax,cursor_z + zoom_lims(3,:))
end

function move_mouse(object,event_data,mouse)
import java.awt.event.InputEvent;
import java.awt.MouseInfo;

switch event_data.Key
    case 'leftarrow'
        direction = [-1,0];
    case 'rightarrow'
        direction = [1,0];
    case 'uparrow'
        direction = [0,-1];
    case 'downarrow'
        direction = [0,1];
    case 'return'
        mouse.mousePress(InputEvent.BUTTON1_MASK);
        mouse.mouseRelease(InputEvent.BUTTON1_MASK);
        return
    case 'b'
        annotations = get_annotation_handles(object);
        num_children = length(annotations.Children);
        for iChild = 1:num_children
            child = annotations.Children(iChild);
            if isa(child,"matlab.graphics.shape.TextBox")
                if ischar(child.BackgroundColor)
                    if child.BackgroundColor == "none"
                        child.BackgroundColor = [1,1,1];
                    end
                elseif isequal(child.BackgroundColor,[1,1,1])
                    child.BackgroundColor = "none";

                end
                return
            end
        end
        return
    otherwise
        return
end
mouse_position = MouseInfo.getPointerInfo().getLocation();
mouse.mouseMove(mouse_position.x + direction(1),mouse_position.y + direction(2));
end