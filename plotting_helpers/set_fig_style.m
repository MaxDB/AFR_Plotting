function fig = set_fig_style(fig,Plot_Settings)
% default settings
settings_path = get_plotting_path();
Default_Settings = read_default_options("plotting",settings_path);
Plot_Settings = update_options(Default_Settings,[],Plot_Settings);

fig.Units = 'centimeters';
if ~isempty(Plot_Settings.width)
    fig.Position(3) = Plot_Settings.width;
end
if ~isempty(Plot_Settings.height)
    fig.Position(4) = Plot_Settings.height;
end
fig.PaperSize = fig.InnerPosition([3,4]);
ax = findobj(fig,"Type","axes");
num_axes = numel(ax);

if num_axes == 1 || isscalar(Plot_Settings.font_size)
    fontsize(fig,max(Plot_Settings.font_size),"points");
else
    fontsize(fig,max(Plot_Settings.font_size),"points");
    for iAx = 1:num_axes
        fontsize(ax(iAx),Plot_Settings.font_size(iAx),"points");
    end
end
if ~isempty(Plot_Settings.font_name)
    fontname(fig,Plot_Settings.font_name);

    fig_children = findobj(fig,"Type","axes");%necessary for \rm to work
    num_children = size(fig_children,1);
    tex_font = "\fontname{"+Plot_Settings.font_name+"}";
    for iChild = 1:num_children
        fig_child = fig_children(iChild);
        x_label = fig_child.XLabel;
        if isa(x_label,"matlab.graphics.primitive.Text")
            if x_label.Interpreter == "tex"
                set_label(fig_child,"x",tex_font + x_label.String);
            end
        end
        y_label = fig_child.YLabel;
        if isa(y_label,"matlab.graphics.primitive.Text")
            if y_label.Interpreter == "tex"
                set_label(fig_child,"y",tex_font + y_label.String);
            end
        end
        z_label = fig_child.ZLabel;
        if isa(z_label,"matlab.graphics.primitive.Text")
            if z_label.Interpreter == "tex"
                set_label(fig_child,"z",tex_font + z_label.String);
            end
        end

    end
end

if Plot_Settings.axes == "off"
    ax = findall(fig,"Type","axes");
    if size(ax,1) > 1
        ax = ax(end);
    end
    axis(ax,"off")
end


 
end