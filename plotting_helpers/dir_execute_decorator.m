function out_function = dir_execute(in_function,target_dir)
arguments
    in_function (1,1) function_handle
    target_dir (1,1) string
end
out_function = @(varargin) decorate(in_function,target_dir,varargin{:});
end

function varargout = decorate(fun, target_dir,varargin)
current_dir = pwd;    
cd(target_dir)
[varargout{1:nargout}] = fun(varargin{:});
cd(current_dir)
end