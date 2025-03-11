function plotting_path = get_plotting_path
FILE_SEPERATOR = "\";
function_path = mfilename("fullpath");

path_components = split(function_path,FILE_SEPERATOR);
project_path = join(path_components(1:(end-2)),FILE_SEPERATOR);
plotting_path = project_path{1};
end