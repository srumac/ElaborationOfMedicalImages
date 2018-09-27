function [video_new] = save_video(filename, mov_new, workingDir);
%%This function save as AVI file the original video with green squares
%%detecting faces. 
%INPUTS: -filename, in the form filename.avi. This will be the name of the
%              file
%             - mov_new, the frames of the new video from the function
%             detect
%             - workingDir, from uigetdir. The folder where the file will
%             be saved


video_new = VideoWriter(fullfile(workingDir,filename));
open(video_new)

for ii = 1:length(mov_new)
   writeVideo(video_new,mov_new(ii))
end

close(video_new)