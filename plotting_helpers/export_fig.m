function export_fig(figs,fig_names,Export_Settings)
DELIMINATOR = "\";

% default settings
Default_Settings.projection = "2D";
Default_Settings.file_type = "pdf";
Default_Settings.renderer = "painters";
Default_Settings.resolution = 300;
Default_Settings.font_size = 12;
Default_Settings.font_name = [];
Default_Settings.width = 8.4;
Default_Settings.height = 8.4;

settings = fieldnames(Default_Settings);
num_settings = size(settings,1);
for iSetting = 1:num_settings
    setting = settings{iSetting};
    if ~isfield(Export_Settings,setting)
        Export_Settings.(setting) = Default_Settings.(setting);
    end
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
    fig = figs{iFig};
    fig_name = fig_names(iFig);

    fig.Units = 'centimeters';
    fig.Position(3) = Export_Settings.width;
    fig.Position(4) = Export_Settings.height;
    fig.PaperSize = fig.InnerPosition([3,4]);

    fig.Renderer = Export_Settings.renderer;
    fontsize(fig,Export_Settings.font_size,"points");
    if ~isempty(Export_Settings.font_name)
        fontname(fig,Export_Settings.font_name);
    end

    % fixes display problems when projecting 3D plots to 2D
    if Export_Settings.projection == "2D"
        line_data = findall(fig,'type','line');
        set(line_data, 'ZData', [])
    end



    %save .fig
    fig_path = working_dir + DELIMINATOR + fig_name;
    saveas(fig,fig_path)

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