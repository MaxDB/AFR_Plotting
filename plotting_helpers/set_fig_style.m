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

fontsize(fig,Plot_Settings.font_size,"points");
if ~isempty(Plot_Settings.font_name)
    fontname(fig,Plot_Settings.font_name);

    fig_children = findobj(fig,"Type","axes");%necessary for \rm to work
    num_children = size(fig_children,1);
    tex_font = "\fontname{"+Plot_Settings.font_name+"}";
    for iChild = 1:num_children
        fig_child = fig_children(iChild);
        if isa(fig_child.XLabel,"matlab.graphics.primitive.Text")
            set_label(fig_child,"x",tex_font + fig_child.XLabel.String);
        end
        if isa(fig_child.YLabel,"matlab.graphics.primitive.Text")
            set_label(fig_child,"y",tex_font + fig_child.YLabel.String);
        end
        if isa(fig_child.ZLabel,"matlab.graphics.primitive.Text")
            set_label(fig_child,"z",tex_font + fig_child.ZLabel.String);
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