function varargout = dir_execute(target_dir,fun,varargin)
current_dir = pwd;
cd(target_dir)
[varargout{1:nargout}] = fun(varargin{:});
cd(current_dir)
end