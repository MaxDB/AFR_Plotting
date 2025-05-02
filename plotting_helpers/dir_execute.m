function varargout = dir_execute(target_dir,fun,varargin)
current_dir = pwd;
cd(target_dir)
try
    [varargout{1:nargout}] = fun(varargin{:});
    cd(current_dir)
catch exception
    cd(current_dir)
    rethrow(exception)
end
end