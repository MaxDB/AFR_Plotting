function export_fig(fig,fig_name,Export_Settings)
DELIMINATOR = "\";

% default settings
Default_Settings.projection = "2D";
Default_Settings.file_type = "pdf";
Default_Settings.renderer = "painters";

settings = fieldnames(Default_Settings);
num_settings = size(settings,1);
for iSetting = 1:num_settings
    setting = settings{iSetting};
    if ~isfield(Export_Settings,setting)
        Export_Settings.(setting) = Default_Settings.(setting);
    end
end


% export to temp file
working_dir = pwd;
cd ..
path = pwd + DELIMINATOR; 
cd(working_dir)
fig.Renderer = Export_Settings.renderer; 

% fixes display problems when projecting 3D plots to 2D
if Export_Settings.projection == "2D"
    line_data = findall(fig,'type','line');
    set(line_data, 'ZData', [])
end

export_path = path + "temp";
if isfolder(export_path)
    rmdir(export_path,'s')
end
mkdir(export_path)


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

end
end