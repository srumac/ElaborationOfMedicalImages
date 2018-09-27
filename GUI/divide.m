function [mov] = divide(name_video)
%% Divide function
% This function divides video in frames
%
%INPUTS: 'name_video': VideoReader object - the video
%
%OUTPUT: 'mov': struct containing video frames

ii = 1;
%for every frmae, save it in mov struct
while hasFrame(name_video)
         mov(ii) = im2frame(readFrame(name_video));
         ii = ii+1;
end
end