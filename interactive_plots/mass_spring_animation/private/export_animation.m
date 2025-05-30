function export_animation(animation,path)
path = "test";
vid = VideoWriter(path,"MPEG-4");
vid.FrameRate = animation.frame_rate;
vid.Quality = 100;



open(vid)
writeVideo(vid,animation.frames)
close(vid)
end