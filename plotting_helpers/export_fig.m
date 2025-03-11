function export_fig(figs,fig_names,Export_Settings)
DELIMINATOR = "\";

% default settings
if ~isstring(Export_Settings)
    settings_path = get_plotting_path();
    Default_Settings = read_default_options("plotting",settings_path);
    Export_Settings = update_options(Default_Settings,[],Export_Settings);
end
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

    if isstring(Export_Settings) && Export_Settings == "inherit"
        Export_Settings = fig.UserData;
    end
    fig.UserData = Export_Settings;

    fig = set_fig_style(fig,Export_Settings);
    
    % fixes display problems when projecting 3D plots to 2D
    if Export_Settings.projection == "2D"
        line_data = findall(fig,'type','line');
        set(line_data, 'ZData', [])
    end
    fig.Renderer = Export_Settings.renderer;
    %save .fig
    save_fig(fig,fig_name+"_export")

    % save image
    image_path = export_path + DELIMINATOR + fig_name;
    switch Export_Settings.file_type
        case "pdf"
            print(fig,image_path,'-dpdf')
        case "svg"
            print(fig,image_path,'-dsvg')
        case "png"
            print(fig,image_path,'-dpng',"-r" + Export_Settings.resolution)
        case "eps"
            print(fig,image_path,'-depsc2')

    end
end
end