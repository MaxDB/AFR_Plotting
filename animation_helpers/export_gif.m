function export_gif(animation,path,varargin)
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

frames = animation.frames;
frame_delay = 1/animation.frame_rate;
images = arrayfun(@frame2im,frames,"UniformOutput",false);
num_frames = size(images,2);


gif_export = {"DelayTime",frame_delay,"TransparentColor",0,"DisposalMethod","restoreBG"};




file_name = path + ".gif"; % Specify the output file name
for iFrame = 1:num_frames
    [rgb_frame,colour_map] = rgb2ind(images{iFrame},256);
    % mass_index = find(ismembertol(colour_map,mass_colour,"ByRows",true));
    background_index = double(rgb_frame(2,2));
    % num_colours = size(colour_map,1);
    % for iColour = 1:num_colours
    %     if iColour == background_index
    %         continue
    %     end
    %     colour_map(iColour,:) = colour_map(mass_index,:);
    % end
    gif_export{4} = background_index;
    if iFrame == 1
        imwrite(rgb_frame,colour_map,file_name,"gif","LoopCount",Inf, ...
                gif_export{:})
    else
        imwrite(rgb_frame,colour_map,file_name,"gif","WriteMode","append", ...
                gif_export{:})
    end
end


end
