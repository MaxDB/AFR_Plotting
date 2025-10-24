function export_fig(figs,fig_names,Export_Settings)
DELIMINATOR = "\";


%----------------------------------------------------------------------


% export to temp file
working_dir = pwd;
cd ..
path = pwd + DELIMINATOR; 
cd(working_dir)

export_path = path + "temp";
if isfolder(export_path)
    rmdir(export_path,'s')
end
mkdir(export_path)

num_figs = size(figs,1);
for iFig = 1:num_figs
    if iscell(figs)
        fig = figs{iFig};
    else
        fig = figs;
    end
    fig_name = fig_names(iFig);

    if length(Export_Settings) > 1
        Fig_Export_Settings = Export_Settings(iFig);
    else
        Fig_Export_Settings = Export_Settings;
    end

    % default settings
    if ~isstring(Fig_Export_Settings)
        settings_path = get_plotting_path();
        Default_Settings = read_default_options("plotting",settings_path);
        Fig_Export_Settings = update_options(Default_Settings,[],Fig_Export_Settings);
    end


    if isstring(Fig_Export_Settings) && Fig_Export_Settings == "inherit"
        Fig_Export_Settings = fig.UserData;
    end
    fig.UserData = Fig_Export_Settings;

    fig = set_fig_style(fig,Fig_Export_Settings);
    fig.Position(1:2) = [1,2];
    
    % fixes display problems when projecting 3D plots to 2D
    if Fig_Export_Settings.projection == "2D"
        line_data = findall(fig,'type','line');
        set(line_data, 'ZData', [])
    end
    fig.Renderer = Fig_Export_Settings.renderer;
    %save .fig
    save_fig(fig,fig_name+"_export")

    % save image
    image_path = export_path + DELIMINATOR + fig_name;
    switch Fig_Export_Settings.file_type
        case "pdf"
            print(fig,image_path,'-dpdf')
        case "svg"
            print(fig,image_path,'-dsvg')
        case "png"
            print(fig,image_path,'-dpng',"-r" + Fig_Export_Settings.resolution)
        case "eps"
            print(fig,image_path,'-depsc2')

    end
end
end