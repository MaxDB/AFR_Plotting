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
end


 
end