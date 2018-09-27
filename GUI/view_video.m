function view_video(video, mov)
%% View video function
%This function displays video
%
%INPUT: 'video': VideoReader object, the video
%'mov': struct containing frames

figure
imshow(mov(1).cdata, 'Border', 'tight')
movie(mov,1,video.FrameRate)
end