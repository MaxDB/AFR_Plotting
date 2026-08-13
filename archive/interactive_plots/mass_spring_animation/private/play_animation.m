function play_animation(animation,repeats)
if nargin == 1
    repeats = 1;
end
fig = figure;
fig.Position = animation.size;
movie(fig,animation.frames,repeats,animation.frame_rate)
end