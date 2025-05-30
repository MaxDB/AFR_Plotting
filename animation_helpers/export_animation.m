function export_animation(animation,path,varargin)
%-------------------------------------------------------------------------%
num_args = length(varargin);
if mod(num_args,2) == 1
    error("Invalid keyword/argument pairs")
end
keyword_args = varargin(1:2:num_args);
keyword_values = varargin(2:2:num_args);


for arg_counter = 1:num_args/2
    switch keyword_args{arg_counter}
        otherwise
            error("Invalid keyword: " + keyword_args{arg_counter})
    end
end
%-------------------------------------------------------------------------%


vid = VideoWriter(path,"MPEG-4");
vid.FrameRate = animation.frame_rate;
vid.Quality = 100;


frames = animation.frames;



open(vid)
writeVideo(vid,frames)
close(vid)
end
